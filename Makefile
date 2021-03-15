PRJ:=genesia

SRCS:=$(wildcard source/*.asm)
OBJS:=$(patsubst source/%.asm,build/%.obj,$(SRCS))
DEPS:=$(patsubst source/%.asm,build/%.make,$(SRCS))

RGBASM:=$(shell which rgbasm || which rgbasm.exe)
RGBLINK:=$(shell which rgblink || which rgblink.exe)
RGBFIX:=$(shell which rgbfix || which rgbfix.exe)
RGBGFX:=$(shell which rgbgfx || which rgbgfx.exe)

$(info RGBASM= $(shell $(RGBASM) -V))
$(info RGBLINK= $(shell $(RGBLINK) -V))
$(info RGBFIX= $(shell $(RGBFIX) -V))
$(info RGBGFX= $(shell $(RGBGFX) -V))
$(info )
$(info SRCS= $(SRCS))

.PHONY: all clean

all: build/$(PRJ).gb

clean:
	2>/dev/null rm -rf build/*

build/$(PRJ).gb: $(DEPS) $(OBJS)
	mkdir -p $(dir $@)
	$(RGBLINK) -m$(@:.gb=.map) -n$(@:.gb=.sym) -o$@ $(OBJS)
	$(RGBFIX) -p0 -v $@

build/%.make: source/%.asm
	mkdir -p $(dir $@)
	$(RGBASM) -iinclude -ibuild -M$@ -MG -o$(@:.make=.obj) $<

-include $(DEPS)

build/%.obj: source/%.asm
	mkdir -p $(dir $@)
	$(RGBASM) -Weverything -iinclude -ibuild -M$(@:.obj=.make) -o$@ $<

build/overworld.chr: asset/overworld.png
	$(RGBGFX) -o$@ $<
