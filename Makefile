channel ?= Unstable
lint_reporter ?= console
shell := /bin/bash -o pipefail

deps-vendor-cli:
	mkdir -p deps/
	if [[ "`uname`" == "Linux" ]]; then curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.4.0/cli_0.4.0_linux_amd64.tar.gz | tar xvf - -C deps; exit 0; fi; \
	if [[ "`uname`" == "Darwin" ]]; then curl -fsSL https://github.com/replicatedhq/replicated/releases/download/v0.4.0/cli_0.4.0_darwin_amd64.tar.gz | tar xvf - -C deps; exit 0; fi;

deps-lint:
	npm install replicated-lint

deps: deps-lint deps-vendor-cli

lint:
	`npm bin`/replicated-lint validate --infile replicated.yml --reporter $(lint_reporter)
	# check k8s for valid yaml, no schema checks yet
	`npm bin`/replicated-lint validate --infile replicated.yml --reporter $(lint_reporter) --excludeDefaults --multidocIndex=1

release:
	cat replicated.yml | deps/replicated release create --promote $(channel) --yaml -
