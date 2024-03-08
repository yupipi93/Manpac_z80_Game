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
;; Entity Manager
;;

.include "entity_manager.h.s"
.include "cpctelera.h.s"
.include "sys/tile_system.h.s"

pacmans_alive::	.db 0
max_entities 	 == 5							;; Max number of entities
num_entities:: 	.db 0 						;; Current number of entities
last_elem_ptr:: 	.dw entity_array					;; Pointer to last entity added in array
entity_array:: 	.ds max_entities * sizeof_e			;; Reserbate memory for entities


entityMan_Init::
	;; Reset num_entities
	ld	a, #0
	ld	(num_entities), a
	;; Reset entities pointer
	ld	bc, #entity_array
	ld	(last_elem_ptr), bc
	;; Reset pacmans alive
	;;ld	a, (num_entities)
	;;dec a
	ld  a, #0
	ld	(pacmans_alive), a
ret

entityMan_CreatePacman::
;;pacmans_alive += 1
	push af
	
	ld 	a, (pacmans_alive)
	inc a
	ld 	(pacmans_alive), a
	
	pop af
	call entityMan_Create
ret

entityMan_GetEntityArray::
      ld    ix, #entity_array          ;;Convert to function!!!
      ld    a, (num_entities)          ;;Convert to function!!!
ret


;; INPUT:
;;	 A: The patrol ID
;;	 B: The Initial x Position
;;	 C: The Initial y Position
;;	DE: The Initial Animation direction
entityMan_Create::
	;; Unique parameters
	push de
	push bc
	push af

	ld 	de, (last_elem_ptr)		;; DE = Pointer to first position to next entity
	push	de
	ld 	bc, #sizeof_e 			;; BC = Size of entity
	ldir 						;; Copy HL to DE, (BC size)

	ld 	a, (num_entities) 		;; |
	inc 	a					;; |
	ld 	(num_entities), a 		;; | num_entities++

	ld 	hl, (last_elem_ptr) 		;; |  ???? ex hl, de
	ld 	bc, #sizeof_e 			;; |
	add	hl, bc 					;; Last_elemetn_ptrS += entity_size
	ld 	(last_elem_ptr), hl 		;; Update to next empty position 

	;; Stablishing the current tile
	pop	de
	ld__iyl_e
	ld__iyh_d

	;;Unique parameters
	pop	af
	pop	bc
	srl	b
	pop	de
	ld	e_ai_patrol(iy), a
	ld	e_x(iy),	b
	ld	e_ai_aim_x(iy),b
	ld	e_y(iy),	c
	ld	e_ai_aim_y(iy),c
	ld	e_anim_l(iy), e
	ld	e_anim_h(iy), d
	


	;; Loading the current tile of the player
	ld 	a, e_x(iy)				;; [Get player X data]
	ld	b, a
	ld	a, e_y(iy)
	ld	c, a					;; bc = xy position of the player

	;; INPUT: BC: The XY position of the entity
	;; OUTPUT:
	;;	  A: The content of the tile
	;;	 DE: The memory direction of the tile
	call tileSys_GetTile

	ld	e_cur_tile_al(iy), e
	ld	e_cur_tile_ah(iy), d
	and	#0x0F
	ld	e_cur_tile(iy), a

	ld	e_x_to_tile(iy), #4
	ld	e_y_to_tile(iy), #8

ret