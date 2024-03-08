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
;; Animation System
;;


.include "man/entity_manager.h.s"
.include "man/animation_manager.h.s"
.include "cpctelera.h.s"
.include "assets/assets.h.s"
.globl cpct_getScreenPtr_asm 
.globl cpct_drawSolidBox_asm
.globl cpct_drawSprite_asm


.module sys_animation


;; Animation System INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
animationSys_Init::
	ld (_ent_array_ptr), ix 	;; Load pointer to entities array
	ld (_num_entities), a 		;; Load num of entities

	_total_entities: .db 0
	ld (_total_entities), a

	_ent_counter: 	.db 0		;; Entity counter definition

ret









;; Animation System UPDATE Entities
;; Destroy: AF, HL, BC, DE, IX
animationSys_Update::

	
	_ent_array_ptr = .+2 			;; |
	ld 	ix, #0x0000 			;; Recover array pointer in ix


	_num_entities = .+1 			;; |
	ld 	a, #0 				;; Recover in B number of entities
	ld (_ent_counter), a



	_loop_Entities:
		ld	a, e_life(ix) 			;; Check if alive
		cp	#e_dead				;; |
		jr	z, _dead				;; Dead = next entity

		ld a, (_ent_counter)			;; |
		ld b, a					;; |
		ld a, (_total_entities)			;; |
		cp b						;; |
		jr nz, _noPlayer				;; Check if entity is a player

		call _set_dir_animation_Player 	;; set player animation
		jr _not_Pacman
		_noPlayer:					;; if not player
		call _set_dir_animation_Pacman 	;; set pacman animation
		_not_Pacman:
		call _animation_pipeline 		;; Animation pipeline

		_dead:
		;; Check for entities
		ld 	a, (_ent_counter)			;; |
		dec 	a					;; |
		ld 	(_ent_counter), a			;; _ent_counter--
		ret 	z 					;; if 0, breack loop

		;; else
 		ld 	bc, #sizeof_e 			;; |
		add 	ix, bc 				;; Advance to next array position
	jr _loop_Entities



ret
	;;###############
	;; SET ANIMATION
	;;###############
	_set_dir_animation_Player::
		;;============
		;; In C++
		;;============
		;; if (e_life == 2 && e_life != e_pre_life)
		;;	e_pre_life = e_life
		;; 	Active Super animation
		;;	Return 	
		;;
		;; else if (e_life == 2)
		;; 	Return (do nothing)
		;;
		;; else if (e_curr_dir != e_pre_dir)
		;;	e_pre_dit = e_curr_dir
		;; 	Active Direction anumation
		;;
		;; else 
		;; 	Return (do nothing)
		;; 








		;;=====================
		;; Super State
		;;=====================
		ld a, e_life(ix)				;; Check if Super is Active 
		cp #2						;; #2 = Active
		jr nz, _notSuper				;; If not Active, continue with directions

		ld a, e_pre_life(ix) 			;; Check if previusly super state
		ld b, a					;; |
		ld a, e_life(ix) 				;; |
		cp b 						;; |

		ld a, e_life(ix)				;; |(load A previusly)
		ld e_pre_life(ix), a			;; Update previous state 	

		jr z, _not_change_player_anim 	;; If is the same, do nothing

		

		;;If state is super and not preState isnt super, avtive anim_Super
		call _super_anim_player 			;; Active Super Animation
		jr _not_change_player_anim		;; if pre == dir (do nothing)

		_notSuper:					;; Not Active
		;;iF e_life != 2 and e_pre_life = 2
		ld a, e_pre_life(ix)
		cp #2		
			
		ld a, e_life(ix)				;; |(load A previusly)
		ld e_pre_life(ix), a			;; Update previous state 

		jr z, _up_anim_player

		
		;;=====================
		;; Directions
		;;=====================
		;;e_pre_dir != e_curr_dir
		ld a, e_pre_dir(ix)			;; |
		ld b, a					;; if same direction
		ld a, e_curr_dir(ix)			;; not reset animation
		cp b						;; |
		jr z, _not_change_player_anim		;; if pre == dir (do nothing)

		;;ld a, e_curr_dir(ix)			;; | (load A previusly)
		ld e_pre_dir(ix), a			;; Update Pre dir

		;;e_curr_dir --> 1 = up, 2 = right, 3 = down, 4 = left
		;;ld a, e_curr_dir(ix)			;; Load Current dir (load A previusly)
		cp #1						;; |
		jr z, _up_anim_player			;; up??
		cp #2						;; |
		jr z, _rigth_anim_player		;; right??
		cp #3						;; |
		jr z, _down_anim_player			;; down??
		cp #4						;; |
		jr z, _left_anim_player			;; left??

		_not_change_player_anim:

	ret


	_super_anim_player:
		ld e_anim_l(ix), #<_player_super	     			;; Little
		ld e_anim_h(ix), #>_player_super				;; Big

	ret

	_up_anim_player:
		ld e_anim_l(ix), #<_player_walking_up	     		;; Little
		ld e_anim_h(ix), #>_player_walking_up			;; Big
	ret

	_rigth_anim_player:

		ld e_anim_l(ix), #<_player_walking_rigth	     		;; Little
		ld e_anim_h(ix), #>_player_walking_rigth			;; Big
	ret

	_down_anim_player:
		ld e_anim_l(ix), #<_player_walking_down	     		;; Little
		ld e_anim_h(ix), #>_player_walking_down			;; Big
	ret

	_left_anim_player:
		ld e_anim_l(ix), #<_player_walking_left	     		;; Little
		ld e_anim_h(ix), #>_player_walking_left			;; Big
	ret




	_set_dir_animation_Pacman:

			;;e_pre_dir != e_curr_dir
		ld a, e_pre_dir(ix)			;; |
		ld b, a					;; |
		ld a, e_curr_dir(ix)			;; |
		cp b						;; |
		jr z, _not_change_pacman_anim		;; if pre == dir (do nothing=

		ld a, e_curr_dir(ix)			;; |
		ld e_pre_dir(ix), a			;; Update Pre dir

		;;e_curr_dir --> 1 = up, 2 = right, 3 = down, 4 = left
		ld a, e_curr_dir(ix)			;; Load Current dir
		cp #1						;; |
		jr z, _up_anim_pacman			;; up??
		cp #2						;; |
		jr z, _rigth_anim_pacman		;; right??
		cp #3						;; |
		jr z, _down_anim_pacman			;; down??
		cp #4						;; |
		jr z, _left_anim_pacman			;; left??


		_not_change_pacman_anim:

	ret

	_up_anim_pacman:
		ld e_anim_l(ix), #<_pacman_walking_up	     		;; Little
		ld e_anim_h(ix), #>_pacman_walking_up			;; Big
	ret

	_rigth_anim_pacman:

		ld e_anim_l(ix), #<_pacman_walking_rigth	     		;; Little
		ld e_anim_h(ix), #>_pacman_walking_rigth			;; Big
	ret

	_down_anim_pacman:
		ld e_anim_l(ix), #<_pacman_walking_down	     		;; Little
		ld e_anim_h(ix), #>_pacman_walking_down			;; Big
	ret

	_left_anim_pacman:
		ld e_anim_l(ix), #<_pacman_walking_left	     		;; Little
		ld e_anim_h(ix), #>_pacman_walking_left			;; Big
	ret

	


	;;###############
	;; PIPELINE
	;;###############
	_animation_pipeline:
		;; Animation array
		;; sp1 , sp2  , nullp, start
		;;62 74, 62 76, 62 78, 62 7A
		;;A0 42, F4 42, 00 00, 73 62
		
		;;Load Sprite ptr
		ld l, e_anim_l(ix)			;; |
		ld h, e_anim_h(ix)			;; Load Sprite ptr
		;;HL = 6273 = (A0,42) = Sprite0

		_continue_anim:
		;;Load sprite data
		ld e, (hl)					;; Load little part of ptr to sprite 
		inc hl					;; Load Big of prt to sprite
		ld d, (hl)					;; DE = Sprite Data
		;; DE = 42A0

		;;Next sprite ptr
		inc hl 					;; HL++ (next animation ptr)
		;;62 76

		;;Check if data = nullptr
		ld a, e 					;; |
		or d  					;; |
		jr z, _fin_anim 				;; IF (sprite data = nulptr) reseet anim

		
		
		;;Store next sprite ptr
		ld e_anim_l(ix), l	     		;; Little
		ld e_anim_h(ix), h			;; Big

		;;Draw sprite data
		ld e_sprite_l(ix), e 			;; | 
		ld e_sprite_h(ix), d 			;; Store Sprite into entity



		
	ret

	_fin_anim:
		ld a,(hl) 					;; HL -> first sprite ptr
		inc hl 					;; |
		ld h, (hl) 					;; |
		ld l, a 					;; HL = (*HL)
		jr _continue_anim
	