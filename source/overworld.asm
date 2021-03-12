include "hardware.inc"

section union "shared ram", wram0

; map related
; ===========

; reverse position of the top-left tile
wMapPosX::
	ds 1
wMapPosY::
	ds 1


section "assets",rom0

chars_overworld:
incbin "build/overworld.chr"
	

section "overworld code",romx

switch_to_overworld::

	; disable LCD
	rst 0
	xor a
	ld [rLCDC], a

	; disable sound
	ld [rNR52], a

	; copy characters
	ld hl, _VRAM8800
	ld de, chars_overworld
	ld bc, 74*16
	call memcpy_long

	PRINT "TEMP create fake background"
	
	; create temporary background
	;ld hl, _SCRN0
	;ld de, temp_background
	;ld c, 4
	;call memcpy_short

	; declare palette
	ld a, %11100100
	ld [rBGP], a

	; reset background scroll
	xor a
	ld [rSCY], a
	ld [rSCY], a

	; enable LDC and background
	ld a, LCDCF_ON|LCDCF_BGON
	ld [rLCDC], a

.lockup
	halt 
	nop
	jr .lockup
