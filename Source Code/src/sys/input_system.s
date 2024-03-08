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
;; Input System
;;

.include "render_system.h.s"
.include "man/entity_manager.h.s"
.include "man/game_manager.h.s"
.include "cpctelera.h.s"
.globl cpct_scanKeyboard_f_asm
.globl cpct_isKeyPressed_asm


;; Input System  INIT
;; Input: IX: pointer to entity array
inputSys_Init::
	;; Only update firts entity of array
	ld (_ent_array_ptr), ix 	;; Load pointer to entities array
	;;ld (_ent_counter), a 		;; Load num of entities
	ret


;; Input System UPDATE START
;; Update Keys pressed
;; Destroys: A, IX, HL, IX
inputSys_UpdateStart::
 	;;Scan Keyboard
	call cpct_scanKeyboard_f_asm 	;; Update keyboard state

	ld 	hl, #Key_Return	
	call cpct_isKeyPressed_asm 		;; Check key Return is pressed
	jr 	z, UpdateStart_Return_NotPressed 		;; Key Return is not pressed
	UpdateStart_Return_Pressed:
		;; Load Game
		ld	a, #1
		call 	gameMan_StartGame
	UpdateStart_Return_NotPressed:
ret

inputSys_LevelCleared::
	;;Scan Keyboard
	call cpct_scanKeyboard_f_asm 	;; Update keyboard state

	ld 	hl, #Key_Return	
	call cpct_isKeyPressed_asm 		;; Check key Return is pressed
	jr 	z, LevelCleared_Return_NotPressed 		;; Key Return is not pressed
	LevelCleared_Return_Pressed:
		;; Load next level
;;		call	gameMan_Init
		call	gameMan_GetCurrentLevel
		inc	a
		call	gameMan_StartGame
	LevelCleared_Return_NotPressed:
ret

inputSys_UpdatePause::
	;;Scan Keyboard
	call cpct_scanKeyboard_f_asm 	;; Update keyboard state

	ld 	hl, #Key_R	
	call cpct_isKeyPressed_asm 		;; Check key Return is pressed
	jr 	z, UpdateStart_R_NotPressed 		;; Key Return is not pressed
	UpdateStart_R_Pressed:
		call  renderSys_DeletePause
		;; Resume game
		call 	gameMan_Resume
	UpdateStart_R_NotPressed:

	ld 	hl, #Key_E	
	call cpct_isKeyPressed_asm 		;; Check key Return is pressed
	jr 	z, UpdateStart_E_NotPressed 		;; Key Return is not pressed
	UpdateStart_E_Pressed:
		;; Clear screen
		call	renderSys_ClearScreen
		;; Load Init
		call 	gameMan_Init
	UpdateStart_E_NotPressed:
ret

inputSys_UpdateGameOver::
	;;Scan Keyboard
	call cpct_scanKeyboard_f_asm 	;; Update keyboard state

	ld 	hl, #Key_R	
	call cpct_isKeyPressed_asm 		;; Check key R is pressed
	jr 	z, UpdateGameOver_R_NotPressed 		;; Key Return is not pressed
	UpdateGameOver_R_Pressed:
		;; Clear screen
		call	renderSys_ClearScreen
		;; Load Init
		call 	gameMan_Init
	UpdateGameOver_R_NotPressed:
ret

;; Input System UPDATE
;; Update Keys pressed
;; Destroys: A, IX, HL, IX
inputSys_UpdateGame::
	_ent_array_ptr = .+ 2 		;; |
	ld 	ix,#0x0000 			;; Load array pointer in ix
	

	;;Reset player volocities
	;;ld e_vx(ix), #0
	;;ld e_vy(ix), #0

	;;Scan Keyboard
	call cpct_scanKeyboard_f_asm 	;; Update keyboard state


	;;Check Key "A"
	ld 	hl, #Key_A 
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check key A is pressed
	jr 	nz, A_Pressed 		;; key A pressed
	
	;;Check Key "Joystic Left"
	;ld 	hl, #Joy1_Left 
	;;;DESTROY:A, D, BC, HL
	;call cpct_isKeyPressed_asm 	;; Check Joystick Left is pressed
	;jr 	nz, A_Pressed 		;; key Joystick Left pressed

	ld 	hl, #Joy0_Left 
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check Joystick Left is pressed
	jr 	z, A_NotPressed 		;; key Joystick Left not pressed
	
	A_Pressed:
		ld 	e_next_dir(ix), #4 	;; Set direction to left
	A_NotPressed:

	

	;;Check Key "D"
	ld 	hl, #Key_D	
	call cpct_isKeyPressed_asm 	;; Check key D is pressed
	jr 	nz, D_Pressed 		;; Key D is pressed
	
	;;Check Key "Joystic Right"
	;ld 	hl, #Joy1_Right 
	;;;DESTROY:A, D, BC, HL
	;call cpct_isKeyPressed_asm 	;; Check Joystick Right is pressed
	;jr 	nz, D_Pressed 		;; key Joystick Right pressed

	ld 	hl, #Joy0_Right 
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check Joystick Right is pressed
	jr 	z, D_NotPressed 		;; key Joystick Right not pressed
	

	D_Pressed:
		ld 	e_next_dir(ix), #2	;; Set direction to right
	D_NotPressed:



	;;Check Key "W"
	ld 	hl, #Key_W	
	call cpct_isKeyPressed_asm 	;; Check key W is pressed
	jr 	nz, W_Pressed 		;; Key W is pressed

	;;Check Key "Joystic Up"
	;ld 	hl, #Joy1_Up 
	;;;DESTROY:A, D, BC, HL
	;call cpct_isKeyPressed_asm 	;; Check Joystick Up is pressed
	;jr 	nz, W_Pressed 		;; key Joystick Up pressed

	ld 	hl, #Joy0_Up
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check Joystick Up is pressed
	jr 	z, W_NotPressed 		;; key Joystick Up not pressed

	W_Pressed:
		ld 	e_next_dir(ix), #1	;; Set direction to up
	W_NotPressed:



	;;Check Key "S"
	ld 	hl, #Key_S	
	call cpct_isKeyPressed_asm 	;; Check key S is pressed
	jr 	nz, S_Pressed 		;; Key S is pressed

	;;Check Key "Joystic Down"
	;ld 	hl, #Joy1_Down 
	;;;DESTROY:A, D, BC, HL
	;call cpct_isKeyPressed_asm 	;; Check Joystick Down is pressed
	;jr 	nz, S_Pressed 		;; key Joystick Down pressed
	
	ld 	hl, #Joy0_Down 
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check Joystick Down is pressed
	jr 	z, S_NotPressed 		;; key Joystick Down not pressed

	S_Pressed:
		ld 	e_next_dir(ix), #3	;; Set direction to down
	S_NotPressed:



	;;Check Key "P"
	ld 	hl, #Key_P	
	call  cpct_isKeyPressed_asm 	;; Check key S is pressed
	jr 	z, P_NotPressed 		;; Key S is pressed

	P_Pressed:
		call	gameMan_Pause
	P_NotPressed:



;;#########################
;; SWITCH DRAW METHOD
;;#########################

	;;Check Key "1" Braw Sprite
	ld 	hl, #Key_1 
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check key 1 is pressed
	jr 	z, Uno_NotPressed 	;; key 1 Not pressed

	ld 	a, #0
	call renderSys_SwitchDraw
	Uno_NotPressed:


	;;Check Key "2" Draw Box
	ld 	hl, #Key_2 
	;;DESTROY:A, D, BC, HL
	call cpct_isKeyPressed_asm 	;; Check key 2 is pressed
	jr 	z, Dos_NotPressed 	;; key 2 Not pressed

	ld 	a, #1
	call renderSys_SwitchDraw
	Dos_NotPressed:







ret