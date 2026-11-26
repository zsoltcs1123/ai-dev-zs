#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
CONTRACT_PATH="$SKILL_DIR/contract.md"
DEFAULT_AGENT_MODEL="composer-2.5"
DEFAULT_BASE_BRANCH=main

MAIN_ROOT=""
REPO_KEY=""
REPO_NOTE_PATH=""
DATA_ROOT=""
RUN_TMP_ROOT=""

usage() {
  cat <<'EOF'
Usage: delivery.sh <command> [args]

Commands:
  repo-note                 Print durable repo note path (creates parent dir)
  start <branch> [options]  Provision a delivery and optionally run it
  watch <branch|path> [-f]  Show headless agent progress (--follow to stream)
  list                      List worktrees and delivery run state
  remove <branch|path>      Remove a worktree (non-destructive; warns if dirty)
  doctor                    Repo note path, worktrees, headless agent health

start options:
  --plan <file|name>        Plan to implement (name matches ~/.cursor/plans/*.plan.md)
  --prompt <text>           Ad-hoc task text instead of a plan file
  --headless                Run cursor-agent in background (log under tmp delivery dir)
  --model <model>           Agent model for --headless (default: composer-2.5)
  --no-worktree             Run in the main checkout instead of a sibling worktree

Repo facts live in a markdown note outside the repo (see repo-note). The script does not
write state into the target repository. Sibling worktrees: ../<repo-name>-<slug>.
EOF
}

die() {
  echo "delivery.sh: $*" >&2
  exit 1
}

discover_main_root() {
  local start="${1:-$PWD}"
  git -C "$start" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git checkout (cwd: $start)"
  MAIN_ROOT="$(git -C "$start" worktree list --porcelain | awk '/^worktree / { print $2; exit }')"
  [[ -n "$MAIN_ROOT" && -d "$MAIN_ROOT" ]] || die "could not resolve the main checkout"
}

origin_url() {
  git -C "$MAIN_ROOT" remote get-url origin 2>/dev/null || true
}

repo_key_from_origin() {
  local url host path part
  url="$(origin_url)"
  [[ -n "$url" ]] || return 1
  url="${url%.git}"
  if [[ "$url" =~ ^git@([^:]+):(.+)$ ]]; then
    host="${BASH_REMATCH[1]}"
    path="${BASH_REMATCH[2]}"
    printf '%s/%s' "$host" "$path"
    return 0
  fi
  if [[ "$url" =~ ^https?://([^/]+)/(.+)$ ]]; then
    host="${BASH_REMATCH[1]}"
    path="${BASH_REMATCH[2]}"
    printf '%s/%s' "$host" "$path"
    return 0
  fi
  return 1
}

repo_key_local() {
  local hash
  if command -v sha256sum >/dev/null 2>&1; then
    hash="$(printf '%s' "$MAIN_ROOT" | sha256sum | awk '{print $1}' | cut -c1-16)"
  elif command -v shasum >/dev/null 2>&1; then
    hash="$(printf '%s' "$MAIN_ROOT" | shasum -a 256 | awk '{print $1}' | cut -c1-16)"
  else
    hash="$(printf '%s' "$MAIN_ROOT" | cksum | awk '{print $1}')"
  fi
  printf 'local/%s' "$hash"
}

compute_repo_key() {
  if repo_key_from_origin; then
    :
  else
    repo_key_local
  fi
}

data_root_dir() {
  local base="${XDG_DATA_HOME:-$HOME/.local/share}"
  printf '%s/delivery' "$base"
}

repo_note_path() {
  echo "$DATA_ROOT/$REPO_KEY/repo.md"
}

run_tmp_root() {
  local uid="${UID:-0}"
  local base="${TMPDIR:-/tmp}"
  printf '%s/delivery/%s/%s' "$base" "$uid" "$REPO_KEY"
}

init_repo_paths() {
  discover_main_root
  REPO_KEY="$(compute_repo_key)"
  DATA_ROOT="$(data_root_dir)"
  REPO_NOTE_PATH="$(repo_note_path)"
  RUN_TMP_ROOT="$(run_tmp_root)"
}

branch_slug() {
  local branch="$1"
  if [[ "$branch" == */* ]]; then
    echo "${branch#*/}"
  else
    echo "$branch"
  fi
}

repo_dir_basename() {
  local name
  name="$(basename "$MAIN_ROOT")"
  name="${name// /-}"
  printf '%s' "$name"
}

worktree_path_for_branch() {
  local branch="$1"
  local slug rname
  slug="$(branch_slug "$branch")"
  rname="$(repo_dir_basename)"
  echo "$(dirname "$MAIN_ROOT")/${rname}-${slug}"
}

default_base_branch() {
  local ref
  ref="$(git -C "$MAIN_ROOT" symbolic-ref -q refs/remotes/origin/HEAD 2>/dev/null || true)"
  if [[ -n "$ref" ]]; then
    echo "${ref#refs/remotes/origin/}"
    return
  fi
  if git -C "$MAIN_ROOT" show-ref --verify --quiet refs/heads/main; then
    echo main
    return
  fi
  if git -C "$MAIN_ROOT" show-ref --verify --quiet refs/heads/master; then
    echo master
    return
  fi
  echo "$DEFAULT_BASE_BRANCH"
}

run_dir_for_slug() {
  echo "$RUN_TMP_ROOT/$(branch_slug "$1")"
}

manifest_path() {
  echo "$1/manifest.env"
}

write_manifest() {
  local run_dir="$1"
  local branch="$2"
  local delivery_path="$3"
  local base_branch="$4"
  local no_worktree="$5"
  local plan_file="${6:-}"
  mkdir -p "$run_dir"
  {
    printf 'DELIVERY_BRANCH=%s\n' "$branch"
    printf 'DELIVERY_PATH=%s\n' "$delivery_path"
    printf 'DELIVERY_MAIN_ROOT=%s\n' "$MAIN_ROOT"
    printf 'DELIVERY_BASE_BRANCH=%s\n' "$base_branch"
    printf 'DELIVERY_REPO_NOTE=%s\n' "$REPO_NOTE_PATH"
    printf 'DELIVERY_NO_WORKTREE=%s\n' "$no_worktree"
    if [[ -n "$plan_file" ]]; then
      printf 'DELIVERY_PLAN_FILE=%s\n' "$plan_file"
    fi
  } >"$(manifest_path "$run_dir")"
}

manifest_value() {
  local file="$1"
  local key="$2"
  awk -F= -v k="$key" '$1 == k { print substr($0, index($0, "=") + 1); exit }' "$file"
}

find_run_dir() {
  local target="$1"
  local delivery_path branch slug run_dir manifest

  if [[ -d "$target" ]]; then
    delivery_path="$(realpath -m "$target")"
    if [[ -f "$(manifest_path "$delivery_path")" ]]; then
      echo "$delivery_path"
      return 0
    fi
    for run_dir in "$RUN_TMP_ROOT"/*; do
      [[ -d "$run_dir" ]] || continue
      manifest="$(manifest_path "$run_dir")"
      [[ -f "$manifest" ]] || continue
      if [[ "$(manifest_value "$manifest" DELIVERY_PATH)" == "$delivery_path" ]]; then
        echo "$run_dir"
        return 0
      fi
    done
    return 1
  fi

  if [[ "$target" == */* ]]; then
    branch="$target"
    slug="$(branch_slug "$branch")"
    run_dir="$RUN_TMP_ROOT/$slug"
    if [[ -f "$(manifest_path "$run_dir")" ]]; then
      echo "$run_dir"
      return 0
    fi
    delivery_path="$(worktree_path_for_branch "$branch")"
    if [[ -d "$delivery_path" ]]; then
      for run_dir in "$RUN_TMP_ROOT"/*; do
        [[ -d "$run_dir" ]] || continue
        manifest="$(manifest_path "$run_dir")"
        [[ -f "$manifest" ]] || continue
        if [[ "$(manifest_value "$manifest" DELIVERY_BRANCH)" == "$branch" ]]; then
          echo "$run_dir"
          return 0
        fi
      done
    fi
  fi

  slug="$target"
  run_dir="$RUN_TMP_ROOT/$slug"
  if [[ -f "$(manifest_path "$run_dir")" ]]; then
    echo "$run_dir"
    return 0
  fi

  delivery_path="$(dirname "$MAIN_ROOT")/$(repo_dir_basename)-${slug}"
  if [[ -d "$delivery_path" ]]; then
    for run_dir in "$RUN_TMP_ROOT"/*; do
      [[ -d "$run_dir" ]] || continue
      manifest="$(manifest_path "$run_dir")"
      [[ -f "$manifest" ]] || continue
      if [[ "$(manifest_value "$manifest" DELIVERY_PATH)" == "$delivery_path" ]]; then
        echo "$run_dir"
        return 0
      fi
    done
  fi
  return 1
}

resolve_delivery_path() {
  local target="$1"
  local run_dir manifest
  if [[ -d "$target" ]]; then
    echo "$(realpath -m "$target")"
    return
  fi
  run_dir="$(find_run_dir "$target" 2>/dev/null || true)"
  if [[ -n "$run_dir" && -f "$(manifest_path "$run_dir")" ]]; then
    manifest_value "$(manifest_path "$run_dir")" DELIVERY_PATH
    return
  fi
  if [[ "$target" == */* ]]; then
    worktree_path_for_branch "$target"
    return
  fi
  echo "$(dirname "$MAIN_ROOT")/$(repo_dir_basename)-${target}"
}

resolve_plan_file() {
  local ref="$1"
  if [[ -f "$ref" ]]; then
    echo "$ref"
    return 0
  fi
  local plans_dir="$HOME/.cursor/plans"
  local matches=()
  if [[ -d "$plans_dir" ]]; then
    while IFS= read -r match; do
      matches+=("$match")
    done < <(find "$plans_dir" -maxdepth 1 -name "*${ref}*.plan.md" 2>/dev/null)
  fi
  case "${#matches[@]}" in
    0) echo "no plan file found for '$ref'" >&2; return 1 ;;
    1) echo "${matches[0]}" ;;
    *) echo "ambiguous plan '$ref' matches: ${matches[*]}" >&2; return 1 ;;
  esac
}

ensure_agent_ready() {
  command -v cursor-agent >/dev/null 2>&1 || die "cursor-agent not installed (curl https://cursor.com/install -fsS | bash)"
  if ! cursor-agent status --format json 2>/dev/null | grep -q '"isAuthenticated": *true'; then
    die "cursor-agent not authenticated — run 'cursor-agent login' first"
  fi
}

build_contract_prompt() {
  local plan_content="$1"
  local base_branch="$2"
  local note_excerpt=""
  if [[ -f "$REPO_NOTE_PATH" ]]; then
    note_excerpt="$(cat "$REPO_NOTE_PATH")"
  else
    note_excerpt="(repo note missing — discover repo commands before implementing; write $REPO_NOTE_PATH)"
  fi
  cat <<EOF
$(cat "$CONTRACT_PATH")

--- REPO ---
main_checkout: $MAIN_ROOT
repo_note: $REPO_NOTE_PATH
default_pr_base: $base_branch
git_workflows: $SKILL_DIR/references/git-workflows.md

--- REPO NOTE ---
$note_excerpt

--- PLAN ---
$plan_content

Implement the plan above per the execution contract. Do not edit the plan file itself.
EOF
}

write_plan_copy() {
  local run_dir="$1"
  local content="$2"
  mkdir -p "$run_dir"
  printf '%s\n' "$content" >"$run_dir/plan.md"
}

launch_agent_background() {
  local worktree="$1"
  local model="$2"
  local prompt="$3"
  local run_dir="$4"
  local log_file pid_file prompt_file
  log_file="$run_dir/agent.log"
  pid_file="$run_dir/agent.pid"
  prompt_file="$run_dir/prompt.txt"
  mkdir -p "$run_dir"
  : >"$log_file"
  printf '%s' "$prompt" >"$prompt_file"

  setsid bash -c '
    cursor-agent --workspace "$1" --model "$2" \
      --print --output-format stream-json --force --trust \
      "$(cat "$3")" >>"$4" 2>&1
  ' _ "$worktree" "$model" "$prompt_file" "$log_file" </dev/null >/dev/null 2>&1 &
  echo $! >"$pid_file"

  echo "Agent started in background (PID $(cat "$pid_file"))."
  echo "  log:    $log_file"
  echo "  prompt: $prompt_file"
  echo "  watch:  delivery.sh watch $worktree [--follow]"
}

provision_worktree() {
  local branch="$1"
  local worktree="$2"
  local no_worktree="${3:-0}"

  if [[ "$no_worktree" -eq 1 ]]; then
    if git -C "$MAIN_ROOT" show-ref --verify --quiet "refs/heads/$branch"; then
      git -C "$MAIN_ROOT" checkout "$branch"
    else
      git -C "$MAIN_ROOT" checkout -b "$branch"
    fi
    return
  fi

  if [[ -d "$worktree" ]]; then
    echo "Refreshing existing worktree at $worktree" >&2
  elif git -C "$MAIN_ROOT" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$MAIN_ROOT" worktree add "$worktree" "$branch"
  else
    git -C "$MAIN_ROOT" worktree add -b "$branch" "$worktree"
  fi
}

print_provision_summary() {
  local worktree="$1"
  local branch="$2"
  local base_branch="$3"
  local run_dir="$4"
  local no_worktree="${5:-0}"

  if [[ "$no_worktree" -eq 1 ]]; then
    cat <<EOF

Delivery ready (main checkout):
  branch:       $branch
  path:         $worktree
  pr_base:      $base_branch
  repo_note:    $REPO_NOTE_PATH
  run_state:    $run_dir
EOF
    return
  fi

  cat <<EOF

Worktree ready:
  branch:       $branch
  path:         $worktree
  pr_base:      $base_branch
  repo_note:    $REPO_NOTE_PATH
  run_state:    $run_dir

In worktree mode, do not start or stop shared infra unless the repo note says you are in the main checkout.
EOF
}

cmd_repo_note() {
  init_repo_paths
  mkdir -p "$(dirname "$REPO_NOTE_PATH")"
  echo "$REPO_NOTE_PATH"
}

cmd_start() {
  local branch=""
  local headless=0
  local no_worktree=0
  local agent_model="$DEFAULT_AGENT_MODEL"
  local plan_ref=""
  local prompt_text=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --headless) headless=1 ;;
      --no-worktree) no_worktree=1 ;;
      --model) shift; agent_model="${1:-}"; [[ -n "$agent_model" ]] || die "--model requires a value" ;;
      --plan) shift; plan_ref="${1:-}"; [[ -n "$plan_ref" ]] || die "--plan requires a value" ;;
      --prompt) shift; prompt_text="${1:-}"; [[ -n "$prompt_text" ]] || die "--prompt requires a value" ;;
      -*) die "unknown flag '$1'" ;;
      *) [[ -z "$branch" ]] || die "unexpected argument '$1'"; branch="$1" ;;
    esac
    shift
  done

  [[ -n "$branch" ]] || die "start requires a branch (e.g. feat/add-export)"
  init_repo_paths
  if [[ -n "$plan_ref" && -n "$prompt_text" ]]; then
    die "use either --plan or --prompt, not both"
  fi
  if [[ "$headless" -eq 1 ]]; then
    [[ -n "$plan_ref" || -n "$prompt_text" ]] || die "--headless requires --plan or --prompt"
  fi

  local plan_content=""
  local agent_prompt=""
  local plan_source_file=""
  if [[ -n "$prompt_text" ]]; then
    plan_content="$prompt_text"
  elif [[ -n "$plan_ref" ]]; then
    plan_source_file="$(resolve_plan_file "$plan_ref")" || die "could not resolve plan '$plan_ref'"
    plan_content="$(cat "$plan_source_file")"
  fi

  local base_branch
  base_branch="$(default_base_branch)"

  local worktree run_dir
  if [[ "$no_worktree" -eq 1 ]]; then
    worktree="$MAIN_ROOT"
  else
    worktree="$(worktree_path_for_branch "$branch")"
  fi
  run_dir="$(run_dir_for_slug "$branch")"

  if [[ "$headless" -eq 1 ]]; then
    ensure_agent_ready
    agent_prompt="$(build_contract_prompt "$plan_content" "$base_branch")"
  fi

  provision_worktree "$branch" "$worktree" "$no_worktree"
  write_manifest "$run_dir" "$branch" "$worktree" "$base_branch" "$no_worktree" "$plan_source_file"

  if [[ -n "$plan_content" ]]; then
    write_plan_copy "$run_dir" "$plan_content"
  fi

  print_provision_summary "$worktree" "$branch" "$base_branch" "$run_dir" "$no_worktree"

  if [[ "$headless" -eq 1 ]]; then
    launch_agent_background "$worktree" "$agent_model" "$agent_prompt" "$run_dir"
  elif [[ -n "$plan_content" ]]; then
    echo
    echo "Plan copy: $run_dir/plan.md"
    echo "Hand delivery to a composer-2.5 subagent (subagent mode) or re-run with --headless."
  else
    echo
    echo "Next: pass --plan or --prompt (subagent mode or --headless)."
  fi
}

run_status_line() {
  local run_dir="$1"
  local manifest branch delivery_path pr_url flags="" pid_file log_file
  manifest="$(manifest_path "$run_dir")"
  [[ -f "$manifest" ]] || return 0

  branch="$(manifest_value "$manifest" DELIVERY_BRANCH)"
  delivery_path="$(manifest_value "$manifest" DELIVERY_PATH)"
  pid_file="$run_dir/agent.pid"
  log_file="$run_dir/agent.log"

  if [[ -f "$pid_file" ]]; then
    if kill -0 "$(cat "$pid_file")" 2>/dev/null; then
      flags+=" agent-running"
    fi
  fi
  if [[ -n "$branch" ]] && command -v gh >/dev/null 2>&1; then
    pr_url="$(gh pr list --head "$branch" --json url --jq '.[0].url' 2>/dev/null || true)"
    [[ -n "$pr_url" && "$pr_url" != "null" ]] && flags+=" pr=$pr_url"
  fi
  if [[ -f "$log_file" ]]; then
    flags+=" log=$log_file"
  fi
  echo "run $run_dir  branch=$branch  path=$delivery_path$flags"
}

worktree_delivery_flags() {
  local wt_path="$1"
  local run_dir manifest branch flags=""
  if [[ ! -d "$RUN_TMP_ROOT" ]]; then
    return 0
  fi
  for run_dir in "$RUN_TMP_ROOT"/*; do
    [[ -d "$run_dir" ]] || continue
    manifest="$(manifest_path "$run_dir")"
    [[ -f "$manifest" ]] || continue
    if [[ "$(manifest_value "$manifest" DELIVERY_PATH)" == "$(realpath -m "$wt_path")" ]]; then
      branch="$(manifest_value "$manifest" DELIVERY_BRANCH)"
      flags+=" delivery-run=$run_dir"
      if [[ -f "$run_dir/agent.pid" ]] && kill -0 "$(cat "$run_dir/agent.pid")" 2>/dev/null; then
        flags+=" agent-running"
      fi
      if [[ -n "$branch" ]] && command -v gh >/dev/null 2>&1; then
        local pr_url
        pr_url="$(gh pr list --head "$branch" --json url --jq '.[0].url' 2>/dev/null || true)"
        [[ -n "$pr_url" && "$pr_url" != "null" ]] && flags+=" pr=$pr_url"
      fi
      echo "$flags"
      return 0
    fi
  done
}

cmd_list() {
  init_repo_paths
  git -C "$MAIN_ROOT" worktree list
  echo
  local wt_path extra
  while IFS= read -r wt_path; do
    extra="$(worktree_delivery_flags "$wt_path" || true)"
    if [[ -n "$extra" ]]; then
      echo "$wt_path$extra"
    fi
  done < <(git -C "$MAIN_ROOT" worktree list --porcelain | awk '/^worktree / { print $2 }')
  if [[ -d "$RUN_TMP_ROOT" ]]; then
    echo
    local run_dir
    for run_dir in "$RUN_TMP_ROOT"/*; do
      [[ -d "$run_dir" ]] || continue
      run_status_line "$run_dir"
    done
  fi
}

cmd_remove() {
  local target="${1:-}"
  [[ -n "$target" ]] || die "remove requires a branch, slug, or worktree path"
  init_repo_paths

  local worktree run_dir
  worktree="$(resolve_delivery_path "$target")"
  [[ -d "$worktree" ]] || die "worktree not found at $worktree"
  if [[ "$(realpath -m "$worktree")" == "$(realpath -m "$MAIN_ROOT")" ]]; then
    die "refusing to remove the main checkout"
  fi

  run_dir="$(find_run_dir "$worktree" 2>/dev/null || find_run_dir "$target" 2>/dev/null || true)"
  if [[ -n "$run_dir" && -f "$run_dir/agent.pid" ]]; then
    local pid
    pid="$(cat "$run_dir/agent.pid")"
    if kill -0 "$pid" 2>/dev/null; then
      echo "warning: stopping running agent (PID $pid)" >&2
      kill "$pid" 2>/dev/null || true
    fi
  fi

  if [[ -n "$(git -C "$worktree" status --porcelain)" ]]; then
    echo "warning: worktree has uncommitted changes:" >&2
    git -C "$worktree" status --short >&2
  fi

  git -C "$MAIN_ROOT" worktree remove "$worktree" --force
  git -C "$MAIN_ROOT" worktree prune
  echo "Removed worktree at $worktree"
}

cmd_doctor() {
  init_repo_paths
  echo "Main checkout: $MAIN_ROOT"
  echo "Repo key:      $REPO_KEY"
  echo "Repo note:     $REPO_NOTE_PATH"
  if [[ -f "$REPO_NOTE_PATH" ]]; then
    echo "Note status:   present"
  else
    echo "Note status:   missing (discover before first delivery)"
  fi
  echo "Run tmp root:  $RUN_TMP_ROOT"
  echo
  git -C "$MAIN_ROOT" worktree list
  echo
  if [[ -d "$RUN_TMP_ROOT" ]]; then
    local run_dir
    for run_dir in "$RUN_TMP_ROOT"/*; do
      [[ -d "$run_dir" ]] || continue
      run_status_line "$run_dir"
    done
  else
    echo "No delivery run state under $RUN_TMP_ROOT"
  fi
}

format_stream() {
  if command -v jq >/dev/null 2>&1; then
    jq -r 'select(.type=="assistant") | .message.content[0].text? // empty' 2>/dev/null
  else
    cat
  fi
}

cmd_watch() {
  local target="" follow=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --follow | -f) follow=1 ;;
      -*) die "unknown flag '$1'" ;;
      *) [[ -z "$target" ]] || die "unexpected argument '$1'"; target="$1" ;;
    esac
    shift
  done
  [[ -n "$target" ]] || die "watch requires a branch, slug, or worktree path"
  init_repo_paths

  local run_dir
  run_dir="$(find_run_dir "$target" || die "no delivery run state for '$target'")"
  local log_file="$run_dir/agent.log"
  [[ -f "$log_file" ]] || die "no agent log at $log_file (start with --headless first)"

  run_status_line "$run_dir"
  echo

  if [[ "$follow" -eq 1 ]]; then
    tail -n 20 -f "$log_file" | format_stream
  else
    tail -n 60 "$log_file" | format_stream
  fi
}

main() {
  local command="${1:-}"
  case "$command" in
    repo-note) cmd_repo_note ;;
    start) shift; cmd_start "$@" ;;
    watch) shift; cmd_watch "$@" ;;
    list) cmd_list ;;
    remove) shift; cmd_remove "$@" ;;
    doctor) cmd_doctor ;;
    -h | --help | help | "") usage ;;
    *) die "unknown command '$command' (run delivery.sh --help)" ;;
  esac
}

main "$@"
