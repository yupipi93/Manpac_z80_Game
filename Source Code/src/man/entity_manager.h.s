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
;; Entity Manager Head
;;

.globl entityMan_Init
.globl entityMan_Create
.globl entityMan_GetEntityArray
.globl pacmans_alive
.globl entityMan_CreatePacman


.macro DefineEntity _name, _sprite
_name::

	.db 0 			;; Bounding X Position
	.db 0				;; Bounding Y Position
	.db 4 			;; Bounding Width  (4b = 8px)
	.db 8				;; Bounding Height (8b = 8px)
	.db 6 			;; Sprite Width  (7b  = 14px)
	.db 14			;; Sprite Height (16b = 16px)
	.dw 0				;; Animation ptr
	.db 0 			;; X Velocity
	.db 0				;; Y Velocity
	.db 2				;; Speed
	.db 0x00 			;; AI_aim_x (use in Move_to)
	.db 0x00			;; AI_aim_y (use in Move_to)
	.db e_ai_st_patrol	;; AI_st (status) 
	.db 0				;; patrol ID
	.db 0				;; patrol step
	.dw _sprite			;; Pointer to sprite
	.db 0x01		 	;; Entity is alive, dead or reborn (2 power-up 1 alive, 0 dead)
	.db 0x01		 	;; Last entity state (2 power-up 1 alive, 0 dead)
	.db e_power_max		;; Power left of power up	
	.dw 0xADDE;;(<-rand pos);; Store de last video memory position to erase entity
	
	.db 2				;; Current direction
	.db 2				;; Next direction
	.db 2				;; Previous direcction (for Animations)
	.db 4				;; X movements to tile change
	.db 8				;; Y movements to tile change
	.db 0				;; Current tile content
	.dw 0				;; Current tile adress
	.db 0				;; Current tile x pos
	.db 0				;; Current tile y pos

.endm


e_x 		  = 0 	;; Bounding X Position
e_y 		  = 1 	;; Bounding Y Position
e_w 		  = 2 	;; Bounding Width
e_h 		  = 3 	;; Bounding Height
e_sw 		  = 4 	;; Sprite Width
e_sh		  = 5 	;; Sprite Height
e_anim_l	  = 6 	;; |
e_anim_h	  = 7 	;; |Animation Ptr
e_vx 		  = 8 	;; X Velocity
e_vy 		  = 9 	;; Y Velocity
e_speed	  = 10
e_ai_aim_x 	  = 11	;; Target Positon x
e_ai_aim_y	  = 12	;; Target Positon y
e_ai_st	  = 13 	;; AI Status
e_ai_patrol   = 14
e_ai_step 	  = 15
e_sprite_l 	  = 16	;; |
e_sprite_h 	  = 17	;; Pointer to sprite
e_life        = 18 	;; Dead, Alive, or Powered Up
e_pre_life    = 19 	;; Previous Dead, Alive, or Powered Up
e_power_left  = 20
e_lst_vmeml   = 21 	;; |
e_lst_vmemh   = 22	;; Store de last video memory position to erase entity
e_curr_dir	  = 23	;; 1 = up, 2 = right, 3 = down, 4 = left
e_next_dir	  = 24
e_pre_dir	  = 25	;; Previous direcction (for Animations)
e_x_to_tile	  = 26
e_y_to_tile	  = 27
e_cur_tile	  = 28
e_cur_tile_al = 29
e_cur_tile_ah = 30
e_cur_tile_x  = 31
e_cur_tile_y  = 32
sizeof_e	  = 33

e_ai_st_move_to 	= 0
e_ai_st_patrol	= 1

e_power_max		= 80
e_powered_up	= 2
e_alive	 	= 1
e_dead   		= 0

