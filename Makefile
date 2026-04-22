.PHONY: help serve build verify lint-labs lab clean

help:
	@echo "ClaudeCodeLabs - developer entry points"
	@echo ""
	@echo "  make serve       - run MkDocs with live reload"
	@echo "  make build       - build the static site into mkdocs-site/"
	@echo "  make verify      - run every lab's verify.sh"
	@echo "  make lint-labs   - run the structural linter across all labs"
	@echo "  make lab NNN=042 - scaffold a new lab directory from the template"
	@echo "  make clean       - remove build output"

serve:
	mkdocs serve -f mkdocs.yml

build:
	mkdocs build -f mkdocs.yml -d mkdocs-site

verify:
	@for dir in Labs/[0-9]*; do \
	  num=$$(basename $$dir | cut -d- -f1); \
	  echo "== lab $$num =="; \
	  ./scripts/verify.sh $$num || exit 1; \
	done

lint-labs:
	@./scripts/lint-labs.sh

lab:
	@if [ -z "$(NNN)" ]; then echo "usage: make lab NNN=042 TITLE=MyLabTitle" >&2; exit 2; fi
	@if [ -z "$(TITLE)" ]; then echo "usage: make lab NNN=042 TITLE=MyLabTitle" >&2; exit 2; fi
	@if [ -d "Labs/$(NNN)-$(TITLE)" ]; then echo "already exists: Labs/$(NNN)-$(TITLE)" >&2; exit 1; fi
	cp -r Labs/_TEMPLATE Labs/$(NNN)-$(TITLE)
	chmod +x Labs/$(NNN)-$(TITLE)/doctor.sh Labs/$(NNN)-$(TITLE)/verify.sh
	@sed -i.bak 's/Lab NNN/Lab $(NNN)/g' Labs/$(NNN)-$(TITLE)/README.md && rm Labs/$(NNN)-$(TITLE)/README.md.bak
	@echo "OK scaffolded Labs/$(NNN)-$(TITLE)/"

clean:
	rm -rf mkdocs-site .mkdocs-build
