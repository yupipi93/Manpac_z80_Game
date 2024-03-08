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
;; Collision System
;;

.include "man/entity_manager.h.s"
.include "man/game_manager.h.s"
.include "sys/render_system.h.s"
.include "cpctelera.h.s"
.globl cpct_drawSolidBox_asm


;; Collision System INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
collisionSys_Init::
	ld 	(_ent_array_ptr), 	ix 	;; Load pointer to entities array
	ld 	(_player_pointer), 	ix	;; Load Player entity
	ld 	(_num_entities), 		a 	;; Load num of entities -1

ret



;; Collision System UPDATE
;; Check player collision with other entities
;; Destroys: 
collisionSys_Update::
	_ent_array_ptr = .+ 2 			;; |
	ld 	ix, #0x0000 			;; |
	ld 	de, #sizeof_e			;; Next entity
	add 	ix, de 				;; Recover other entities less player



	_player_pointer = .+ 2			;; |
	ld 	iy, #0x0000 			;; Recover Player entity

	_num_entities = .+1 			;; |
	ld 	h, #0 				;; Recover in H number of entities
	dec 	h					;; _ent_counter whithout player



	_update_loop:
		ld	a, e_life(ix)
		cp	#e_dead
		jr	z, _dead

		ld 	c, #0 			;; C = Collisions_Counter (4=Collision)

		;; Collision in X:
		call _ifEntityLeft 		;; Check if other entity is Left,  if not (C++)
		call _ifEntityRigth		;; Check if other entity is Right, if not (C++)

		;; Collision in Y:
		call _ifEntityUp 			;; Check Collition in Up Y (C++)
		call _ifEntityDown 		;; Check Collition in Down Y (C++)

		ld 	a, c 				;; |
		cp 	#4 				;; Check if is collision (3 is less down)
		jr	z,_collision		;; LED_ON
		push 	hl				;; Store H

		pop 	hl 				;; Restore H
		
		_dead:
		dec 	h 				;; _enti_counter--
		ret 	z 				;; if 0, breack loop
						
		ld  	de, #sizeof_e		;; else
		add 	ix, de 			;; next entity
		

	jr _update_loop
ret


	;; Collision
	_collision::
		ld	a, e_life(iy)
		cp	#e_powered_up
		jr	z, _powered_up

		ld 	a, #0
		ld 	e_life(ix), a 	;; entity dead
		
		;; erase sprite
		ld 	e, e_lst_vmeml(ix) 		;; |
		ld 	d, e_lst_vmemh(ix) 		;; Load last positon
		ld 	a, #0xF0				;; Negro
		ld 	c, e_sw(ix) 			;; Entity_Width
		ld 	b, e_sh(ix) 			;; Entity_Height
		call cpct_drawSolidBox_asm

		;; dec pacmans_alive
		ld	a, (pacmans_alive)
		dec	a
		ld	(pacmans_alive), a
		cp	#0
		push	af
		push	bc
		call	z, gameMan_incPunctuation
		pop	bc
		pop	af
		push	af
		push	bc
		call	z, renderSys_UpdateLevel
		pop	bc
		pop	af
		push	af
		call	z, renderSys_UpdatePunctuation
		pop	af
		jr	z, _finished_level
	ret

		_finished_level:
		call	gameMan_GetCurrentLevel
		ld	c, a
		ld	a, #_last_level
		cp	c
		call	z, gameMan_Win
		call	nz, gameMan_LevelCleared
	ret
		_powered_up:
		call	renderSys_UpdatePunctuation
		ld 	a, #0
		ld 	e_life(iy), a 	;; player dead
		call  gameMan_GameOver

	ret

	
	;; ||||||||||||  (IY = PLAYER)  ///  (IX = ENTITY)  ||||||||||||
	_ifEntityLeft:
		;; if (EntityA_X + Entity_A_W <= Player_X) collision_off
		;;  transform	(EntityA_X + Entity_A_W - Player_X <= 0) 
		ld 	a, e_x(ix)				;; 	EntityA_X
		add	e_w(ix) 				;; +	EntityA_W
		sub 	e_x(iy) 				;; -	wntityB_X
		ret 	z 		;; if(Resultado == 0) NOT COLLITION
		ret	m 		;; if(Resultado < 0) NOT COLLITION
		inc 	c			;; COLLISION
	ret


	_ifEntityRigth:
		;; IF (Player_X + Player_W <= EntityA_X) 
		;; Transform (Player_X + Player_W - EntityA_X <= 0)
		ld 	a, e_x(iy) 				;; 	Player_X
		add 	e_w(iy)				;; + 	Player_W
		sub 	e_x(ix)				;; -  EntityA_X
		ret 	z 		;; if(Resultado == 0) NOT COLLITION
		ret	m 		;; if(Resultado < 0) NOT COLLITION
		inc 	c 			;; COLLISION
	ret

	;; OVERFLOW ??????  WHEN PLAYER IS FULL UP
	_ifEntityUp:
		;; If(EntityA_Y >= Player_Y + Player_H) 
	    	;; Transform if(EntityA_Y - Player_Y + Player_H >= 0)
	    	ld 	a, e_y(iy) 				;; 	Player_Y
	    	add 	e_h(iy) 				;; +	Player_H
	    	ld 	b, a 					;; B
	    	ld 	a, e_y(ix) 				;;  	Entity_Y
	    	sub 	b 					;; -	B
	    	ret 	z 		;; if(Resultado == 0) NOT COLLITION
		ret	p 		;; if(Resultado < 0) NOT COLLITION
		inc 	c			;; COLLISION
	ret

	;; OVERFLOW ??????  WHEN PLAYER IS FULL DOWN
	_ifEntityDown:
		;; If(Player_Y >= EntityA_Y + EntityA_H) 
	    	;; Transform if(Player_Y - EntityA_Y + EntityA_H >= 0)
	    	ld 	a, e_y(ix) 				;; 	Player_Y
	    	add 	e_h(ix) 				;; +	Player_H
	    	ld 	b, a 					;; B
	    	ld 	a, e_y(iy) 				;;  	Entity_Y
	    	sub 	b 					;; -	B
	    	ret 	z 		;; if(Resultado == 0) NOT COLLITION
		ret	p 		;; if(Resultado < 0) NOT COLLITION
		inc 	c			;; COLLISION
	ret

;; #END (collisionSys_Update)





