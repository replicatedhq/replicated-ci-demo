channel ?= Unstable
lint_reporter ?= console

deps-vendor-cli:
	mkdir -p deps/
	wget -O deps/cli.tar.gz https://github.com/replicatedhq/replicated/releases/download/v0.4.0/cli_0.4.0_linux_amd64.tar.gz
	tar xvzf deps/cli.tar.gz -C deps/

deps-lint:
	npm install --global yarn
	yarn

deps: deps-lint deps-vendor-cli

lint:
	`yarn bin`/replicated-lint validate --infile replicated.yml --reporter $(lint_reporter)

release:
	cat replicated.yml | deps/replicated release create --promote $(channel) --yaml -
