.DEFAULT_GOAL := wiki-help

.PHONY: wiki-help wiki-test wiki-test-init wiki-test-migrate wiki-tests wiki-check

wiki-help:
	@echo "Wiki operate tests:"
	@echo "  make wiki-test         — all scenarios"
	@echo "  make wiki-test-init    — resolve-wiki + init"
	@echo "  make wiki-test-migrate — migrate mechanics"

wiki-test: wiki-tests
wiki-tests wiki-check:
	./tests/run.sh

wiki-test-init:
	./tests/scenarios/init/run.sh

wiki-test-migrate:
	./tests/scenarios/migrate/run.sh