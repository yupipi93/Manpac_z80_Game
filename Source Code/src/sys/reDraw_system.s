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
;; reDraw system
;;

.include "cpctelera.h.s"
.include "man/entity_manager.h.s"
.include "tile_system.h.s"
.globl cpct_getScreenPtr_asm
.globl cpct_drawSolidBox_asm
.globl cpct_drawSprite_asm


.globl _cocos_0 		;; 
.globl _cocos_1 		;; 
.globl _cocos_2 		;; 

.module reDraw


;; reDraw System INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
reDrawSys_Init::
	ld (_ent_array_ptr),ix 			;; Load pointer to entities array
	ld (_num_entities), a 			;; Load num of entities

	_ent_counter: 	.db 0		;; Entity counter definition
	_tilet_Redraw_On: .db 0		;; Switch reDraw tilet or not
	_background_Ptr: 	.dw 0000	;; To Select de Backgrawn Tile Ptr
ret	



;; reDraw System UPDATE
;; Draw erased Tiles 
;; Destroys:
reDrawSys_Cocos::
	_ent_array_ptr = .+ 2 			;; |
	ld 	ix, #0x0000 			;; Recover array pointer in ix


	_num_entities = .+1 			;; |
	ld 	a, #0 				;; Recover in B number of entities
	ld (_ent_counter), a

	call _eraseSprite 			;; |WTF
	
	ld	a, e_life(ix)
	cp	#e_dead
	jr	z, _player_dead

	call _calculateScreenPtrSprite	;; |WTF
	push hl
	call _reDrawBackground 			;; |
	pop hl
	call _drawSprite				;; |WTF

	_player_dead:

	;; Check for entities
	ld 	a, (_ent_counter)			;; |
	dec 	a					;; |
	ld 	(_ent_counter), a			;; _ent_counter--
	ld 	bc, #sizeof_e 			;; |
	add 	ix, bc 				;; Advance to next array position
		


	;;##################################
	;; LOOP BACKGROUN
	;;##################################
	_renLoop_Background:
		ld	a, e_life(ix)
		cp	#e_dead
		jr	z, _dead
		call _eraseSprite 			;; |WTF
		call _calculateScreenPtrSprite	;; |WTF
		;;push hl
		;;call _reDrawBackground 			;; |
		;;pop hl
		call _drawSprite				;; |WTF

		_dead:
		;; Check for entities
		ld 	a, (_ent_counter)			;; |
		dec 	a					;; |
		ld 	(_ent_counter), a			;; _ent_counter--
		jr 	z, _end_loop_entities		;; if 0, breack loop

		;; else
 		ld 	bc, #sizeof_e 			;; |
		add 	ix, bc 				;; Advance to next array position
	jr _renLoop_Background

	_end_loop_entities:

	;;##################################
	;; SUPERCOCOS
	;;##################################
	call _reDraw_SuperCocos



	ret


	_reDraw_SuperCocos:
	;;Check if SuperCoco an draw

		ld 	hl, #_cocos_2			;; |
		ld (_background_Ptr), hl 		;; Selecto sprite to draw

		;; Right-Up
		ld     b, #72	 	  		;; x 
		ld     c, #16	       		;; y 
		call tileSys_GetTile 			;; get in DE TilePtr
		ld a, (de)
		cp #0x33
		jr nz, _not_Right_Up
		ld     c, #72	 	  		;; x 
		ld     b, #16	       		;; y 		
		call _reDraw
		_not_Right_Up:

		;; Left-Down
		ld     b, #04	 	  		;; x 
		ld     c, #16	       		;; y 
		call tileSys_GetTile 			;; get in DE TilePtr
		ld a, (de)
		cp #0x33
		jr nz, _not_Left_Up	
		ld     c, #04	 	  		;; x 
		ld     b, #16	       		;; y 
		call _reDraw
		_not_Left_Up:

		;; Right-Down
		ld     b, #72	 	  		;; x 
		ld     c, #152	       		;; y 
		call tileSys_GetTile 			;; get in DE TilePtr
		ld a, (de)
		cp #0x33
		jr nz, _not_Right_Down
		ld     c, #72	 	  		;; x 
		ld     b, #152	       		;; y 
		call _reDraw
		_not_Right_Down:

		;; Left-Down
		ld     b, #4	 	  		;; x 
		ld     c, #152	       		;; y
		call tileSys_GetTile 			;; get in DE TilePtr
		ld a, (de)
		cp #0x33
		jr nz, _not_Left_Down
		ld     c, #4	 	  		;; x 
		ld     b, #152	       		;; y 
		call _reDraw
		_not_Left_Down:

	ret

	;;###################
	;; RE-DRAW SPRITES
	;;###################
	_reDrawBackground:
		ld     e, e_cur_tile_al(ix)        		;; x 
		ld     d, e_cur_tile_ah(ix) 	  		;; y 
		;;call tileSys_GetTile 			;; get in DE TilePtr
		ld__iyl_e					;; |
		ld__iyh_d					;; Save in IY the Tileptr
		ld 	a, e_cur_tile(ix)

		_check_left_tile:
			ld a, -1(iy)  			;; Select the left tilet
			call _check_tipeTile 	 	;; check if need draw
			ld a, (_tilet_Redraw_On) 	;; |
			or a 					;; |
			jr z, _not_Draw_Left 		;; Not reDraw this tile

			ld    a, e_cur_tile_x(ix)   	;; Yes reDraw this fuking tile
			sub	#4				;; |
			ld 	c, a 				;; | 
			ld 	b, e_cur_tile_y(ix)	;; |		
			call _reDraw 			;; (x-=4, y)

			_not_Draw_Left:

		_check_rigth_tile:
			ld a, 1(iy)				;; |
			call _check_tipeTile 	 	;; check if need draw
			ld a, (_tilet_Redraw_On) 	;; |
			or a 					;; |
			jr z, _not_Draw_Right 		;; Not reDraw this tile

			ld    a, e_cur_tile_x(ix)        	;; Select the rigth tilet
			add	#4				;; |
			ld 	c, a 				;; | 
			ld 	b, e_cur_tile_y(ix) 	  		;; |		
			call _reDraw 			;; (x+=4, y)

			_not_Draw_Right:


		_check_up_tile:
			ld a, -20(iy)
			call _check_tipeTile 	 	;; check if need draw
			ld a, (_tilet_Redraw_On) 	;; |
			or a 					;; |
			jr z, _not_Draw_Up		;; Not reDraw this tile

			ld 	c, e_cur_tile_x(ix) 	  		;; Select the up tilet		
			ld    a, e_cur_tile_y(ix)       		;; |
			sub	#8				;; |
			ld 	b, a 				;; | 
			call _reDraw 			;; (x, y-=8)

			_not_Draw_Up:



		_check_down_tile:
			ld a, 20(iy)
			call _check_tipeTile 	 	;; check if need draw
			ld a, (_tilet_Redraw_On) 	;; |
			or a 					;; |
			jr z, _not_Draw_Down		;; Not reDraw this tile

			ld 	c, e_cur_tile_x(ix) 	  		;; Select the down tilet		
			ld    a, e_cur_tile_y(ix)        	;; |
			add	#8				;; |
			ld 	b, a 				;; | 
			call _reDraw 			;; (x, y+=8)

			_not_Draw_Down:
		

	ret

	;;Input: A=tileTipe
	_check_tipeTile:
		;;and #0x0F
		ld hl, #_cocos_0				;; |
		ld (_background_Ptr), hl		;; Load Coco Sprite

		and	#0x0F
		cp #2 					;; Coco en pasillo
		jr z,_yes_reDraw 				;; |
		cp #6 					;; Coco en Cruce
		jr z,_yes_reDraw 				;; |
		cp #9 					;; Coco en esquina 
		jr z,_yes_reDraw				;; |


		_no_reDraw:
			ld a, #0				;; |
			ld (_tilet_Redraw_On), a 	;; Re-Draw OFF
	ret
		_yes_reDraw:
			;;LOAD SPRITE TILE MAP

			ld a, #1 				;; |
			ld (_tilet_Redraw_On), a  	;; Re-Draw ON
	ret

	;;Input: BC=Y,X
	_reDraw:
		ld    de, #0xC000				;;Start of memory
		call cpct_getScreenPtr_asm

		ex    de, hl        	  		;; DE = HL --> Position
		ld 	hl, (_background_Ptr)		;; Ptr to Sprite
		ld 	c, e_w(ix) 				;; Sprite_Width
		ld 	b, e_h(ix)				;; Sprite_Height
		call cpct_drawSprite_asm		;; Draw Sprite



	ret






	;;###################
	;; ERASE
	;;###################
	_eraseSprite:
		ld 	e, e_lst_vmeml(ix) 		;; |
		ld 	d, e_lst_vmemh(ix) 		;; Load last positon
		ld 	a, #0xF0				;; Negro
		ld 	c, e_sw(ix) 			;; Entity_Width
		ld 	b, e_sh(ix) 			;; Entity_Height
		call cpct_drawSolidBox_asm
	ret



	;;###################
	;; SCREEN POSITION
	;;###################
	_calculateScreenPtrSprite:
		ld    de, #0xC000				;;Start of memory
		ld     c, e_x(ix)        		;; x [0-79]
		ld     b, e_y(ix) 	  		;; y [0-199]
		dec c						;; X-2 (ajust sprite position)
		dec b 					;; |
		dec b						;; |
		dec b 					;; Y-3 (ajust sprite position)
		call cpct_getScreenPtr_asm
		
		ld 	e_lst_vmeml(ix), l		;; |
		ld 	e_lst_vmemh(ix), h		;; Store the Video Memory Position

	ret

	;;###################
	;; DRAW SPRITES
	;;###################

	_drawSprite:
		ex    de, hl        	  		;; DE = HL --> Position
		ld 	c, e_sw(ix) 			;; Sprite_Width
		ld 	b, e_sh(ix) 			;; Sprite_Height
		ld 	l, e_sprite_l(ix)			;; |
		ld 	h, e_sprite_h(ix)			;; Load sprite pointer
		call cpct_drawSprite_asm		;; Draw Sprite

	ret