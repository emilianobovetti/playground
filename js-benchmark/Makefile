all: node_modules

node_modules:
	yarn

.PHONY: run
run: node_modules
	node main.js

.PHONY: clean
clean:
	rm -rf node_modules
