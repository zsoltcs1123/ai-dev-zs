# Install the skills in this repo into a project's (or your global) .agents/skills/.
# Once installed there, harnesses that read .agents/skills/ natively (Cursor 2.4+,
# Codex, Copilot, Gemini, Cline, ...) pick them up with no further setup.
#
# Usage:
#   .\install.ps1 [TARGET]        Install into TARGET/.agents/skills/ (default: current dir)
#   .\install.ps1 --global        Install into ~/.agents/skills/
#   .\install.ps1 --list          List installable skills and exit
#
# Skills are copied as snapshots; re-run this script to update them.

$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot

$target = ''
$global = $false

foreach ($arg in $args) {
    switch ($arg) {
        '--global' { $global = $true }
        '--list' {
            Write-Output 'Installable skills:'
            Get-ChildItem -Directory $ScriptDir | ForEach-Object {
                if (Test-Path (Join-Path $_.FullName 'SKILL.md')) {
                    Write-Output "  - $($_.Name)"
                }
            }
            exit 0
        }
        { $_ -like '--*' } {
            Write-Error "Unknown option: $arg"
            exit 1
        }
        default { $target = $arg }
    }
}

if ($global) {
    $dest = Join-Path (Join-Path $HOME '.agents') 'skills'
} else {
    $base = if ($target) { $target } else { (Get-Location).Path }
    $dest = Join-Path (Join-Path $base '.agents') 'skills'
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null

$installed = 0
Get-ChildItem -Directory $ScriptDir | ForEach-Object {
    $skillFile = Join-Path $_.FullName 'SKILL.md'
    if (-not (Test-Path $skillFile)) { return }

    $name = $_.Name
    $link = Join-Path $dest $name
    if (Test-Path $link) {
        Remove-Item -Recurse -Force $link
    }
    Copy-Item -Recurse -Force $_.FullName $link
    Write-Output "  copy: $name -> $link"
    $installed++
}

Write-Output "Installed $installed skill(s) into $dest"
