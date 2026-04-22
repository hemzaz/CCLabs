.PHONY: help serve run build verify lint-labs lab clean deploy-vercel deploy-netlify

help:
	@echo "ClaudeCodeLabs - developer entry points"
	@echo ""
	@echo "  make serve           - run MkDocs dev server (live reload)"
	@echo "  make run             - build and preview the shippable site at :8000"
	@echo "  make build           - build the static site into mkdocs-site/"
	@echo "  make verify          - run every lab's verify.sh"
	@echo "  make lint-labs       - run the structural linter across all labs"
	@echo "  make lab NNN=042 TITLE=MyLabTitle - scaffold a new lab from the template"
	@echo "  make deploy-vercel   - build and deploy to Vercel (requires vercel CLI)"
	@echo "  make deploy-netlify  - build and deploy to Netlify (requires netlify CLI)"
	@echo "  make clean           - remove build output"

serve:
	mkdocs serve -f mkdocs.yml

build:
	mkdocs build -f mkdocs.yml -d mkdocs-site

run: build
	@echo "Preview at http://localhost:8000/  (Ctrl+C to stop)"
	@cd mkdocs-site && python3 -m http.server 8000

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

deploy-vercel: build
	@command -v vercel >/dev/null 2>&1 || { \
	  echo "ERROR: vercel CLI not found" >&2; \
	  echo "Install: npm i -g vercel" >&2; \
	  echo "Auth:    vercel login" >&2; \
	  exit 1; \
	}
	vercel deploy --prod --yes mkdocs-site

deploy-netlify: build
	@command -v netlify >/dev/null 2>&1 || { \
	  echo "ERROR: netlify CLI not found" >&2; \
	  echo "Install: npm i -g netlify-cli" >&2; \
	  echo "Auth:    netlify login" >&2; \
	  exit 1; \
	}
	netlify deploy --prod --dir=mkdocs-site

clean:
	rm -rf mkdocs-site .mkdocs-build
