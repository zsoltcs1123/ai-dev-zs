.DEFAULT_GOAL := help

.PHONY: help test test-init test-migrate tests check

help:
	@echo "Wiki operate tests:"
	@echo "  make test         — all scenarios"
	@echo "  make test-init    — resolve-wiki + init"
	@echo "  make test-migrate — migrate mechanics"

test: tests
tests check:
	./tests/run.sh

test-init:
	./tests/scenarios/init/run.sh

test-migrate:
	./tests/scenarios/migrate/run.sh