all: help

EXTERNALS=../externals

PYTHON ?= python
PYTHONPATH=$$PYTHONPATH:$(EXTERNALS)/pypy

COMMON_BUILD_OPT = --thread --no-shared
JIT_OPT = --opt=jit
TARGET_OPT = target.py

help:
	@echo "make help              - display this message"
	@echo "make run               - run the compiled interpreter"
	@echo "make run_interactive   - run without compiling (slow)"
	@echo "make build_with_jit    - build with jit enabled"
	@echo "make build_no_jit      - build without jit"

pixie-vm: fetch_externals
	$(PYTHON) $(EXTERNALS)/pypy/rpython/bin/rpython $(COMMON_BUILD_OPT) $(JIT_OPT) $(TARGET_OPT)

.PHONY: fetch_externals
fetch_externals: $(EXTERNALS)/pypy

.PHONY: fetch_externals
fetch_externals: $(EXTERNALS)/pypy
$(EXTERNALS)/pypy:
	mkdir $(EXTERNALS); \
	cd $(EXTERNALS); \
	curl https://bitbucket.org/pypy/pypy/get/default.tar.bz2 >  pypy.tar.bz2; \
	mkdir pypy; \
	cd pypy; \
	tar -jxf ../pypy.tar.bz2 --strip-components=1

.PHONY: run
run:
	./pixie-vm

.PHONY: run_interactive
run_interactive:
	PYTHONPATH=$(PYTHONPATH) $(PYTHON) target.py

.PHONY: run_built_tests
run_built_tests: pixie-vm
	./pixie-vm run-tests.pxi

.PHONY: run_interpreted_tests
run_interpreted_tests:
	PYTHONPATH=$(PYTHONPATH) $(PYTHON) target.py run-tests.pxi
