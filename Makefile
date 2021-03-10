PRJ:=genesia

SRCS:=$(wildcard source/*.asm)
OBJS:=$(patsubst source/%.asm,build/%.obj,$(SRCS))
DEPS:=$(patsubst source/%.asm,build/%.make,$(SRCS))

.PHONY: all clean

all: build/$(PRJ).gb

clean:
	2>/dev/null rm -rf build/*

build/$(PRJ).gb: $(DEPS) $(OBJS)
	mkdir -p $(dir $@)
	rgblink -m$(@:.gb=.map) -n$(@:.gb=.sym) -o$@ $(OBJS)
	rgbfix -p0 -v $@

build/%.make: source/%.asm
	mkdir -p $(dir $@)
	rgbasm -iinclude -ibuild -M$@ -MG -o$(@:.make=.obj) $<

-include $(DEPS)

build/%.obj: source/%.asm
	mkdir -p $(dir $@)
	rgbasm -iinclude -ibuild -M$(@:.obj=.make) -o$@ $<

build/overworld.chr: asset/overworld.png
	rgbgfx -u -o$@ $<
