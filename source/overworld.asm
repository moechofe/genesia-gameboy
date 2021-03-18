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


section union "unioned ram", wram0

; reverse position of the top-left tile of the map
wMapPosX:
	db
wMapPosY:
	db
; map cursor coords in screen coordinates
wMapCursorScreenX:
	db
wMapCursorScreenY:
	db
; map cursor blink animation state
wMapCursorBlink:
	db
; map cursor pixel expand count [0,1]
wMapCursorExpand:
	db

section union "sprites ram", wram0, align[8]

; cursor on the map
wMapCursorTL: ; Top Left corner
	ds sizeof_OAM_ATTRS
wMapCursorTR: ; Top Right corner
	ds sizeof_OAM_ATTRS
wMapCursorBL: ; Bottom Left corner
	ds sizeof_OAM_ATTRS
wMapCursorBR: ; Bottom Right corner
	ds sizeof_OAM_ATTRS


section "overworld assets", rom0

; characters
chars_overworld:
incbin "build/overworld.chr"
.end:


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


section "overworld code", romx

switch_to_overworld::

	; initialize variables
	xor 0
	ld [wMapCursorBlink], a
	ld [wMapCursorExpand], a

	; TODO: temporary map cursor screen position
	; TODO: can probably join with the setup of the map cursor
	ld a, 4*8
	ld [wMapCursorScreenX], a
	ld a, 13*8
	ld [wMapCursorScreenY], a

	; disable LCD
	; TODO: already done in main.asm
	;rst 0
	;xor a
	;ld [rLCDC], a

	; disable sound
	ld [rNR52], a

	; copy characters
	ld hl, _VRAM8800
	ld de, chars_overworld
	ld bc, chars_overworld.end - chars_overworld
	call memcpy_long

	; copy map tiles to background to fill the entire screen
copy_whole_map_to_bg:

	; will copy 18 rows of background tiles
	ld b, 18

	; initialize source and destination for copy operation
	ld a, HIGH(first_background)
	ld d, a
	ld a, LOW(first_background)
	ld e, a

	ld a, HIGH(_SCRN0)
	ld h, a
	ld a, LOW(_SCRN0)
	ld l, a

.loop
	; copy a line of background tile index
	ld c, 20
	call memcpy_short

	; one line down, check if copy is done
	dec b
	jr z, .done

	; increase source and destination to reach the next line
	ld a, e
	add 69
	ld e, a
	ld a, d
	adc 0
	ld d, a

	ld a, l
	add 12
	ld l, a
	ld a, h
	adc 0
	ld h, a

	jr .loop
.done:

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

	; setup cell cursor on map

	ld a, [wMapCursorScreenX]
	ld b, a
	ld a, [wMapCursorScreenY]
	ld c, a

	; TODO: use the variable for the map cursor

	ld a, c
	add 4
	ld [wMapCursorTL + OAMA_Y], a
	ld [wMapCursorTR + OAMA_Y], a

	ld a, c
	add 20
	ld [wMapCursorBL + OAMA_Y], a
	ld [wMapCursorBR + OAMA_Y], a

	ld a, b
	sub 4
	ld [wMapCursorTL + OAMA_X], a
	ld [wMapCursorBL + OAMA_X], a

	ld a, b
	add 12
	ld [wMapCursorTR + OAMA_X], a
	ld [wMapCursorBR + OAMA_X], a

	xor a
	ld [wMapCursorTL + OAMA_TILEID], a
	ld [wMapCursorTR + OAMA_TILEID], a
	ld [wMapCursorBL + OAMA_TILEID], a
	ld [wMapCursorBR + OAMA_TILEID], a

	ld [wMapCursorTL + OAMA_FLAGS], a

	ld a, OAMF_XFLIP
	ld [wMapCursorTR + OAMA_FLAGS], a

	ld a, OAMF_YFLIP
	ld [wMapCursorBL + OAMA_FLAGS], a

	ld a, OAMF_YFLIP|OAMF_XFLIP
	ld [wMapCursorBR + OAMA_FLAGS], a

	call copy_sprites

	; setup timer
	;xor a
	;ld [rTMA], a
	;ld [rTIMA], a
	;ld a, TACF_START|TACF_4KHZ
	;ld [rTAC], a

	; setup VBL interrupt
	ld a, IEF_VBLANK
	ld [rIE], a
	ei

	; enable LDC, background and sprites
	ld a, LCDCF_ON|LCDCF_BGON|LCDCF_OBJON
	ld [rLCDC], a


	; update map cursor animation

	ld a, [wMapCursorExpand]
	ld d, a

	ld a, [wMapCursorScreenX]
	ld b, a
	ld a, [wMapCursorScreenY]
	ld c, a
	
	ld a, c
	add 4
	add d
	ld [wMapCursorTL + OAMA_Y], a
	ld [wMapCursorTR + OAMA_Y], a

	ld a, c
	add 20
	sub d
	ld [wMapCursorBL + OAMA_Y], a
	ld [wMapCursorBR + OAMA_Y], a

	ld a, b
	sub 4
	add d
	ld [wMapCursorTL + OAMA_X], a
	ld [wMapCursorBL + OAMA_X], a

	ld a, b
	add 12
	sub d
	ld [wMapCursorTR + OAMA_X], a
	ld [wMapCursorBR + OAMA_X], a

.lockup
	halt

	; compute blink animation for the map cursor
	ld a, [wMapCursorBlink]
	ld b, a
	ld a, [wFrameCounter]
	and %10000 ; for the speed
	ld c, a ; 2 steps animation
	xor b ; detect steps change
	jr z, .lockup
	ld a, [wMapCursorBlink]
	xor %10000
	ld [wMapCursorBlink], a
	ld a, c
	rra 
	rra 
	rra 
	rra 
	ld [wMapCursorExpand], a

	; TODO: temporary check for mode 1
	ld a, [rSTAT]
	and STATF_MODE01
	jr z, .is_mode_1
.is_not_mode_1:
	halt 
	jr .is_not_mode_1
.is_mode_1:

	call copy_sprites

	jr .lockup
