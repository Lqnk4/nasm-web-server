LD_FLAGS := -lc --dynamic-linker=/lib/ld-linux-x86-64.so.2
NASM_FLAGS := -felf64
SOURCES := $(shell find src/ -name '*.s')
OBJDIR := lib
OBJECTS := $(SOURCES:src/%.s=$(OBJDIR)/%.o)
BUILDDIR := bin

default: $(OBJECTS) $(BUILDDIR)/main

debug: NASM_FLAGS := $(NASM_FLAGS) -g

debug: clean default

bin/main: $(OBJECTS) | $(BUILDDIR)
	ld $^ $(LD_FLAGS) -o $@

lib/%.o: src/%.s | $(OBJDIR)
	nasm $^ $(NASM_FLAGS) -o $@

$(OBJDIR):
	mkdir $@

$(BUILDDIR):
	mkdir $@

.PHONY: clean
clean:
	rm -rf lib/*.o
	rm -rf bin/*
