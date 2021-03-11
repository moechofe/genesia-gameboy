include "hardware.inc"

section "wait vbl rst",rom0[$0]
waitVbl:
	ld a, [rLY]
	cp 144
	jr c, waitVbl
	reti

section "vbl interrput",rom0[$0040]
	reti

section "lcdc interrput",rom0[$0048]
	reti

section "timer interrput",rom0[$0050]
	reti

section "serial interrput",rom0[$0058]
	reti

section "joypad interrput",rom0[$0060]
	reti

section "entrypoint",rom0[$100]
	nop
	jp main

section "rom header",rom0[$0104]
	NINTENDO_LOGO
	DB "GenesiaBoy     " ; Cart name - 15 characters / 15 bytes
	DB 0 ; $143 - GBC support. $80 = both. $C0 = only gbc
	DB 0,0 ; $144 - Licensee code (not important)
	DB 0 ; $146 - SGB Support indicator
	DB 0 ; $147 - Cart type / MBC type (0 => no mbc)
	DB 0 ; $148 - ROM Size (0 => 32KB)
	DB 0 ; $149 - RAM Size (0 => 0KB RAM on cartridge)
	DB 1 ; $14a - Destination code
	DB $33 ; $14b - Old licensee code
	DB 0 ; $14c - Mask ROM version
	DB 0 ; $14d - Complement check (important) rgbds-fixed
	DW 0 ; $14e - Checksum (not important)

rept $150-$104
	db 0
endr

section "common",rom0

; memcpy
; (in) de = address of source
; (in) hl = address of destination
; (in) c = number of bytes to copy
; (out) de = will point to next after the last
; (out) hl = will point to next after the last
; (out) c = 0
; (flags) !Z N
memcpy::
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, memcpy
	ret

section "game",rom0

main:
	di 

	; disable LCD
	rst 0
	xor a
	ld [rLCDC], a

	; copy characters
	ld hl, _VRAM8800
	ld de, assets_overworld
	ld c, 4*16
	call memcpy

	PRINT "TEMP create fake background"

	; create temporary background
	ld hl, _SCRN0
	ld de, temp_background
	ld c, 4
	call memcpy

	; declare palette
	ld a, %11100100
	ld [rBGP], a

	; reset background scroll
	xor a
	ld [rSCY], a
	ld [rSCY], a

	; disable sound
	ld [rNR52], a

	; enable LDC and background
	ld a, LCDCF_ON|LCDCF_BGON
	ld [rLCDC], a

.lockup

	halt 
	nop
	jr .lockup

section "assets",rom0

assets_overworld:
incbin "build/overworld.chr"

temp_background:
	db 128,129,130,131
