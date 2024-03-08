;;This file is part of ManPac.
;;
;;ManPac is free software: you can redistribute it and/or modify it under the terms
;;of the GNU General Public License (GPL) as published by the Free Software Foundation,
;;either version 3 of the License, or (at your option) any later version.
;;
;;ManPac is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
;;without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;;PURPOSE.See the GNU General Public License for more details.
;;
;;You should have received a copy of the GNU General Public License along with ManPac.
;;If not, see <https://www.gnu.org/licenses/>.


;;
;; Render System
;;

.include "man/entity_manager.h.s"
.include "tile_system.h.s"
.include "cpctelera.h.s"
.include "man/game_manager.h.s"

.globl cpct_setDrawCharM0_asm
.globl cpct_drawStringM0_asm
.globl cpct_getScreenPtr_asm 
.globl cpct_drawSolidBox_asm
.globl cpct_setVideoMode_asm
.globl cpct_setPalette_asm
.globl cpct_etm_setDrawTilemap4x8_ag_asm
.globl cpct_etm_drawTilemap4x8_ag_asm
.globl cpct_drawSprite_asm
;;MAP	
.globl _newPalette	;; Colour Palette pointer
.globl _level32_W 	;; Map whidth
.globl _level32 		;; Tile set pointer
.globl _set32_000  	;; Tile map pointer (Red-Blue)
.globl _set32_048		;; Tile map pointer (Blue)
.globl _set32_096		;; Tile map pointer (White)
.globl _logo
.globl cpct_drawCharM0_asm


.module render

;; Set TileMap tipe (00,48,96)
_tileMap: .dw #_set32_048		
_tileMap_2: .dw #_set32_096	
_loguito: .dw #_logo

;; Define one Zero-terminated string
string_win:	.asciz	 "You've won the game"
string_next: .asciz	 "<Return 4 next lvl>"
string: .asciz  		 "<Return to start>"
string2: .asciz 		 "<R to go back>"
string_cleared: .asciz	 "LEVEL    CLEARED!"
string_win2: .asciz	 "Congratulations!"
string_game_over: .asciz "GAME OVER"     
string_controls5: .asciz "P: Pause"
string_controls4: .asciz "D: Right"
string_controls: .asciz  "CONTROLS"
string_controls2: .asciz "A: Left"
string_pause: .asciz     "R-ESUME"
string_controls3: .asciz "S: Down"
string_controls1: .asciz "W: Up"
string_pause2: .asciz    "E-XIT"
string_pause3: .asciz    "||"
string_cleared2: .asciz  "#"


_digit_1: 	  .db #48
_digit_2: 	  .db #48
_digit_3: 	  .db #48
_digit_4: 	  .db #48
_lvl_digit_1: .db #48
_lvl_digit_2: .db #48

_current_tileMap: .db #0
_flips_tileMaps:	.db #0
_flips_per_level: .db #3


;; Render System INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
renderSys_Init::
	_draw_method: 	.db 0		;; Switch draw Sprite(0) or Box(1)

	ld 	c, #0 			;; Mode
	call  cpct_setVideoMode_asm	;; Set Video Mode
	ld 	hl, #_newPalette 		;; Palete Array
	ld 	de, #16 			;; Size of Palete
	call  cpct_setPalette_asm	;; Set Palete
	cpctm_setBorder_asm HW_BLACK	;; Set border color
ret


renderSys_UpdateStartGame::
	ld	a, (_flips_tileMaps)
	ld	bc, (_flips_per_level)
	cp	c
	jr	z, _finish
	inc	a
	ld	(_flips_tileMaps), a

	ld	a, (_current_tileMap)
	inc	a
	cp	#2
	jr	nz, _no_reset

	ld	a, #0

	_no_reset:
	ld	(_current_tileMap), a
	
	call renderSys_SetTileMap
	jr	_end

	_finish:
	ld	a, #0
	ld	(_flips_tileMaps), a
	call gameMan_StartLevel

	_end:
ret

renderSys_SetTileMap::
	cp	#1
	jr	z, _set_tileMap_1


	_set_tileMap_0:
	ld    hl, (_tileMap)         	;; tileset pointer
	jr	_tileMap_setted

	_set_tileMap_1:
	ld    hl, (_tileMap_2)         	;; tileset pointer

	_tileMap_setted:

	call renderSys_UpdateMap

ret

renderPunctuation:
	;; PTS
	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_cleared2    ;; IY = Pointer to the string
	ld	c, #26					;; Width
	ld	b, #72				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	;; DIGIT 1
	ld    de, #0xC000				;;Start of memory
	ld     c, #32       		;; x [0-79]
	ld     b, #72 
	call cpct_getScreenPtr_asm
	ld	de, (_digit_4)		;; The digit to print
	call cpct_drawCharM0_asm

	;; DIGIT 2
	ld    de, #0xC000				;;Start of memory
	ld     c, #36       		;; x [0-79]
	ld     b, #72 
	call cpct_getScreenPtr_asm
	ld	de, (_digit_3)		;; The digit to print
	call cpct_drawCharM0_asm

	;; DIGIT 3
	ld    de, #0xC000				;;Start of memory
	ld     c, #40       		;; x [0-79]
	ld     b, #72 
	call cpct_getScreenPtr_asm
	ld	de, (_digit_2)		;; The digit to print
	call cpct_drawCharM0_asm

	;; DIGIT 4
	ld    de, #0xC000				;;Start of memory
	ld     c, #44       		;; x [0-79]
	ld     b, #72 
	call cpct_getScreenPtr_asm
	ld	de, (_digit_1)		;; The digit to print
	call cpct_drawCharM0_asm

	;; PTS
	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_cleared2    ;; IY = Pointer to the string
	ld	c, #50					;; Width
	ld	b, #72				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString
ret

renderSys_UpdateWin::
	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_win2    ;; IY = Pointer to the string
	ld	c, #8					;; Width
	ld	b, #45				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_win    ;; IY = Pointer to the string
	ld	c, #2					;; Width
	ld	b, #57				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	call renderPunctuation

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string2   ;; IY = Pointer to the string
	ld	c, #12					;; Width
	ld	b, #90				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString
ret

renderSys_UpdatePunctuation::
	call	gameMan_getDigit1
	ld	(_digit_1), a

	call	gameMan_getDigit2
	ld	(_digit_2), a

	call	gameMan_getDigit3
	ld	(_digit_3), a

	call	gameMan_getDigit4
	ld	(_digit_4), a

ret

renderSys_ClearScreen::
	ld	hl, #0xC000
	ld	de, #0xC001
	ld	(hl), #00
	ld	bc, #0x4000
	ldir
ret

renderSys_UpdateLevel::
	call gameMan_GetLevel
	ld	(_lvl_digit_1), bc
	ld	(_lvl_digit_2), a
ret

renderSys_UpdateStart::
	call drawLogo

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_controls    ;; IY = Pointer to the string
	ld	c, #24					;; Width
	ld	b, #80				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_controls1    ;; IY = Pointer to the string
	ld	c, #30					;; Width
	ld	b, #95				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_controls2    ;; IY = Pointer to the string
	ld	c, #26					;; Width
	ld	b, #105				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_controls3    ;; IY = Pointer to the string
	ld	c, #26					;; Width
	ld	b, #115				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_controls4    ;; IY = Pointer to the string
	ld	c, #24				;; Width
	ld	b, #125				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_controls5    ;; IY = Pointer to the string
	ld	c, #24				;; Width
	ld	b, #135				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string    ;; IY = Pointer to the string
	ld	c, #6					;; Width
	ld	b, #160				;; Height
	ld    h, #0x00        			;; D = Background color PEN (0)
	call renderSys_PrintString

ret

renderSys_LevelCleared::
	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_cleared    ;; IY = Pointer to the string
	ld	c, #6					;; Width
	ld	b, #55				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	;; LVL DIGIT 1
	ld    de, #0xC000				;;Start of memory
	ld     c, #30       		;; x [0-79]
	ld     b, #55 
	call cpct_getScreenPtr_asm
	ld	de, (_lvl_digit_1)		;; The digit to print
	call cpct_drawCharM0_asm

	;; LVL DIGIT 2
	ld    de, #0xC000				;;Start of memory
	ld     c, #34       		;; x [0-79]
	ld     b, #55 
	call cpct_getScreenPtr_asm
	ld	de, (_lvl_digit_2)		;; The digit to print
	call cpct_drawCharM0_asm

	call renderPunctuation

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_next    ;; IY = Pointer to the string
	ld	c, #2					;; Width
	ld	b, #90				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

ret

;; Render System UPDATE START
;; Destroy: HL, BC, DE, IY
renderSys_UpdateGameOver::
	ld    l, #1         		;; E = Foreground color PEN (3)
	ld   iy, #string_game_over   ;; IY = Pointer to the string
	ld	c, #22					;; Width
	ld	b, #55				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	call renderPunctuation

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string2   ;; IY = Pointer to the string
	ld	c, #12					;; Width
	ld	b, #90				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString
ret

renderSys_UpdatePause::
	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_pause   ;; IY = Pointer to the string
	ld	c, #26					;; Width
	ld	b, #72				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_pause2   ;; IY = Pointer to the string
	ld	c, #30					;; Width
	ld	b, #105				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString

	ld    l, #1         ;; E = Foreground color PEN (3)
	ld   iy, #string_pause3   ;; IY = Pointer to the string
	ld	c, #36					;; Width
	ld	b, #88				;; Height
	ld    h, #0x05        			;; D = Background color PEN (0)
	call renderSys_PrintString
ret

renderSys_DeletePause::
	ld 	c, #26
	ld 	b, #72
	ld    de, #CPCT_VMEM_START_ASM 	;; DE = Pointer to start of the screen
	call cpct_getScreenPtr_asm
	ex 	de,  hl                   ;; exange values from de and hl
	ld 	a,   #0xF0                ;; load F0 in hexadecimal on a
	ld 	bc,  #0x081C              ;; load 0804 in hexadecimal on bc
	call cpct_drawSolidBox_asm      ;; draws a box of a colour in bc position

	ld 	c, #26
	ld 	b, #105
	ld    de, #CPCT_VMEM_START_ASM 	;; DE = Pointer to start of the screen
	call cpct_getScreenPtr_asm
	ex 	de,  hl                   ;; exange values from de and hl
	ld 	a,   #0xF0                ;; load F0 in hexadecimal on a
	ld 	bc,  #0x081C              ;; load 0804 in hexadecimal on bc
	call cpct_drawSolidBox_asm      ;; draws a box of a colour in bc position

	ld 	c, #36
	ld 	b, #88
	ld    de, #CPCT_VMEM_START_ASM 	;; DE = Pointer to start of the screen
	call cpct_getScreenPtr_asm
	ex 	de,  hl                   ;; exange values from de and hl
	ld 	a,   #0xF0                ;; load F0 in hexadecimal on a
	ld 	bc,  #0x0808              ;; load 0804 in hexadecimal on bc
	call cpct_drawSolidBox_asm      ;; draws a box of a colour in bc position
ret

;; Draw Text
renderSys_PrintString::
	push iy
	push bc
	;; Set up draw char colours before calling draw string
	call cpct_setDrawCharM0_asm   	;; Set draw char colours

	;; Calculate a video-memory location for printing a string
	pop bc
	ld    de, #CPCT_VMEM_START_ASM 	;; DE = Pointer to start of the screen
	call cpct_getScreenPtr_asm    	;; Calculate video memory location and return it in HL

	;; Print the string in video memory
      ;; HL already points to video memory, as it is the return
      ;; value from cpct_getScreenPtr_asm	
      pop iy
      call cpct_drawStringM0_asm  ;; Draw the string
	
ret

;; Input:
;; 	A: _draw_method Value set
renderSys_SwitchDraw::
	ld (_draw_method), a
ret

drawLogo:
	ld    de, #0xC000				;;Start of memory
	ld	c, #16					;; Y-3 (ajust sprite position)
	ld	b, #35
	call cpct_getScreenPtr_asm

	ex    de, hl        	  		;; DE = HL --> Position
	ld 	c, #50
	ld 	b, #20
	ld 	hl, (_loguito)
	call cpct_drawSprite_asm		;; Draw Sprite

ret

renderSys_UpdateMap::


	;;(1B C) width   Width in tiles of the view window to be drawn
   	;;(1B B) height  Height in tiles of the view window to be drawn
   	;;(2B DE) tilemapWidth Width in tiles of the complete tilemap
   	;;(2B HL) tileset   Pointer to the start of the tileset definition (list of 32-byte tiles).
	
	ld    c, #20 			;; tilemap width (tiles)
	ld    b, #25 			;; tilemap height (tiles)
	ld    de, #_level32_W         ;; tilemap width
	
   	call cpct_etm_setDrawTilemap4x8_ag_asm



	;;(2B HL) memory Video memory location where to draw the tilemap (character & 4-byte aligned)
	;;(2B DE) tilemap   Pointer to the upper-left tile of the view to be drawn of the tilemap
	ld    hl, #0xC000			;; Start of video memory
	ld    de, #_level32      	;; tilemap pointer
	call cpct_etm_drawTilemap4x8_ag_asm
 

ret