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

section "game",rom0

main:
	di 

	; disable LCD
	rst 0
	xor a
	ld [rLCDC], a


; 	mem_Copy::
; 	inc	b
; 	inc	c
; 	jr	.skip
; .loop	ld	a,[hl+]
; 	ld	[de],a
; 	inc	de
; .skip	dec	c
; 	jr	nz,.loop
; 	dec	b
; 	jr	nz,.loop
; 	ret



	ld hl, _VRAM8800
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

	;rst 0
	;ld	a, [rSCX]
	;inc	a
	;ld	[rSCX], a

	halt 
	nop
	jr .lockup

section "assets",rom0

charas:
incbin "build/overworld.chr"
charas_end:
