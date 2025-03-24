LD_FLAGS := -lc --dynamic-linker=/lib/ld-linux-x86-64.so.2
SOURCES := $(shell find src/ -name '*.s')
OBJECTS := $(SOURCES:src/%.s=lib/%.o)

default: $(OBJECTS) bin/main

bin/main: $(OBJECTS)
	ld $^ $(LD_FLAGS) -o $@

lib/%.o: src/%.s
	nasm $^ -felf64 -o $@


.PHONY: clean
clean:
	rm -rf lib/*.o
	rm -rf bin/*
