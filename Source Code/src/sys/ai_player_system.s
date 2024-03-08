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
;; System AI Player Control
;;

.include "man/entity_manager.h.s"
.include "cpctelera.h.s"

.module ai_player_control

;; AI System Control INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
aiPlayerSys_Init::
	ld 	(_player_pointer),	ix	;; Load Player entity

ret	

aiPlayerSys_Update::

	;; Restore player data in IY
	_player_pointer = .+ 2			;; |
	ld 	iy, #0x0000 			;; Recover Player entity

	ld e_vx(iy), #0
	ld e_vy(iy), #0

	ld	a, e_power_left(iy)
	dec	a
	ld	e_power_left(iy), a
	cp	#0
	jr	nz, _power_left

	ld	e_life(iy), #1
	_power_left:

	;; Loading the current tile of the player
;:	ld 	a, e_x(iy)				;; [Get player X data]
;:	ld	b, a
;:	ld	a, e_y(iy)
;:	ld	c, a					;; bc = xy position of the player

	;; INPUT: BC: The XY position of the entity
	;; OUTPUT:
	;;	  A: The content of the tile
	;;	 DE: The memory direction of the tile
;;	call tileSys_GetTile
	ld a, e_cur_tile(iy)
	ld e, e_cur_tile_al(iy)
	ld d, e_cur_tile_ah(iy)
	ld__ixl_e
	ld__ixh_d
	;;and #0x0F	
	
	;;ld ix, de

	;; Player IA Control
	;; Checking change direction
	;;ld a, e_curr_dir(iy)
	;;cp e_next_dir(iy)
	;;jp z, _end_dir_check

	;; If player is in corner
	push af

	srl a
	cp #4
	jr z, _check_dir_change ;; Stablish the only possible direction

	
	;;If player is in a teleport, he won't change direction but will
	;;teleport if is going in that direction
	cp #5
	jp z, _check_teleport


	;; If player is in a corridor, he can't change direction
	srl a
	or #0
	jp z, _end_dir_check
	
	
	
	
	;; If player is in a crossroad, he will change his direction if possible
	cp #1
	jr z, _check_dir_change

	pop af

	jp _end_dir_check


	_check_dir_change:
		ld a, e_x_to_tile(iy)
		cp #4
		jr nz, _end_dir_check
		
		ld a, e_y_to_tile(iy)
		cp #8
		jr nz, _end_dir_check


		ld a, e_next_dir(iy)
		cp #1
		jr z, _check_up_change
		cp #2
		jr z, _check_right_change
		cp #3
		jr z, _check_down_change
		cp #4
		jr z, _check_left_change
		cp #0
		jp z, _end_dir_check

		_check_right_change:
			;; Right
			ld a, 1(ix)
			;; removing the first byte
			and #0x0F
			srl a
			cp #7
			jr nz, _dir_right_change
			jr _end_dir_check

		_check_left_change:
			;; Left
			ld a, -1(ix)
			;; removing the first byte
			and #0x0F
			srl a
			cp #7
			jr nz, _dir_left_change
			jr _end_dir_check

		_check_up_change:
			;; Up
			ld a, -20(ix)
			;; removing the first byte
			and #0x0F
			srl a
			cp #7
			jr nz, _dir_up_change
			jr _end_dir_check

		_check_down_change:
			;; Down
			ld a, 20(ix)
			;; removing the first byte
			and #0x0F
			srl a
			cp #7
			jr nz, _dir_down_change
			jr _end_dir_check


;;	_find_corner_dir:
;;		_check_right:
;;			ld a, e_curr_dir(iy)
;;			cp #2
;;			jr z, _check_up
;;			cp #4
;;			jr z, _check_up
;;			;; Right
;;			ld a, 1(ix)
;;			;; removing the first byte
;;			;;and #0x0F
;;			srl a
;;			cp #7
;;			jr nz, _dir_right
;;
;;		_check_left:
;;			ld a, e_curr_dir(iy)
;;			cp #4
;;			jr z, _dir_right
;;			;; Left
;;			ld a, -1(ix)
;;			;; removing the first byte
;;			;;and #0x0F
;;			srl a
;;			cp #7
;;			jr nz, _dir_left
;;
;;		_check_up:
;;			;; Up
;;			ld a, -20(ix)
;;			;; removing the first byte
;;			;;and #0x0F
;;			srl a
;;			cp #7
;;			jr nz, _dir_up
;;
;;		_check_down:
;;			;; Down
;;			ld a, 20(ix)
;;			;; removing the first byte
;;			;;and #0x0F
;;			srl a
;;			cp #7
;;			jr nz, _dir_down

	
	_dir_right_change:
		ld e_next_dir(iy), #0
	_dir_right:
		ld e_curr_dir(iy), #2
		jr _end_dir_check

	_dir_left_change:
		ld e_next_dir(iy), #0
	_dir_left:
		ld e_curr_dir(iy), #4
		jr _end_dir_check

	_dir_up_change:
		ld e_next_dir(iy), #0
	_dir_up:
		ld e_curr_dir(iy), #1
		jr _end_dir_check

	_dir_down_change:
		ld e_next_dir(iy), #0
	_dir_down:
		ld e_curr_dir(iy), #3
		


	_end_dir_check:

	pop af

	;; Once we have stablish the current direction, we check if we can
	;; keep moving in that direction

	ld a, e_curr_dir(iy)
	cp #1
	jr z, _check_up_move
	cp #2
	jr z, _check_right_move
	cp #3
	jr z, _check_down_move


	_check_left_move:
		ld a, -1(ix)
		;; removing the first byte
		and #0x0F
		srl a
		cp #7
		jr nz, _move_left
		jp _end

	_check_up_move:
		ld a, -20(ix)
		;; removing the first byte
		and #0x0F
		srl a
		cp #7
		jr nz, _move_up
		jp _end

	_check_right_move:
		ld a, 1(ix)
		;; removing the first byte
		and #0x0F
		srl a
		cp #7
		jr nz, _move_right
		jp _end

	_check_down_move:
		ld a, 20(ix)
		;; removing the first byte
		and #0x0F
		srl a
		cp #7
		jr nz, _move_down
		jp _end


	_move_up:
		ld  	a, e_speed(iy)
		add 	a, a
		neg
		ld  	e_vy(iy), a
		jp  	_end
	_move_down:
		ld  	a, e_speed(iy)
		add 	a, a
		ld  	e_vy(iy), a
		jp  	_end
	_move_left:
		ld 	a, e_speed(iy)
		neg
		ld	e_vx(iy), a
		jr	_end

	_move_right:
		ld	a, e_speed(iy)
		ld	e_vx(iy), a
		jr	_end


	_check_teleport:
		pop af
		cp #0x0A
		jr z, _check_tp_left
		
		_check_tp_right:
			ld a, e_curr_dir(iy)
			cp #2
			jr z, _tp_right
			jr _move_left
		
		_check_tp_left:
			ld a, e_curr_dir(iy)
			cp #4
			jr z, _tp_left
			jr _move_right

		
			_tp_right:
				ld 	e_x(iy), #4

				ld 	l, e_cur_tile_al(iy)
				ld	h, e_cur_tile_ah(iy)

				ld	b, #0
				ld	c, #16

				sbc	hl, bc

				ld	a, (hl)
				;;and	#0x0F
				jr _refresh_tile
				
			_tp_left:
				ld 	e_x(iy), #72

				ld 	l, e_cur_tile_al(iy)
				ld	h, e_cur_tile_ah(iy)

				ld	b, #0
				ld	c, #16

				add	hl, bc

				ld	a, (hl)

			_refresh_tile:
				and	#0x0F			
				ld	e_cur_tile_al(iy), l
				ld	e_cur_tile_ah(iy), h
				ld	e_cur_tile(iy), a

				ld	e_x_to_tile(iy), #4
				ld	e_y_to_tile(iy), #8
		
	_end:
ret