LD_FLAGS := -lc --dynamic-linker=/lib/ld-linux-x86-64.so.2
NASM_FLAGS := -felf64
SOURCES := $(shell find src/ -name '*.s')
OBJECTS := $(SOURCES:src/%.s=lib/%.o)

default: $(OBJECTS) bin/main

debug: NASM_FLAGS := $(NASM_FLAGS) -g

.PHONY: debug
debug: default

bin/main: $(OBJECTS)
	ld $^ $(LD_FLAGS) -o $@

lib/%.o: src/%.s
	nasm $^ $(NASM_FLAGS) -o $@


.PHONY: clean
clean:
	rm -rf lib/*.o
	rm -rf bin/*
