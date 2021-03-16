include "hardware.inc"


; cells data
; indiquate what cell are made of
; generally a terrain
; optionally something on it

; terrain             ------XX
MAP_SEA          equ %00000000
MAP_BEACH        equ %00000001
MAP_PLAIN        equ %00000010
MAP_MONTAIN      equ %00000011

; resource            -XXXXX--
MAP_TREASURE     equ %00000101
MAP_TREE         equ %00000110
MAP_ROCK         equ %00000111

MAP_IS_RESSOURCE equ %00000100

; building            -XXXXX--
MAP_HARBOUR      equ %00001000
MAP_FIELD        equ %00010000
MAP_AUGER        equ %00011000
MAP_HUT          equ %00100000
MAP_HOUSE        equ %00101000
MAP_INN          equ %00110000
MAP_BARRACK      equ %00111000
MAP_WORKSHOP     equ %01000000
MAP_TEMPLE       equ %01001000

MAP_IS_BUILDING  equ %01111000

; totem               X-------
MAP_TOTEM        equ %10000000


section union "shared ram", wram0

; map related
; ===========

; reverse position of the top-left tile
wMapPosX::
	db
wMapPosY::
	db

; address to ROM and RAM during copy
wCopySrc::
	dw
wCopyDst::
	dw


section "assets",rom0

; characters
chars_overworld:
incbin "build/overworld.chr"


; for each cells data, give the 1st characters index
; characters stored at VRAM block 1 $8800
terrain_1st_chararters:
	db 128 ; sea
	db 150 ; sand
	db 172 ; grass
	db 194 ; stone

; map cells data
first_background:
incbin "build/first.bg"

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
	ld bc, 154*16
	call memcpy_long

	; initialize the source and dest variable for copy
	ld a, HIGH(first_background)
	ld [wCopySrc+0], a
	ld a, LOW(first_background)
	ld [wCopySrc+1], a
	ld a, HIGH(_SCRN0)
	ld [wCopyDst+0], a
	ld a, LOW(_SCRN0)
	ld [wCopyDst+1], a

	; load source and dest variable for copy
	ld a, [wCopySrc+0]
	ld d, a
	ld a, [wCopySrc+1]
	ld e, a
	ld a, [wCopyDst+0]
	ld h, a
	ld a, [wCopyDst+1]
	ld l, a

	; copy a line of background tile index
	ld c, 20
	call memcpy_short

	; increase source and dest variable for copy to reach the next line

	; temporary store 


	; TODO: redo
	; skip the remaining bg tile
	;ld b, 0
	;ld c, 60
	;add hl, bc


	; declare palette
	ld a, %11100100
	ld [rBGP], a

	; reset background scroll
	xor a
	ld [rSCY], a
	ld [rSCY], a

	; reset map scroll
	xor a
	ld [wMapPosX], a
	ld [wMapPosY], a

	; enable LDC and background
	ld a, LCDCF_ON|LCDCF_BGON
	ld [rLCDC], a

.lockup
	halt 
	nop
	jr .lockup
