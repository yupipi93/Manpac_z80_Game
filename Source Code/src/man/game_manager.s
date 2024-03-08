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
;; GAME MANAGER
;;
.include "game_manager.h.s"
.include "sys/systems.h.s"
.include "entity_manager.h.s"
.include "assets/assets.h.s"
.include "animation_manager.h.s"

.module game_manager


;; Define Entities
DefineEntity player,  #_player12_00
DefineEntity enemy0,  #_pacman12_1
DefineEntity enemy1,  #_pacman12_1
DefineEntity enemy2,  #_pacman12_1
DefineEntity enemy3,  #_pacman12_1

;; Variables for game control
_current_level:			.db 0
_current_state: 			.db 0

;; Variables for render refresh control
_renders_to_update:		.db 5
_renders_left_to_update:	.db 1

;; Variables for punctuation
_digit_1: 		.db #48
_digit_2: 		.db #48
_digit_3: 		.db #48
_digit_4: 		.db #48

_current_digit_1: .db #48
_current_digit_2: .db #54
_current_digit_3: .db #49


gameMan_Init::
	call renderSys_ClearScreen
	;; Set the current state to start
	ld     a, #state_start
	ld   (_current_state), a

	call entityMan_GetEntityArray    ;; Get Array pointer and num_entities

	call inputSys_Init               ;; Load Array
	call renderSys_Init              ;; Load Array and num_entities and Set Palette

	call initializePoints

	call renderSys_UpdateStart

ret

gameMan_LevelCleared::
	call reDrawSys_Cocos
	call renderSys_LevelCleared
	ld	a, #state_levelCleared
	ld   (_current_state), a
ret
	
gameMan_Resume::
	ld	a, #state_game
	ld   (_current_state), a
ret

gameMan_Pause::
	call renderSys_UpdatePause
	ld	a, #state_pause
	ld   (_current_state), a
ret

gameMan_GameOver::
	;;call reDrawSys_Cocos
	call renderSys_UpdateGameOver
	ld     a, #state_gameOver
	ld   (_current_state), a
ret

gameMan_Win::
	call reDrawSys_Cocos
	call renderSys_UpdateWin
	ld     a, #state_win
	ld   (_current_state), a
ret

gameMan_StartLevel::
	ld	a, #state_game
	ld	(_current_state), a

	ld	a, #0
	call renderSys_SetTileMap
ret

gameMan_StartGame::
   	push 	af
   	call	entityMan_Init
	pop	af
	;; Setting the current level
   	ld	(_current_level),	a

	;;Create entities   
   	cp	a, #1
   	jp	z, _lvl_1
   	cp	a, #2
   	jp	z, _lvl_2
   	cp	a, #3
   	jp	z, _lvl_3
   	cp	a, #4
   	jp	z, _lvl_4
   	cp	a, #5
   	jp	z, _lvl_5
   	cp	a, #6
   	jp	z, _lvl_6
   	cp	a, #7
   	jp	z, _lvl_7
   	cp	a, #8
   	jp	z, _lvl_8
   	cp	a, #9
   	jp	z, _lvl_9
   	cp	a, #10
   	jp	z, _lvl_10
   	cp	a, #11
   	jp	z, _lvl_11
   	cp	a, #12
   	jp	z, _lvl_12


	_lvl_1:
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #7 * #8
		ld	c, #13 * #8
		ld	a, #6
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman


		jp	_entities_created

	_lvl_2:
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #7
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman


		jp	_entities_created

	_lvl_3:
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #8
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman


		jp	_entities_created


	_lvl_4:;;Patrol 2,3
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #2
		ld	de, #_pacman_walking_left
		call entityMan_CreatePacman
		
		ld	hl, #enemy1
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #3
		ld	de, #_pacman_walking_left
		call entityMan_CreatePacman


		jp	_entities_created

	_lvl_5:;;SIMETROIC
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #4
		ld	de, #_pacman_walking_left
		call entityMan_CreatePacman
		
		ld	hl, #enemy1
		ld	b, #10 * #8
		ld	c, #19 * #8
		ld	a, #5
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman
		
		jp	_entities_created

   	_lvl_6:
		call gameMan_CreatePlayer

		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #13 * #8
		ld	a, #0
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld	hl, #enemy1
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #1
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		jp	_entities_created

	_lvl_7:;;Fiest three pacmans
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #3 * #8
		ld	a, #9
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy1
		ld	b, #10 * #8
		ld	c, #3 * #8
		ld	a, #10
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy2
		ld	b, #2 * #8
		ld	c, #23 * #8
		ld	a, #11
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman


		jp	_entities_created


	_lvl_8:;;PATROL 2, 3 + 12
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #07 * #8
		ld	c, #13 * #8
		ld	a, #12
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy1
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #2
		ld	de, #_pacman_walking_left
		call entityMan_CreatePacman

		ld    hl, #enemy2
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #3
		ld	de, #_pacman_walking_left
		call entityMan_CreatePacman


		jp	_entities_created



	_lvl_9:
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #7 * #8
		ld	c, #9 * #8
		ld	a, #0xA0
		ld	de, #_pacman_walking_down
		call entityMan_CreatePacman

		ld    hl, #enemy1
		ld	b, #9 * #8
		ld	c, #13 * #8
		ld	a, #0
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy2
		ld	b, #7 * #8
		ld	c, #13 * #8
		ld	a, #6
		ld	de, #_pacman_walking_down
		call entityMan_CreatePacman

		ld    hl, #enemy3
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #3
		ld	de, #_pacman_walking_down
		call entityMan_CreatePacman

		jp	_entities_created



	_lvl_10:
		call gameMan_CreatePlayer
		
		ld    hl, #enemy0
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #13
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy1
		ld	b, #9 * #8
		ld	c, #19 * #8
		ld	a, #14
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy2
		ld	b, #9 * #8
		ld	c, #19* #8
		ld	a, #15
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		ld    hl, #enemy3
		ld	b, #9 * #8		;;X
		ld	c, #19 * #8 		;;Y
		ld	a, #16
		ld	de, #_pacman_walking_rigth
		call entityMan_CreatePacman

		jp	_entities_created

		;; LAST LEVEL STABLISHED HERE IN .h.s

	_lvl_11:
		;; Entities


		jp	_entities_created

	_lvl_12:
		;; Entities


	_entities_created:


	;; Set the current state to game
	ld     a, #state_start_game
	ld   (_current_state), a

	call initializeCurrentPoints
   
   	;; Initialite game systems
   	call entityMan_GetEntityArray    ;; Get Array pointer and num_entities
	call aiPlayerSys_Init            ;; Load Array and num_entities
	call aiSys_Init          	  ;; Load Array and num_entities
	;;call entityMan_Init              ;; NOTHING YET
	call physicsSys_Init             ;; Load Array and num_entities
	call animationSys_Init
	call collisionSys_Init           ;; Load Array and num_entities
	call reDrawSys_Init
	call tileSys_Reset_Map
ret

gameMan_CreatePlayer:
	ld    hl, #player
	ld	b, #8
	ld	c, #88
	ld	a, #0
	ld	de, #_player_walking_rigth
	call entityMan_Create
ret



gameMan_Update::
	ld   	a, (_current_state)
	cp	#state_start
	jr	z, _update_start_state

	cp   	#state_game
	jr	z, _update_game_state

	cp 	#state_win
	jr	z, _update_win

	cp 	#state_levelCleared
	jr	z, _update_levelCleared

	cp	#state_gameOver
	jr	z, _update_game_over

	cp	#state_pause
	jr	z, _update_pause
	
		
	ret

	_update_levelCleared:
		call inputSys_LevelCleared
	ret

	_update_pause:
		call inputSys_UpdatePause
	ret

	_update_game_over:
		call inputSys_UpdateGameOver
	ret

	_update_win:
		call inputSys_UpdateGameOver
	ret

	_update_start_state:
		call inputSys_UpdateStart
	ret

	_update_game_state:
	      call inputSys_UpdateGame
	      

	      
	      ld a, (_renders_left_to_update)
	      dec a
	      ld (_renders_left_to_update), a
	      cp #0
	      jr nz, _no_call_all
	      
	      _call_all:
	      	call aiPlayerSys_Update       ;; AI behaivor
	      	call aiSys_Update       	;; AI behaivor
	      	call physicsSys_Update        ;; Update entities position 
	      	call collisionSys_Update    	;; Check collisions
	      	call animationSys_Update 	;; Change animation
	      	
	      	ld a, (_renders_to_update)
	      	ld (_renders_left_to_update), a
	      
	      _no_call_all:

ret

	

;;#END (gameMan_Update)

gameMan_Render::
	ld   a, (_current_state)

	cp   #state_game
	jr   z, _render_game_state

	cp   #state_win
	jr   z, _render_win_state	

	cp	#state_start_game
	jr	z, _render_start_game
	ret
	
	_render_game_state:
		call reDrawSys_Cocos	;; Render Entities with reDraw cocos
	ret

	_render_start_game:
		call renderSys_UpdateStartGame
		call reDrawSys_Cocos
	ret

	_render_win_state:
		;;call renderSys_UpdateWin ;; Only for win animations purposes
ret

;; This function returns in c the first digit and in a the 
;; sencond digit of the current level. For render purposes
gameMan_GetLevel::
	ld	b, #0

	ld	a, (_current_level)
	
	cp	#10
	jr	z, _10_plus
	jp	p, _10_plus

	ld	c, #48
	add	#48
	ret

	_10_plus:
	sub	#10

	cp	#10
	jr	z, _20_plus
	jp	p, _20_plus

	add	#48
	ld	c, a
	ld	a, #49
	ret

	_20_plus:
	sub	#10
	add	#48
	ld	c, a
	ld	a, #50
ret

gameMan_GetCurrentLevel::
	ld	a, (_current_level)
ret

gameMan_getDigit1::
	ld a, (_digit_1)
ret

gameMan_getDigit2::
	ld a, (_digit_2)
ret

gameMan_getDigit3::
	ld a, (_digit_3)
ret

gameMan_getDigit4::
	ld a, (_digit_4)
ret

initializePoints:
	ld	a, #48
	ld	(_digit_1), a
	ld	(_digit_2), a
	ld	(_digit_3), a
	ld	(_digit_4), a
ret

initializeCurrentPoints:
	ld	a, #48
	ld	(_current_digit_1), a
	ld	a, #54
	ld	(_current_digit_2), a
	ld	a, #49
	ld	(_current_digit_3), a
ret

gameMan_decCurrentPunctuation::
	ld	a, (_current_digit_1)
	dec	a
	cp	#47
	jr	z, _digit_1_neg

	ld	(_current_digit_1), a
	ret

	_digit_1_neg:
	ld	a, #57
	ld	(_current_digit_1), a
	ld	a, (_current_digit_2)
	dec	a
	cp	#47
	jr	z, _digit_2_neg

	ld	(_current_digit_2), a
	ret

	_digit_2_neg:
	ld	a, #57
	ld	(_current_digit_2), a
	ld	a, (_current_digit_3)
	dec	a

	ld	(_current_digit_3), a
ret

gameMan_incPunctuation::
	;; Stablishing first digit and its carries
	ld	a, (_digit_1)
	ld	c, a
	ld	a, (_current_digit_1)
	add	c

	cp	#48 + #10 + #48
	jr	z, _digit_1_10_or_upper
	jp	p, _digit_1_10_or_upper

	ld	c, #48
	sub	c
	ld	(_digit_1), a
	jr	_digit_1_stablished

	_digit_1_10_or_upper:
	ld	c, #48 + #10
	sub	c
	ld	(_digit_1), a
	ld	a, (_digit_2)
	inc	a
	cp	#58
	jr	z, _digit_2_10

	ld	(_digit_2), a
	jr	_digit_1_stablished

	_digit_2_10:
	ld	a, #48
	ld	(_digit_2), a

	ld	a, (_digit_3)
	inc	a
	cp	#58
	jr	z, _digit_3_10

	ld	(_digit_3), a
	jr	_digit_1_stablished

	_digit_3_10:
	ld	a, #48
	ld	(_digit_3), a

	ld	a, (_digit_4)
	inc	a
	ld	(_digit_4), a

	jr	_digit_1_stablished

	_digit_1_stablished:




	;; Stablishing second digit and its carries
	ld	a, (_digit_2)
	ld	c, a
	ld	a, (_current_digit_2)
	add	c

	cp	#48 + #10 + #48
	jr	z, _digit_2_10_or_upper
	jp	p, _digit_2_10_or_upper

	ld	c, #48
	sub	c
	ld	(_digit_2), a
	jr	_digit_2_stablished

	_digit_2_10_or_upper:
	ld	c, #48 + #10
	sub	c
	ld	(_digit_2), a
	ld	a, (_digit_3)
	inc	a
	cp	#58
	jr	z, __digit_3_10

	ld	(_digit_3), a
	jr	_digit_2_stablished

	__digit_3_10:
	ld	a, #48
	ld	(_digit_3), a

	ld	a, (_digit_4)
	inc	a
	ld	(_digit_4), a

	jr	_digit_2_stablished

	_digit_2_stablished:




	;; Stablishing third digit and its carries
	ld	a, (_digit_3)
	ld	c, a
	ld	a, (_current_digit_3)
	add	c

	cp	#48 + #10 + #48
	jr	z, _digit_3_10_or_upper
	jp	p, _digit_3_10_or_upper

	ld	c, #48
	sub	c
	ld	(_digit_3), a
	jr	_digit_3_stablished

	_digit_3_10_or_upper:
	ld	c, #48 + #10
	sub	c
	ld	(_digit_3), a
	ld	a, (_digit_4)
	inc	a
	ld	(_digit_4), a

	_digit_3_stablished:
ret
