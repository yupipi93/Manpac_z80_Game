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
;; Animation Manager
;;
.include "assets/assets.h.s"
nullptr = 0x0000

;;######################
;;	PLAYER
;;######################
_player_walking_rigth::  	 
	.dw _player12_00
	.dw _player12_01
	.dw nullptr
	.dw _player_walking_rigth

_player_walking_left::  	 
	.dw _player12_02
	.dw _player12_03
	.dw nullptr
	.dw _player_walking_left

_player_walking_up::  	 
	.dw _player12_04
	.dw _player12_05
	.dw nullptr
	.dw _player_walking_up

_player_walking_down::  	 
	.dw _player12_06
	.dw _player12_07
	.dw nullptr
	.dw _player_walking_down


_player_super::  	 
	.dw _player12_08
	.dw _player12_09
	.dw _player12_10
	.dw _player12_11
	.dw nullptr
	.dw _player_super







;;######################
;;	PACMAN
;;######################

_pacman_walking_rigth::  	 
	.dw _pacman12_0
	.dw _pacman12_1
	.dw nullptr
	.dw _pacman_walking_rigth

_pacman_walking_left::  	 
	.dw _pacman12_2
	.dw _pacman12_3
	.dw nullptr
	.dw _pacman_walking_left

_pacman_walking_up::  	 
	.dw _pacman12_4
	.dw _pacman12_5
	.dw nullptr
	.dw _pacman_walking_up

_pacman_walking_down::  	 
	.dw _pacman12_6
	.dw _pacman12_7
	.dw nullptr
	.dw _pacman_walking_down