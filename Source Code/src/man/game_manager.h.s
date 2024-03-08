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
.globl gameMan_Init
.globl gameMan_Update
.globl gameMan_Render
.globl gameMan_StartGame
.globl gameMan_GameOver
.globl gameMan_Win
.globl gameMan_Resume
.globl gameMan_Pause
.globl gameMan_GetCurrentLevel
.globl gameMan_LevelCleared
.globl gameMan_getDigit1
.globl gameMan_getDigit2
.globl gameMan_getDigit3
.globl gameMan_getDigit4
.globl gameMan_incPunctuation
.globl gameMan_decCurrentPunctuation
.globl gameMan_GetLevel
.globl gameMan_StartLevel

;; REPENSAR: Solo se va a llamar al physics, ia y
;;		 collision en state_game
state_game		= 0
state_start		= 1
state_pause		= 2
state_gameOver	= 3
state_levelCleared= 4
state_win		= 5
state_start_game  = 6

_last_level		= 10
