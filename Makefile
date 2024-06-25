SHELL=/usr/bin/env bash

.PHONY: init all build run test clean

init:
	$(info Fetching submodule dlozeve/bqn-curl...)
	@git submodule update
	@cd lib/bqn-curl && git checkout d30021d
ifndef LIBCURL_PATH
	$(info Warning: No LIBCURL_PATH specified; using bqn-curl default (/usr/lib/x86_64-linux-gnu/libcurl.so))
else
	$(info LIBCURL_PATH=${LIBCURL_PATH})
	@echo "libcurlPath⇐\"${LIBCURL_PATH}\"" > lib/bqn-curl/config.bqn
endif

all:
	echo "make all NYI"

build:
	echo "make build NYI" # probably just tar it all up

run:
	@bqn src/main.bqn

test:
	@bqn test/tests.bqn

clean:
	rm -r lib/*
