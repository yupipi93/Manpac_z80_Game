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
;; System phyisics
;;

.include "man/entity_manager.h.s"
.include "sys/tile_system.h.s"

screen_width = 80 	;; 160px  ;;20 tiles
screen_height = 200	;; 200px  ;;25 tiles

;; Physics System INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
physicsSys_Init::
	ld (_ent_array_ptr),ix 			;; Load pointer to entities array
	ld (_num_entities), a 			;; Load num of entities
ret	





;; Physics System UPDATE
;; Update entities Position
;; Destroys: A, B, C, DE, IX
physicsSys_Update::
	_ent_array_ptr = .+ 2 			;; |
	ld 	ix, #0x0000 			;; Recover array pointer in ix

	_num_entities = .+1 			;; |
	ld 	b, #0 				;; Recover in B number of entities
		


	_update_loop:
		ld	a, e_life(ix)
		cp	#e_dead
		jp	z, _dead
		push bc

		
		;; Speed on teleport halls
		ld	a, e_cur_tile(ix)
		cp	#0x01
		jr	nz, _normal_speed

		_half_speed:
			ld	a, e_vx(ix)
			cp	#0
			jp	p, _half_speed_right
			jr	z, _normal_speed

			_half_speed_left:
				neg
				srl	a
				neg
				ld	e_vx(ix), a
				jr	_normal_speed

			_half_speed_right:
				srl	a
				ld	e_vx(ix), a


		;; Setting new X
		_normal_speed:
		ld 	a, e_x(ix)			;; |
		add 	e_vx(ix)			;; A = E_X + E_VX (Add Force)
		ld	e_x(ix), a

		;; Setting new Y
		ld 	a, e_y(ix)
		add	e_vy(ix)
		ld	e_y(ix), a
		
		ld	a, e_x_to_tile(ix)
		add	e_vx(ix)
		ld	e_x_to_tile(ix), a
		
		ld	a, e_y_to_tile(ix)
		add	e_vy(ix)
		ld	e_y_to_tile(ix), a
		

		_tile_check:
			ld	a, e_x_to_tile(ix)
			cp	#0
			jr	z, _refresh_tile
			cp	#8
			jr	z, _refresh_tile

			ld	a, e_y_to_tile(ix)
			cp	#0
			jr	z, _refresh_tile
			cp	#16
			jr	z, _refresh_tile
			jr 	_end

		_refresh_tile:
			;; Loading the current tile of the player
			ld 	a, e_x(ix)				;; [Get player X data]
			ld	b, a
			ld	e_cur_tile_x(ix), a

			ld	a, e_y(ix)
			ld	c, a					;; bc = xy position of the player
			ld	e_cur_tile_y(ix), a

			;; INPUT: BC: The XY position of the entity
			;; OUTPUT:
			;;	  A: The content of the tile
			;;	 DE: The memory direction of the tile
			call tileSys_GetTile

			ld	e_cur_tile_al(ix), e
			ld	e_cur_tile_ah(ix), d
			and	#0x0F
			ld	e_cur_tile(ix), a

			ld	e_x_to_tile(ix), #4
			ld	e_y_to_tile(ix), #8

			_end:
			pop bc
			_dead:
			dec 	b 			;; num_entities--
			ret 	z			;; return if  num_entities = 0

			ld 	de, #sizeof_e 	;; DE = Entity_size
			add 	ix, de 		;; IX, next entity
			jp 	_update_loop

	ret