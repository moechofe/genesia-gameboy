include "hardware.inc"


section union "sprites ram", wram0, align[8]

; buffer for sprites states
wOAMBuffer::
	ds OAM_COUNT * sizeof_OAM_ATTRS
.end:

	
section "ui assets", rom0

; characters
chars_ui:
incbin "build/ui.chr"
.end:


section "wait vbl rst", rom0[$0]
waitVbl:
	ld a, [rLY]
	cp 144
	jr c, waitVbl
	ret


section "entrypoint", rom0[$100]
	nop
	jp main


section "rom header", rom0[$0104]
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


section "common", rom0

; copy memory for less than 256 bytes
; (in) de = address of source
; (in) hl = address of destination
; (in) c = number of bytes to copy
; (out) de = will point to next after the last
; (out) hl = will point to next after the last
; (out) c = 0
; (flags) !Z N
memcpy_short::
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, memcpy_short
	ret

; copy memory for more than 255 bytes
; (in) de = address of source
; (in) hl = address of destination
; (in) bc = number of bytes to copy
; (out) de = will point to next after the last
; (out) hl = will point to next after the last
; (out) c = 0
; (use) a
; (flags) !Z N
memcpy_long::
	; increment b if c is nonzero
	dec bc
	inc b
	inc c
.loop:
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

; read game pad input
; (out) a = from high to low bit: Start - Select - B - A - Down - Up - Left - Right
; (use) b
; (use) hl
; (flags) Z? N?
read_input::
    ld hl, rP1
	ld [hl], P1F_GET_BTN
    ld a, [hl]
    ld a, [hl]
    cpl
    and %1111
	ld b, a

    ld [hl], P1F_GET_DPAD
    ld a, [hl]
    ld a, [hl]
    ld a, [hl]
    ld a, [hl]
    ld a, [hl]
    ld a, [hl]

	ld [hl], P1F_GET_NONE
    cpl
    and %1111
    swap a
    or b
    ret

; this routine will copied to HRAM, 
oam_copy_routine:
LOAD "hram", HRAM
copy_sprites::
  ld a, HIGH(wOAMBuffer)
  ldh [rDMA], a
  ld a, $28
.wait:
  dec a
  jr nz, .wait
  ret
.end:
ENDL


section "game", rom0

main:
	di 

	; initialize variables
	xor a
	ld [wFrameCounter], a

	; disable LCD
	rst 0
	xor a
	ld [rLCDC], a	

	; copy characters
	ld hl, _VRAM8000
	ld de, chars_ui
	ld bc, chars_ui.end - chars_ui
	call memcpy_short

	; declare palette
	ld a, %11010000
	ld [rOBP0], a

	; initialize the sprites buffer
	; TODO: can reduce code by start at the end and compare when reach the begining
clear_sprites_buffer:
	ld hl, wOAMBuffer
	ld c, wOAMBuffer.end - wOAMBuffer
	xor a
.loop:
	ld [hl+], a
	dec c
	jr nz, .loop
  
	; install the sprites copy routine to HRAM
	; TODO: can I use my regular memcpy_short here?
install_oam_copy_routine:
	ld hl, copy_sprites
	ld de, oam_copy_routine
	ld c, copy_sprites.end - copy_sprites
.loop:
	ld a, [de]
	inc de
	ld [hl+], a
	dec c
	jr nz, .loop

	; clear sprites now
	call copy_sprites

	jp switch_to_overworld

; .lockup
; 	halt 
; 	nop
; 	jr .lockup
