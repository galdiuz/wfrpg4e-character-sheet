SHELL = /bin/sh
BUILD_PATH = index.html
MAIN_FILE = src/Main.elm


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: build
build: ## Build elm with --optimize flag
	elm make $(MAIN_FILE) --output $(BUILD_PATH) --optimize


.PHONY: build-debug
build-debug: ## Build elm with --debug flag
	elm make $(MAIN_FILE) --output $(BUILD_PATH) --debug


.PHONY: elm-live
elm-live: ## Start elm-live
	elm-live $(MAIN_FILE) -p 8000 -- --output $(BUILD_PATH) --debug


.PHONY: css
css: ## Build css
	@$(MAKE) -C css


.PHONY: watch-css
watch-css: ## Watch files and build css
	@while inotifywait -r -q -e modify ./css/src/; do $(MAKE) css; done
