include "hardware.inc"

section "RST",rom0[$0]
waitVBlank:
.loop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
    ld a,[rLY]
    cp 144
    jr c,.loop
	reti

section "header",rom0[$100]

	di
	jp main

rept $150-$104
    db 0
endr

section "game",rom0

main:

	PRINT "pragma msg: main is HERE\n"
	warn "WRN huuu"
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0
	rst 0

; .waitVBlank2
;     ld a, [rLY]
;     cp 144
;     jr c, .waitVBlank2

    xor a
    ld [rLCDC], a

    ld hl, $9000
    ld de, Charas
    ld bc, Charas_end - Charas
.copyFont
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyFont

	ld a, %11100100
    ld [rBGP], a

    xor a
    ld [rSCY], a
    ld [rSCX], a

	ld [rNR52], a
	ld a, %10000001
	ld [rLCDC], a

.lockup
    jr .lockup

SECTION "Assets",ROM0

Charas:
incbin "resource/sheet.bin"
Charas_end:
