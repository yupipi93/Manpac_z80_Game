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
;; TILE SYSTEM
;;
.include "man/tile_manager.h.s"

.module tile_system

;; INPUT: 
;;	BC: Position XY of the entity
;; RETURNS:
;;	DE: The memory address of the tile
;;	 A: The content of the tile where the entity is
;; DESTROYS: BC, DE, HL, A
tileSys_GetTile::
	;; (Y/8)*Tile_Width + (X/4)

	;;Transform Bytes to Tiles X
	srl b		;; / 
	srl b 	;; \ Dividing X by 4 (widht = 8px = 4bytes)

	ld d, #0	;; /
	ld e, b	;; | Saving B value in DE
	ld b, #0	;; \ Emptying B for later use of BC
	
	;;Transform Bytes to Tiles Y
	srl c		;; / 
	;;srl c	;; | Dividing C by 8 to get the tile number
	;;srl c 	;; | on Y and multiplying on 4 in order to
	;;sla c 	;; | calculate 20Y = 4Y + 16Y
	;;sla c	;; \
	
	ld h, #0 	;; Emptying H for later use of HL
	ld l, c 	;; Store C (4*Y) in HL for later use of HL
	
	add hl, hl 	;; /
	add hl, hl	;; \ Getting 16Y multiplying 4Y (HL) by 4
	
	add hl, de	;; Adding DE (X) to HL (16Y)
	add hl, bc 	;; Adding BC (4Y) to HL (X+16Y)

	;; In this point, HL is X + 20Y, what means, the number
	;; of the tile (byte) the entity is

	;; Storing HL on BC for later use
	ld b, h
	ld c, l

	
	ld hl, #_tiles ;; Getting the tiles matrix addres
	add hl, bc	  ;; and adding the tile number of the entity

	ld d, h
	ld e, l
	

	ld a, (hl)
	;; removing the first byte
	;;and #0x0F

ret

tileSys_Sub_Coco::
	ld	a, (_n_cocos)
	dec	a
	ld	(_n_cocos), a
ret

tileSys_Get_Cocos::
	ld	a, (_n_cocos)
ret

tileSys_Reset_Map::
	ld	a, (_n_cocos)
	cp	#n_cocos_default
	jr	z, _no_restart_required

	ld	a, #n_cocos_default
	ld	(_n_cocos), a

	ld	a, #n_cocos_default
	ld	(_n_cocos), a

	ld	hl, #_tiles
	ld	bc, #0
	
	_loop:

		ld	a, (hl)
		;;sub	#0xAA
		;;jp	p, _looping
		;;jr	z, _looping
		cp	#0xAA
		jr	z, _looping
		cp	#0xBB
		jr	z, _looping
		cp	#0xCC
		jr	z, _looping
		cp	#0xDD
		jr	z, _looping
		cp	#0xEE
		jr	z, _looping
		cp	#0xFF
		jr	z, _looping
		;;add	#0xAA

		and	#0xF0

		ld	e, a
		
		srl	a
		srl	a
		srl	a
		srl	a

		or	e

		ld	(hl), a

		_looping:
		inc	hl
		inc 	bc

		ld	a, b
		cp	#1
		jr	nz, _b_not_one

		_b_one:
			ld	a, c
			cp	#0xF4
			jr	z, _no_restart_required

		_b_not_one:
		jr	_loop

	_no_restart_required:
ret