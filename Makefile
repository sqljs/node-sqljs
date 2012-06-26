GRAMMAR_FILES = $(shell find ./grammar/*.pegjs | sort)

CAT=cat
RM=rm -f
NODE=node
PEGJS=./node_modules/pegjs/bin/pegjs --cache 
NODEUNIT=./node_modules/nodeunit/bin/nodeunit

all: ./lib/sqljs-parser.pegjs ./lib/sqljs-parser.js

clean:
	$(RM) ./lib/sqljs-parser.pegjs
	$(RM) ./lib/sqljs-parser.js

test: all
	$(NODEUNIT) --reporter minimal ./tests/*

./lib/sqljs-parser.pegjs: $(GRAMMAR_FILES)
	$(CAT) $(GRAMMAR_FILES) > ./lib/sqljs-parser.pegjs || $(RM) ./lib/sqljs-parser.pegjs

./lib/sqljs-parser.js: ./lib/sqljs-parser.pegjs
	$(PEGJS) ./lib/sqljs-parser.pegjs ./lib/sqljs-parser.js || $(RM) ./lib/sqljs-parser.js

.PHONY: all clean test

