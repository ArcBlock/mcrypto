

travis-init:
	@echo "Initialize software required for travis (normally ubuntu software)"


build:
	@echo "Building the software..."
	@make format

format:
	@mix compile; mix format;

dep:
	@echo "Install dependencies required for this repo..."
	@mix deps.get

test:
	@echo "Running test suites..."
	@MIX_ENV=test make build
	@MIX_ENV=test mix test

run:
	@echo "Running the software..."
	@iex -S mix

dialyzer:
	@echo "Running dialyzer..."
	@mix dialyzer

.PHONY: build init travis-init install dep test dialyzer doc precommit travis clean watch run
