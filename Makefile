.PHONY: help install lint-md lint-md-fix

help: ## List targets
	@grep -E '^[a-zA-Z0-9_-]+:.*##' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

install: ## Install dev dependencies (npm ci or npm install)
	@if [ -f package-lock.json ]; then npm ci; else npm install; fi

lint-md: install ## Lint all tracked markdown (skills, bundles, docs)
ifdef FILE
	npx markdownlint-cli2 --no-globs "$(FILE)"
else
	npm run lint:md
endif

lint-md-fix: install ## Apply safe markdown auto-fixes
ifdef FILE
	npx markdownlint-cli2 --fix --no-globs "$(FILE)"
else
	npm run lint:md:fix
endif