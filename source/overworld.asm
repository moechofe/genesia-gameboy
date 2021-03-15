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

; characters
chars_overworld:
incbin "build/overworld.chr"

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

; for each cells data, give the 1st characters index
; characters stored at VRAM block 1 $8800
terrain_1st_chararters:
	db 128 ; sea
	db 150 ; sand
	db 172 ; grass
	db 194 ; stone

; map cells data
map_01:
	db MAP_SEA,MAP_SEA
	db MAP_SEA,MAP_SEA

; TODO: deleteme
temp_background:
	db 128,129,130,131

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

	; create temporary background
	; TODO: deleteme
	ld hl, _SCRN0
	ld de, temp_background
	ld c, 4
	call memcpy_short

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

	; TODO I need a TEMP loop that will browse all visible tiles

	; TODO then for each line or row, I need to know the map cell
	; TODO then for the 1, 2 and 3 third of a cell, I need to know what tile index I need




	; enable LDC and background
	ld a, LCDCF_ON|LCDCF_BGON
	ld [rLCDC], a

.lockup
	halt 
	nop
	jr .lockup
