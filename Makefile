GRAMMAR_FILES = $(shell find ./grammar/*.pegjs | sort)

CAT=cat
RM=rm -f
NODE=node
PEGJS=./node_modules/.bin/pegjs --cache 
NODEUNIT=./node_modules/.bin/nodeunit
BROWSERIFY=./node_modules/.bin/browserify

all: lib examples

lib: ./lib/sqljs-parser.pegjs ./lib/sqljs-parser.js

clean:
	$(RM) ./lib/sqljs-parser.pegjs
	$(RM) ./lib/sqljs-parser.js
	$(RM) ./examples/browser/demo.browserified.js

test: all
	$(NODEUNIT) --reporter minimal ./tests/*

./lib/sqljs-parser.pegjs: $(GRAMMAR_FILES)
	$(CAT) $(GRAMMAR_FILES) > ./lib/sqljs-parser.pegjs || $(RM) ./lib/sqljs-parser.pegjs

./lib/sqljs-parser.js: ./lib/sqljs-parser.pegjs
	$(PEGJS) ./lib/sqljs-parser.pegjs ./lib/sqljs-parser.js || $(RM) ./lib/sqljs-parser.js

examples: example-browser

example-browser: examples/browser/demo.browserified.js lib

examples/browser/demo.browserified.js: examples/browser/demo.js 
	$(BROWSERIFY) ./examples/browser/demo.js -o ./examples/browser/demo.browserified.js

.PHONY: all lib examples example-browser clean test

