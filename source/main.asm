include "hardware.inc"
include "header.inc"

section "rst",rom0[$0]
waitvblank:
.loop
	ld a, [rLY]
	cp 144
	jr c, .loop
	reti

section "vblank interrput",rom0[$0040]
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

section "game",rom0

main:
	di 
	ld SP, $FFFF

	rst 0
	xor a
	ld [rLCDC], a

	ld hl, $9000
	ld de, charas
	ld bc, charas_end - charas
.copyfont
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .copyfont

	ld a, %11100100
	ld [rBGP], a

	xor a
	ld [rSCY], a
	ld [rSCY], a

	ld [rNR52], a
	ld a, %10000001
	ld [rLCDC], a

.lockup
	halt 
	nop
	jr .lockup

section "assets",rom0

charas:
incbin "build/overworld.chr"
charas_end:
