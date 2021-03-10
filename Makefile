SRCS:=$(wildcard source/*.asm)
OBJS:=$(patsubst source/%.asm,build/%.obj,$(SRCS))
DEPS:=$(patsubst source/%.asm,build/%.make,$(SRCS))

.PHONY: all clean

all: build/genesia.gb

clean:
	2>/dev/null rm -rf build/*

build/genesia.gb: $(OBJS)
	mkdir -p $(dir $@)
	rgblink -m$(@:.gb=.map) -n$(@:.gb=.sym) -o$@ $^ 
	rgbfix -p0 -v $@

build/%.obj: source/%.asm
	mkdir -p $(dir $@)
	rgbasm -iinclude -M$(@:.obj=.make) -o$@ $<

-include $(DEPS)

resource/sheet.bin: asset/sheet.png
	rgbgfx -u -o$@ $<
