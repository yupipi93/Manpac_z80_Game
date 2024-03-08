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
;; System AI Control
;;

.include "man/entity_manager.h.s"
.include "man/game_manager.h.s"
.include "sys/tile_system.h.s"

.module ai_cystem_control

;; Verified
;; Used in level(s): 9
;; Starts on: x7, y9
_patrolA0_size:	.db #3
_patrolA0: 		.db #7,  #13	;; 0
			.db #12, #13	;; 1
			.db #12, #9		;; 2
			.db #7,  #9		;; 3

;; Verified
;; Used in level(s): -
;; Starts on: x12, y9
_patrolB0_size:	.db #3
_patrolB0: 		.db #12, #13	;; 0
			.db #7,  #13	;; 1
			.db #7,  #9		;; 2
			.db #12, #9		;; 3

;; Verified
;; Used in level(s): 6, 9
;; Starts on: x9 y13
_patrol0_size:	.db #54
_patrol0: 		.db #12, #13	;; 0
			.db #12, #11	;; 1
			.db #15, #11	;; 2
			.db #15, #1		;; 3
			.db #18, #1		;; 4
			.db #18, #7		;; 5
			.db #15, #7		;; 6
			.db #15, #4		;; 7
			.db #17, #4		;; 8
			.db #12, #4		;; 9
			.db #12, #1		;; 10
			.db #14, #1		;; 11
			.db #12, #1		;; 12
			.db #12, #6		;; 13
			.db #7,  #6		;; 14
			.db #7,  #3		;; 15
			.db #11, #3		;; 16
			.db #7,  #3		;; 17
			.db #7,  #1		;; 18
			.db #1,  #1		;; 19
			.db #1,  #7		;; 20
			.db #4,  #7		;; 21
			.db #4,  #2		;; 22
			.db #4,  #4		;; 23
			.db #6,  #4		;; 24
			.db #2,  #4		;; 25
			.db #4,  #4		;; 26
			.db #4,  #16	;; 27
			.db #8,  #16	;; 28
			.db #8,  #23	;; 29
			.db #2,  #23	;; 30
			.db #2,  #20	;; 31
			.db #5,  #20	;; 32
			.db #1,  #20	;; 33
			.db #1,  #15	;; 34
			.db #4,  #15	;; 35
			.db #4,  #16	;; 36
			.db #5,  #16	;; 37
			.db #5,  #19	;; 38
			.db #11, #19	;; 39
			.db #11, #23	;; 40
			.db #9,  #23	;; 41
			.db #17, #23	;; 42
			.db #17, #20	;; 43
			.db #14, #20	;; 44
			.db #14, #16	;; 45
			.db #11, #16	;; 46
			.db #11, #19	;; 47
			.db #14, #19	;; 48
			.db #14, #20	;; 49
			.db #18, #20	;; 50
			.db #18, #15	;; 51
			.db #15, #15	;; 52
			.db #15, #16	;; 53
			.db #15, #12	;; 54

;; Verified
;; Used in level(s): 6
;; Starts on: x9 y19
_patrol1_size:	.db #55
_patrol1:		.db #14, #19	;; 1
			.db #14, #20	;; 2
			.db #17, #20	;; 3
			.db #17, #23	;; 4
			.db #11, #23	;; 5
			.db #11, #19	;; 6
			.db #8,  #19	;; 7
			.db #8,  #23	;; 8
			.db #10, #23	;; 9
			.db #2,  #23	;; 10
			.db #2,  #20	;; 11
			.db #1,  #20	;; 12
			.db #1,  #15	;; 13
			.db #4,  #15	;; 14
			.db #4,  #7		;; 15
			.db #1,  #7		;; 16
			.db #1,  #1		;; 17
			.db #4,  #1		;; 18
			.db #4,  #7		;; 19
			.db #1,  #7		;; 20
			.db #1,  #4		;; 21
			.db #7,  #4		;; 22
			.db #7,  #1		;; 23
			.db #5,  #1		;; 24
			.db #7,  #1		;; 25
			.db #7,  #3		;; 26
			.db #12, #3		;; 27
			.db #12, #6		;; 28
			.db #7,  #6		;; 29
			.db #7,  #3		;; 30
			.db #12, #3		;; 31
			.db #12, #1		;; 32
			.db #18, #1		;; 33
			.db #18, #7		;; 34
			.db #15, #7		;; 35
			.db #15, #4		;; 36
			.db #17, #4		;; 37
			.db #13, #4		;; 38
			.db #15, #4		;; 39
			.db #15, #2		;; 40
			.db #15, #15	;; 41
			.db #18, #15	;; 42
			.db #18, #20	;; 43
			.db #14, #20	;; 44
			.db #14, #16	;; 45
			.db #15, #16	;; 46
			.db #11, #16	;; 47
			.db #11, #19	;; 48
			.db #5,  #19	;; 49
			.db #5,  #20	;; 50
			.db #3,  #20	;; 51
			.db #5,  #20	;; 52
			.db #5,  #16	;; 53
			.db #4,  #16	;; 54
			.db #8,  #16	;; 55
			.db #8,  #18	;; 56

;; Verified
;; Used in level(s): 4, 8
;; Starts on: x9, y19
_patrol2_size:	.db #73
_patrol2:		.db #8,  #19	;; 0
			.db #8,  #23	;; 1
			.db #17, #23	;; 2
			.db #17, #20	;; 3
			.db #18, #20	;; 4
			.db #18, #15	;; 5
			.db #15, #15	;; 6
			.db #15, #11	;; 7
			.db #18, #11	;; 8 TP_R
			.db #04, #11	;; 9
			.db #04, #07	;; 10
			.db #01, #07	;; 11
			.db #01, #04	;; 12
			.db #07, #04	;; 13
			.db #07, #06	;; 14
			.db #09, #06	;; 15
			.db #09, #09	;; 16
			.db #07, #09	;; 17
			.db #07, #16	;; 18
			.db #04, #16	;; 19
			.db #04, #15	;; 20
			.db #01, #15	;; 21
			.db #01, #20	;; 22
			.db #02, #20	;; 23
			.db #02, #23	;; 24
			.db #11, #23	;; 25
			.db #11, #19	;; 26
			.db #05, #19	;; 27
			.db #05, #16	;; 28
			.db #04, #16	;; 29
			.db #04, #11	;; 30
			.db #01, #11	;; 31
			.db #15, #11	;; 32
 			.db #15, #07	;; 33
 			.db #18, #07	;; 34
 			.db #18, #01	;; 35
 			.db #12, #01	;; 36
 			.db #12, #03	;; 37
 			.db #07, #03	;; 38
 			.db #07, #01	;; 39
 			.db #01, #01	;; 40
 			.db #01, #04	;; 41
 			.db #07, #04	;; 42
 			.db #07, #06	;; 43
 			.db #12, #06	;; 44
 			.db #12, #04	;; 45
 			.db #15, #04	;; 46
 			.db #15, #16	;; 47
  			.db #11, #16	;; 48
 			.db #11, #19	;; 49
 			.db #14, #19	;; 50
 			.db #14, #20	;; 51
 			.db #17, #20	;; 52
 			.db #17, #23	;; 53
 			.db #08, #23	;; 54
 			.db #08, #16	;; 55
 			.db #05, #16	;; 56
 			.db #05, #20	;; 57
 			.db #01, #20	;; 58
 			.db #01, #15	;; 59
 			.db #04, #15	;; 60
  			.db #04, #01	;; 61
 			.db #07, #01	;; 62
 			.db #07, #03	;; 63
 			.db #12, #03	;; 64
 			.db #12, #01	;; 65
 			.db #15, #01	;; 66
 			.db #15, #04	;; 67
 			.db #18, #04	;; 68
 			.db #18, #07	;; 69
 			.db #15, #07	;; 70
 			.db #15, #16	;; 71
 			.db #14, #16	;; 72
 			.db #14, #20	;; 73

;; Verified
;; Used in level(s): 4, 8, 9
;; Starts on: x9, y19
_patrol3_size:	.db #67
_patrol3:		.db #08, #19	;; 0
			.db #08, #23 	;; 1
			.db #17, #23 	;; 2
			.db #17, #20 	;; 3
			.db #14, #20 	;; 4
			.db #14, #16 	;; 5
			.db #15, #16 	;; 6
			.db #15, #07 	;; 7
			.db #18, #07 	;; 8
			.db #18, #01 	;; 9
			.db #15, #01 	;; 10
			.db #15, #04 	;; 11
			.db #12, #04 	;; 12
			.db #12, #03 	;; 13
			.db #07, #03 	;; 14
			.db #07, #01 	;; 15
			.db #04, #01 	;; 16
			.db #04, #11 	;; 17
			.db #07, #11 	;; 18
			.db #07, #13 	;; 19
			.db #12, #13 	;; 20
			.db #12, #16 	;; 21
			.db #11, #16 	;; 22
			.db #11, #23 	;; 23
			.db #02, #23 	;; 24
			.db #02, #20 	;; 25
			.db #01, #20 	;; 26
			.db #01, #15 	;; 27
			.db #04, #15 	;; 28
			.db #04, #11 	;; 29
			.db #01, #11 	;; 30
			.db #15, #11 	;; 31
			.db #15, #04 	;; 32
			.db #18, #04 	;; 33
			.db #18, #01 	;; 34
			.db #12, #01 	;; 35
			.db #12, #06 	;; 36
			.db #07, #06 	;; 37
			.db #07, #04 	;; 38
			.db #01, #04 	;; 39
			.db #01, #07 	;; 40
			.db #04, #07 	;; 41
			.db #04, #01 	;; 42
			.db #01, #01 	;; 43
			.db #01, #04 	;; 44
			.db #07, #04 	;; 45
			.db #07, #06 	;; 46
			.db #09, #06 	;; 47
			.db #09, #09 	;; 48
			.db #12, #09 	;; 49
			.db #12, #16 	;; 50
			.db #15, #16 	;; 51
			.db #15, #15 	;; 52
			.db #18, #15 	;; 53
			.db #18, #20 	;; 54
			.db #14, #20 	;; 55
			.db #14, #19 	;; 56
			.db #08, #19 	;; 57
			.db #08, #16 	;; 58
			.db #04, #16 	;; 59
			.db #04, #15 	;; 60
			.db #01, #15 	;; 61
			.db #01, #20 	;; 62
			.db #05, #20 	;; 63
			.db #05, #16 	;; 64
			.db #08, #16 	;; 65
			.db #08, #19 	;; 66
			.db #05, #19 	;; 67

;; Verified
;; Used in level(s): 5
;; Starts on: x9 y19
_patrol4_size:	.db #50
_patrol4: 		.db #5, #19		;; 0
			.db #5, #20		;; 1
			.db #1, #20		;; 2
			.db #1, #15		;; 3
			.db #4, #15		;; 4
			.db #4, #16		;; 5
			.db #5, #16		;; 6
			.db #5, #20		;; 7
			.db #2, #20		;; 8
			.db #2, #23		;; 9
			.db #11, #23	;; 10
			.db #11, #16	;; 11
			.db #15, #16	;; 12
			.db #15, #7		;; 13
			.db #18, #7		;; 14
			.db #18, #1		;; 15
			.db #15, #1		;; 16
			.db #15, #4		;; 17
			.db #18, #4		;; 18
			.db #12, #4		;; 19
			.db #12, #6		;; 20
			.db #7,  #6		;; 21
			.db #7,  #1		;; 22
			.db #4,  #1		;; 23
			.db #4,  #16	;; 24
			.db #8,  #16	;; 25
			.db #8,  #23	;; 26
			.db #17, #23	;; 27
			.db #17, #20	;; 28
			.db #14, #20	;; 29
			.db #14, #19	;; 30
			.db #12, #19	;; 31
			.db #14, #19	;; 32
			.db #14, #16	;; 33
			.db #15, #16	;; 34
			.db #15, #15	;; 35
			.db #18, #15	;; 36
			.db #18, #20	;; 37
			.db #18, #15	;; 38
			.db #15, #15	;; 39
			.db #15, #1		;; 40
			.db #12, #1		;; 41
			.db #12, #3		;; 42
			.db #7,  #3		;; 43
			.db #7,  #4		;; 44
			.db #1,  #4		;; 45
			.db #1,  #1		;; 46
			.db #4,  #1		;; 47
			.db #1,  #1		;; 48
			.db #1,  #7		;; 49
			.db #4,  #7		;; 50

;; Verified
;; Used in level(s): 5
;; Starts on: x10 y19
_patrol5_size:	.db #50
_patrol5: 		.db #14, #19	;; 0
			.db #14, #20	;; 1
			.db #18, #20	;; 2
			.db #18, #15	;; 3
			.db #15, #15	;; 4
			.db #15, #16	;; 5
			.db #14, #16	;; 6
			.db #14, #20	;; 7
			.db #17, #20	;; 8
			.db #17, #23	;; 9
			.db #8,  #23	;; 10
			.db #8,  #16	;; 11
			.db #4,  #16	;; 12
			.db #4,  #7		;; 13
			.db #1,  #7		;; 14
			.db #1,  #1		;; 15
			.db #4,  #1		;; 16
			.db #4,  #4		;; 17
			.db #1,  #4		;; 18
			.db #7,  #4		;; 19
			.db #7,  #3		;; 20
			.db #12, #3		;; 21
			.db #12, #1		;; 22
			.db #15, #1		;; 23
			.db #15, #16	;; 24
			.db #11, #16	;; 25
			.db #11, #23	;; 26
			.db #2,  #23	;; 27
			.db #2,  #20	;; 28
			.db #5,  #20	;; 29
			.db #5,  #19	;; 30
			.db #7,  #19	;; 31
			.db #5,  #19	;; 32
			.db #5,  #16	;; 33
			.db #4,  #16	;; 34
			.db #4,  #15	;; 35
			.db #1,  #15	;; 36
			.db #1,  #20	;; 37
			.db #1,  #15	;; 38
			.db #4,  #15	;; 39
			.db #4,  #1		;; 40
			.db #7,  #1		;; 41
			.db #7,  #6		;; 42
			.db #12, #6		;; 43
			.db #12, #4		;; 44
			.db #18, #4		;; 45
			.db #18, #1		;; 46
			.db #16, #1		;; 47
			.db #18, #1		;; 48
			.db #18, #7		;; 49
			.db #16, #7		;; 50

;; Verified
;; Used in level(s): 1, 9
;; Starts on: x7 y13
_patrol6_size:	.db #3
_patrol6: 		.db #7,  #9		;; 0
			.db #12, #9		;; 1
			.db #12, #13	;; 2
			.db #7,  #13	;; 3

;; Verified
;; Used in level(s): 2
;; Starts on: x9 y 19
_patrol7_size:	.db #11
_patrol7: 		.db #14, #19	;; 0
			.db #14, #16	;; 1
			.db #15, #16	;; 2
			.db #15, #4		;; 3
			.db #12, #4		;; 4
			.db #12, #6		;; 5
			.db #7,  #6		;; 6
			.db #7,  #4		;; 7
			.db #4,  #4		;; 8
			.db #4,  #16	;; 9
			.db #5,  #16	;; 10
			.db #5,  #19	;; 11

;; Verified
;; Used in level(s): 3
;; Starts on: x9 y19
_patrol8_size:	.db #56
_patrol8: 		.db #14, #19	;; 0
			.db #14, #16	;; 1
			.db #15, #16	;; 2
			.db #15, #15	;; 3
			.db #18, #15	;; 4
			.db #18, #20	;; 5
			.db #14, #20	;; 6
			.db #14, #16	;; 7
			.db #11, #16	;; 8
			.db #11, #23	;; 9
			.db #8,  #23	;; 10
			.db #8,  #16	;; 11
			.db #5,  #16	;; 12
			.db #5,  #19	;; 13
			.db #8,  #19	;; 14
			.db #5,  #19	;; 15
			.db #5,  #20	;; 16
			.db #1,  #20	;; 17
			.db #1,  #15	;; 18
			.db #4,  #15	;; 19
			.db #4,  #16	;; 20
			.db #5,  #16	;; 21
			.db #5,  #20	;; 22
			.db #2,  #20	;; 23
			.db #2,  #23	;; 24
			.db #17, #23	;; 25
			.db #17, #20	;; 26
			.db #18, #20	;; 27
			.db #18, #15	;; 28
			.db #15, #15	;; 29
			.db #15, #7		;; 30
			.db #18, #7		;; 31
			.db #18, #1		;; 32
			.db #12, #1		;; 33
			.db #12, #4		;; 34
			.db #17, #4		;; 35
			.db #15, #4		;; 36
			.db #15, #6		;; 37
			.db #15, #1		;; 38
			.db #12, #1		;; 39
			.db #12, #6		;; 40
			.db #7,  #6		;; 41
			.db #7,  #3		;; 42
			.db #11, #3		;; 43
			.db #7,  #3		;; 44
			.db #7,  #1		;; 45
			.db #1,  #1		;; 46
			.db #1,  #4		;; 47
			.db #6,  #4		;; 48
			.db #4,  #4		;; 49
			.db #4,  #2		;; 50
			.db #4,  #4		;; 51
			.db #1,  #4		;; 52
			.db #1,  #7		;; 53
			.db #4,  #7		;; 54
			.db #4,  #5		;; 55
			.db #4,  #14	;; 56

;; Verified
;; Used in level(s): 7
;; Starts on: x9 y3
_patrol9_size:	.db #63
_patrol9: 		.db #7,  #3		;; 0
			.db #7,  #1		;; 1
			.db #4,  #1		;; 2
			.db #4,  #7		;; 3
			.db #1,  #7		;; 4
			.db #1,  #1		;; 5
			.db #4,  #1		;; 6
			.db #4,  #4		;; 7
			.db #2,  #4		;; 8
			.db #7,  #4		;; 9
			.db #7,  #6		;; 10
			.db #12, #6		;; 11
			.db #12, #4		;; 12
			.db #15, #4		;; 13
			.db #15, #1		;; 14
			.db #12, #1		;; 15
			.db #12, #3		;; 16
			.db #10, #3		;; 17
			.db #12, #3		;; 18
			.db #12, #4		;; 19
			.db #18, #4		;; 20
			.db #18, #1		;; 21
			.db #15, #1		;; 22
			.db #15, #7		;; 23
			.db #18, #7		;; 24
			.db #18, #4		;; 25
			.db #15, #4		;; 26
			.db #15, #11	;; 27
			.db #18, #11	;; 28 TelePort
			.db #4,  #11	;; 29
			.db #4,  #7		;; 30
			.db #4,  #15	;; 31
			.db #1,  #15	;; 32
			.db #1,  #20	;; 33
			.db #2,  #20	;; 34
			.db #2,  #23	;; 35
			.db #11, #23	;; 36
			.db #11, #16	;; 37
			.db #15, #16	;; 38
			.db #15, #12	;; 39
			.db #15, #16	;; 40
			.db #14, #16	;; 41
			.db #14, #19	;; 42
			.db #12, #19	;; 43
			.db #14, #19	;; 44
			.db #14, #20	;; 45
			.db #18, #20	;; 46
			.db #18, #15	;; 47
			.db #15, #15	;; 48
			.db #15, #16	;; 49
			.db #14, #16	;; 50
			.db #14, #20	;; 51
			.db #15, #20	;; 52
			.db #17, #20	;; 53
			.db #17, #23	;; 54
			.db #8,  #23	;; 55
			.db #8,  #16	;; 56
			.db #4,  #16	;; 57
			.db #5,  #16	;; 58
			.db #5,  #20	;; 59
			.db #3,  #20	;; 60
			.db #5,  #20	;; 61
			.db #5,  #19	;; 62
			.db #7,  #19	;; 63

;; Verified
;; Used in level(s): 7
;; Starts on: x10 y 3
_patrol10_size:	.db #60
_patrol10: 		.db #12, #3		;; 0
			.db #12, #1		;; 1
			.db #15, #1		;; 2
			.db #15, #7		;; 3
			.db #18, #7		;; 4
			.db #18, #1		;; 5
			.db #15, #1		;; 6
			.db #15, #4		;; 7
			.db #17, #4		;; 8
			.db #12, #4		;; 9
			.db #12, #6		;; 10
			.db #7,  #6		;; 11
			.db #7,  #4		;; 12
			.db #4,  #4		;; 13
			.db #4,  #1		;; 14
			.db #7,  #1		;; 15
			.db #7,  #3		;; 16
			.db #9,  #3		;; 17
			.db #7,  #3		;; 18
			.db #7,  #4		;; 19
			.db #1,  #4		;; 20
			.db #1,  #1		;; 21
			.db #4,  #1		;; 22
			.db #4,  #7		;; 23
			.db #1,  #7		;; 24
			.db #1,  #4		;; 25
			.db #4,  #4		;; 26
			.db #4,  #11	;; 27
			.db #1,  #11	;; 28
			.db #15, #11	;; 29
			.db #15, #8		;; 30
			.db #15, #15	;; 31
			.db #18, #15	;; 32
			.db #18, #20	;; 33
			.db #14, #20	;; 34
			.db #14, #16	;; 35
			.db #15, #16	;; 36
			.db #11, #16	;; 37
			.db #11, #23	;; 38
			.db #8,  #23	;; 39
			.db #8,  #19	;; 40
			.db #5,  #19	;; 41
			.db #5,  #16	;; 42
			.db #8,  #16	;; 43
			.db #8,  #19	;; 44
			.db #5,  #19	;; 45
			.db #5,  #20	;; 46
			.db #1,  #20	;; 47
			.db #1,  #15	;; 48
			.db #4,  #15	;; 49
			.db #4,  #12	;; 50
			.db #4,  #16	;; 51
			.db #5,  #16	;; 52
			.db #5,  #20	;; 53
			.db #2,  #20	;; 54
			.db #2,  #23	;; 55
			.db #17, #23	;; 56
			.db #17, #20	;; 57
			.db #14, #20	;; 58
			.db #14, #19	;; 59
			.db #12, #19	;; 60

;; Verified
;; Used in level(s): 7
;; Starts on: x2 y23
_patrol11_size:	.db #60
_patrol11: 		.db #17, #23	;; 0
			.db #17, #20	;; 1
			.db #18, #20	;; 2
			.db #18, #15	;; 3
			.db #15, #15	;; 4
			.db #15, #11	;; 5
			.db #12, #11	;; 6
			.db #12, #16	;; 7
			.db #11, #16	;; 8
			.db #11, #23	;; 9
			.db #8,  #23	;; 10
			.db #8,  #16	;; 11
			.db #4,  #16	;; 12
			.db #4,  #12	;; 13
			.db #4,  #15	;; 14
			.db #1,  #15	;; 15
			.db #1,  #20	;; 16
			.db #2,  #20	;; 17
			.db #2,  #22	;; 18
			.db #2,  #20	;; 19
			.db #5,  #20	;; 20
			.db #5,  #17	;; 21
			.db #5,  #19	;; 22
			.db #14, #19	;; 23
			.db #14, #16	;; 24
			.db #13, #16	;; 25
			.db #15, #16	;; 26
			.db #14, #16	;; 27
			.db #14, #20	;; 28
			.db #16, #20	;; 29
			.db #18, #20	;; 30
			.db #18, #15	;; 31
			.db #15, #15	;; 32
			.db #15, #1		;; 33
			.db #18, #1		;; 34
			.db #18, #7		;; 35
			.db #15, #7		;; 36
			.db #15, #4		;; 37
			.db #17, #4		;; 38
			.db #12, #4		;; 39
			.db #12, #1		;; 40
			.db #15, #1		;; 41
			.db #15, #4		;; 42
			.db #12, #4		;; 43
			.db #12, #3		;; 44
			.db #7,  #3		;; 45
			.db #7,  #6		;; 46
			.db #12, #6		;; 47
			.db #12, #3		;; 48
			.db #7,  #3		;; 49
			.db #7,  #1		;; 50
			.db #1,  #1		;; 51
			.db #1,  #4		;; 52
			.db #6,  #4		;; 53
			.db #4,  #4		;; 54
			.db #4,  #2		;; 55
			.db #4,  #7		;; 56
			.db #1,  #7		;; 57
			.db #1,  #4		;; 58
			.db #4,  #4		;; 59
			.db #4,  #11	;; 60

;; Verified
;; Used in level(s): 8
;; Starts on: x7 y13
_patrol12_size:	.db #9
_patrol12:		.db #12, #13 	;; 0
			.db #12, #11 	;; 1
			.db #18, #11 	;; 2
			.db #07, #11 	;; 3
			.db #07, #09 	;; 4
			.db #12, #09 	;; 5
			.db #12, #11 	;; 6
			.db #18, #11 	;; 7
			.db #07, #11 	;; 8
			.db #07, #13 	;; 9

;; Verified
;; Used in level(s): 10
;; Starts on: x9 y19
_patrol13_size:	.db #75
_patrol13:		.db #08, #19	;; 0
			.db #08, #23	;; 1
			.db #02, #23	;; 2
			.db #02, #20	;; 3
			.db #01, #20	;; 4
			.db #01, #15	;; 5
			.db #04, #15	;; 6
			.db #04, #7 	;; 7
			.db #01, #7 	;; 8
			.db #01, #2 	;; 9
			.db #01, #1 	;; 10
			.db #04, #1 	;; 11
			.db #04, #3 	;; 12
			.db #04, #4 	;; 13
			.db #07, #4 	;; 14
			.db #07, #3 	;; 15
			.db #12, #3 	;; 16
			.db #12, #5 	;; 17
			.db #12, #4 	;; 18
			.db #15, #4 	;; 19
			.db #15, #1 	;; 20
			.db #18, #1 	;; 21
			.db #18, #4 	;; 22
			.db #15, #4 	;; 23
			.db #15, #1 	;; 24
			.db #12, #1 	;; 25
			.db #12, #3 	;; 26
			.db #12, #6 	;; 27
			.db #07, #6 	;; 28
			.db #07, #1 	;; 29
			.db #01, #1 	;; 30
			.db #04, #1 	;; 31
			.db #04, #16	;; 32
			.db #05, #16	;; 33			
			.db #05, #19	;; 34
			.db #08, #19	;; 35
			.db #05, #19	;; 36
			.db #05, #20	;; 37
			.db #02, #20	;; 38
			.db #02, #23	;; 39
			.db #11, #23	;; 40
			.db #17, #23	;; 41
			.db #17, #20	;; 42
			.db #16, #20	;; 43
			.db #16, #20	;; 44			
			.db #14, #20	;; 45
			.db #14, #16	;; 46
			.db #15, #16	;; 47
			.db #15, #15	;; 48
			.db #16, #15	;; 49
			.db #15, #15	;; 50
			.db #15, #16	;; 51
			.db #11, #16	;; 52
			.db #11, #19	;; 53
			.db #08, #19	;; 54
			.db #08, #16	;; 55
			.db #05, #16	;; 56			
			.db #05, #20	;; 57
			.db #02, #20	;; 58
			.db #02, #23	;; 59
			.db #11, #23	;; 60
			.db #11, #19	;; 61
			.db #14, #19	;; 62
			.db #14, #20	;; 63
			.db #18, #20	;; 64
			.db #18, #15	;; 65
			.db #15, #15	;; 66
			.db #15, #4 	;; 67
			.db #18, #4 	;; 68
			.db #18, #7 	;; 69
			.db #15, #7 	;; 70
			.db #15, #11	;; 71
			.db #18, #11	;; 72
			.db #04, #11	;; 73
			.db #04, #4 	;; 74
			.db #01, #4 	;; 75

;; Verified
;; Used in level(s): 10
;; Starts on: x9 y19
_patrol14_size:	.db #75
_patrol14:		.db #08, #19	;; 0
			.db #08, #23	;; 1
			.db #02, #23	;; 2
			.db #02, #20	;; 3
			.db #01, #20	;; 4
			.db #01, #15	;; 5
			.db #04, #15	;; 6
			.db #04, #7 	;; 7
			.db #01, #7 	;; 8
			.db #01, #2 	;; 9
			.db #01, #4 	;; 10
			.db #04, #4 	;; 11
			.db #04, #3 	;; 12
			.db #04, #4 	;; 13
			.db #07, #4 	;; 14
			.db #07, #6 	;; 15
			.db #12, #6 	;; 16
			.db #12, #5 	;; 17
			.db #12, #4 	;; 18
			.db #15, #4 	;; 19
			.db #15, #7 	;; 20
			.db #18, #7 	;; 21
			.db #18, #4 	;; 22
			.db #15, #4 	;; 23
			.db #15, #1 	;; 24
			.db #12, #1 	;; 25
			.db #12, #3 	;; 26
			.db #07, #3 	;; 27
			.db #07, #6 	;; 28
			.db #07, #1 	;; 29
			.db #01, #1 	;; 30
			.db #04, #1 	;; 31
			.db #04, #16	;; 32
			.db #05, #16	;; 33
			.db #08, #16	;; 34
			.db #08, #19	;; 35
			.db #05, #19	;; 36
			.db #05, #20	;; 37
			.db #02, #20	;; 38
			.db #02, #23	;; 39
			.db #11, #23	;; 40
			.db #11, #19	;; 41
			.db #14, #19	;; 42
			.db #14, #20	;; 43
			.db #16, #20	;; 44
			.db #18, #20	;; 45
			.db #18, #15	;; 46
			.db #16, #15	;; 47
			.db #15, #15	;; 48
			.db #15, #7 	;; 49
			.db #18, #7 	;; 50
			.db #18, #1 	;; 51
			.db #15, #1 	;; 52
			.db #15, #4 	;; 53
			.db #12, #4 	;; 54
			.db #12, #6 	;; 55
			.db #09, #6 	;; 56
			.db #09, #9 	;; 57
			.db #12, #9 	;; 58
			.db #12, #16	;; 59
			.db #11, #16	;; 60
			.db #11, #23	;; 61
			.db #17, #23	;; 62
			.db #17, #20	;; 63
			.db #14, #20	;; 64
			.db #14, #16	;; 65
			.db #15, #16	;; 66
			.db #15, #11	;; 67
			.db #12, #11	;; 68
			.db #12, #16	;; 69
			.db #13, #16	;; 71
			.db #14, #16	;; 72
			.db #14, #19	;; 73
			.db #05, #19	;; 74
			.db #05, #16	;; 75

;; Verified
;; Used in level(s): 10
;; Starts on: x9 y19
_patrol15_size:	.db #86
_patrol15:		.db #08, #19	;; 0
			.db #08, #23	;; 1
			.db #02, #23	;; 2
			.db #02, #20	;; 3
			.db #01, #20	;; 4
			.db #01, #19	;; 5
			.db #01, #20	;; 6
			.db #02, #20	;; 7
			.db #02, #23	;; 8
			.db #17, #23	;; 9
			.db #17, #20	;; 10
			.db #18, #20	;; 11
			.db #18, #19	;; 12
			.db #18, #20	;; 13
			.db #14, #20	;; 14
			.db #14, #16	;; 15
			.db #14, #16	;; 16
			.db #11, #16	;; 17
			.db #11, #19	;; 18
			.db #11, #23	;; 19
			.db #08, #23	;; 20
			.db #08, #16	;; 21
			.db #07, #16	;; 22
			.db #07, #13	;; 23
			.db #07, #9 	;; 24
			.db #12, #9 	;; 25
			.db #12, #11	;; 26
			.db #15, #11	;; 27
			.db #15, #7 	;; 28
			.db #18, #7 	;; 29
			.db #18, #1 	;; 30
			.db #15, #1 	;; 31
			.db #15, #4 	;; 32
			.db #12, #4 	;; 33
			.db #12, #3 	;; 34
			.db #07, #3 	;; 35
			.db #07, #5 	;; 36
			.db #07, #4 	;; 37
			.db #01, #4 	;; 38
			.db #01, #1 	;; 39
			.db #04, #1 	;; 40
			.db #04, #15	;; 41
			.db #01, #15	;; 42
			.db #01, #15	;; 43
			.db #01, #20	;; 44
			.db #02, #20	;; 45
			.db #02, #23	;; 46
			.db #17, #23	;; 47
			.db #17, #20	;; 48
			.db #18, #20	;; 49
			.db #18, #15	;; 50
			.db #15, #15	;; 51
			.db #15, #11	;; 52
			.db #18, #11	;; 53
			.db #04, #11	;; 54
			.db #04, #16	;; 55
			.db #08, #16	;; 56
			.db #08, #19	;; 57
			.db #05, #19	;; 58
			.db #05, #20	;; 59
			.db #02, #20	;; 60
			.db #02, #23	;; 61
			.db #17, #23	;; 62
			.db #17, #20	;; 63
			.db #18, #20	;; 64
			.db #18, #15	;; 65
			.db #15, #15	;; 66
			.db #15, #16	;; 67
			.db #14, #16	;; 68
			.db #14, #19	;; 69
			.db #09, #19	;; 70
			.db #05, #19	;; 71
			.db #05, #16	;; 72
			.db #04, #16	;; 73
			.db #04, #7 	;; 74
			.db #01, #7 	;; 75
			.db #01, #1 	;; 76
			.db #07, #1 	;; 77
			.db #07, #6 	;; 78
			.db #12, #6 	;; 79
			.db #12, #1 	;; 80
			.db #15, #1 	;; 81
			.db #15, #4 	;; 82
			.db #18, #4 	;; 83
			.db #18, #7 	;; 84
			.db #15, #7 	;; 85
			.db #15, #5 	;; 86

;; Verified
;; Used in level(s): 10
;; Starts on: x9 y19 
_patrol16_size:	.db #84
_patrol16:		.db #08, #19	;; 0
			.db #08, #23	;; 1
			.db #02, #23	;; 2
			.db #02, #20	;; 3
			.db #01, #20	;; 4
			.db #01, #19	;; 5
			.db #01, #20	;; 6
			.db #02, #20	;; 7
			.db #02, #23	;; 8
			.db #17, #23	;; 9
			.db #17, #20	;; 10
			.db #18, #20	;; 11
			.db #18, #19	;; 12
			.db #18, #15	;; 13
			.db #15, #15	;; 14
			.db #15, #16	;; 15
			.db #14, #16	;; 16
			.db #14, #19	;; 17
			.db #11, #19	;; 18
			.db #11, #23	;; 19
			.db #08, #23	;; 20
			.db #08, #16	;; 21
			.db #07, #16	;; 22
			.db #07, #13	;; 23
			.db #12, #13	;; 24
			.db #12, #9 	;; 25
			.db #12, #11	;; 26
			.db #15, #11	;; 27
			.db #15, #4 	;; 28
			.db #18, #4 	;; 29
			.db #18, #1 	;; 30
			.db #15, #1 	;; 31
			.db #12, #1 	;; 32
			.db #12, #4 	;; 33
			.db #12, #6 	;; 34
			.db #07, #6 	;; 35
			.db #07, #5 	;; 36
			.db #07, #4 	;; 37
			.db #01, #4 	;; 38
			.db #01, #1 	;; 39
			.db #04, #1 	;; 40
			.db #04, #15	;; 41
			.db #04, #16	;; 42			
			.db #05, #16	;; 43
			.db #05, #20	;; 44
			.db #02, #20	;; 45
			.db #02, #23	;; 46
			.db #17, #23	;; 47
			.db #17, #20	;; 48
			.db #18, #20	;; 49
			.db #18, #15	;; 50
			.db #15, #15	;; 51
			.db #15, #11	;; 52
			.db #18, #11	;; 53
			.db #04, #11	;; 54
			.db #04, #7 	;; 55
			.db #01, #7 	;; 56
			.db #01, #4 	;; 57
			.db #04, #4 	;; 58
			.db #04, #1 	;; 59
			.db #07, #1 	;; 60
			.db #07, #3 	;; 61
			.db #12, #3 	;; 62
			.db #12, #4 	;; 63
			.db #15, #4 	;; 64
			.db #15, #1 	;; 65
			.db #18, #1 	;; 66
			.db #18, #7 	;; 67
			.db #15, #7 	;; 68
			.db #15, #16	;; 69
			.db #11, #16	;; 70
			.db #11, #19	;; 71
			.db #14, #19	;; 72
			.db #14, #20	;; 73
			.db #17, #20	;; 74
			.db #17, #23	;; 75
			.db #08, #23	;; 76
			.db #08, #16	;; 77
			.db #04, #16	;; 78
			.db #04, #15	;; 79
			.db #01, #15	;; 80
			.db #01, #20	;; 81
			.db #05, #20	;; 82
			.db #05, #19	;; 83
			.db #07, #19	;; 84


			
;; AI System Control INIT
;; Input: IX: pointer to entity array
;; 	     A: num entities
aiSys_Init::
	ld 	(_ent_array_ptr), 	ix 	;; Load pointer to entities array
	ld 	(_player_pointer), 	ix	;; Load Player entity
	ld 	(_num_entities), 		a 	;; Load num of entities

ret	



;; AI System Control UPDATE
;; Update All IAs Control
;; Destroys: A, IX
aiSys_Update::

	;; Restore entity array less first (player)
	_ent_array_ptr = .+ 2 			;; |
	ld 	ix, #0x0000 			;; |
	ld 	de, #sizeof_e			;; Next entity
	add 	ix, de 				;; Recover other entities less player

	_player_pointer = .+ 2			;; |
	ld 	iy, #0x0000 			;; Recover Player entity

	;; Restore num_entities less first (player)
	_num_entities = .+1 			;; |
	ld 	a, #0					;; Restore in A number of entities
	dec 	a					;; A--
	ld 	(_ent_counter), a 		;; _ent_counter whithout player




	;;Loop all entities less first
	_loop:
		ld	a, e_life(ix)
		cp	#e_dead
		jr	z, _dead

		ld 	a, e_ai_st(ix)		;; Load status

								;; Behavior AI Entities
		;;cp #e_ai_st_stand_by 		;; |
		;;call 	z, sys_ai_stand_by 	;; Stand By Behavior
		cp #e_ai_st_move_to 		;; |
		call 	z, aiSys_move_to 	;; Move To Behavior
		cp #e_ai_st_patrol 		;; |
		call 	z, aiSys_patrol	;; Move To Behavior

		ld	a, e_life(iy)
		cp	#e_powered_up
		jr	nz, _not_power_up

		_not_power_up:
		call eat_cocos
		call check_teleport

		_dead:

		_ent_counter = .+1 		;; |
		ld 	a, #0 			;; loda entity conter
		dec	a 				;; entity counte--
		ret 	z 				;; if (entity conter = 0) ... ret

		ld 	(_ent_counter), a 	;; else
		ld 	de, #sizeof_e 		;; |
		add 	ix, de 			;; Jump to next entity

	jr _loop 				;; repeat
ret

check_teleport:
	
	ld	a, e_cur_tile(ix)
	cp #0x0A
	jr z, _check_tp_left
	cp #0x0B
	jr nz, _end
	
	_check_tp_right:
		ld a, e_curr_dir(ix)
		cp #2
		jr z, _tp_right
		jr _end
	
	_check_tp_left:
		ld a, e_curr_dir(ix)
		cp #4
		jr z, _tp_left
		jr _end

	
		_tp_right:
			ld 	e_x(ix), #4

			ld 	l, e_cur_tile_al(ix)
			ld	h, e_cur_tile_ah(ix)

			ld	b, #0
			ld	c, #16

			sbc	hl, bc

			ld	a, (hl)
			
			jr _refresh_tile
			
		_tp_left:
			ld 	e_x(ix), #72

			ld 	l, e_cur_tile_al(ix)
			ld	h, e_cur_tile_ah(ix)

			ld	b, #0
			ld	c, #16

			add	hl, bc

			ld	a, (hl)

		_refresh_tile:
			and	#0x0F			
			ld	e_cur_tile_al(ix), l
			ld	e_cur_tile_ah(ix), h
			ld	e_cur_tile(ix), a

			ld	e_x_to_tile(ix), #4
			ld	e_y_to_tile(ix), #8
	_end:
ret

eat_cocos::
	ld	e, e_cur_tile_al(ix)
	ld	d, e_cur_tile_ah(ix)
	ld	a, (de)
	cp	#0x22
	jr	z, _eat_that_coco
	cp	#0x66
	jr	z, _eat_that_coco
	cp	#0x99
	jr	z, _eat_that_coco
	
	;; Super cocos
	cp	#0x33
	jr	z, _eat_that_supercoco
	cp	#0x77
	jr	z, _eat_that_supercoco
	jr	_end_dinner

	_eat_that_supercoco:
		;; set up the powerup
		ld	e_life(iy), #e_powered_up
		ld	e_power_left(iy), #e_power_max
	_eat_that_coco:
		and	#0xFC
		ld	(de), a
		ld	e_cur_tile(ix), a
		call  gameMan_decCurrentPunctuation
		call  tileSys_Sub_Coco
		call	tileSys_Get_Cocos
		cp	#0
		call  z, gameMan_GameOver

	_end_dinner:
ret

;; Move to State
;; Change velocity and change to stand by
;; Inputs: aim_x and aim_y
;; Destroys: A
aiSys_move_to::
	ld 	e_vy(ix), #0				;; Stop entity in Y

	ld	a, e_speed(ix)
	ld	b, a
	neg
	ld	c, a

	;;UPDATE X	
	ld 	a, e_ai_aim_x(ix) 			;; aim_x
	sub 	e_x(ix)					;; - 
	jr 	nc, _ojb_x_greather_or_equal 		;; e_x
	_obj_x_lesser:
	 	ld 	e_vx(ix), c			;; if (aim_x are lesser): e_vx = -1
	 	jr 	_endif_x	  			;; ...
	_ojb_x_greather_or_equal: 			
	 	jr 	z, _obj_x_arrived	 		;; if (aim_x equal e_x): x_arrived
	 	ld 	e_vx(ix), b			;; else (aim_x greater): e_vx = 1
	 	jr 	_endif_x 				;; ...
	_obj_x_arrived:
		ld 	e_vx(ix), #0 			;; if (x_arrived): e_vx = 0
	_endif_x:


	sla b
	sla c
	;;UPDATE Y
	ld 	a, e_ai_aim_y(ix) 		;; aim_y
	sub 	e_y(ix)				;; -
	jr 	nc, _ojb_y_greather_or_equal 	;; e_y
	_obj_y_lesser:
	 	ld 	e_vy(ix), c 			;; if(aim_x are lesser): e_vy = -2
	 	jr 	_endif_y 				;; ...
	_ojb_y_greather_or_equal:	
	 	jr 	z, _obj_y_arrived	   		;; if (aim_y equal e_y): y_arrived
	 	ld 	e_vy(ix), b 			;; else (aim_y greater): e_vy = 2
	 	jr 	_endif_y 				;; ...
	_obj_y_arrived: 				
		ld 	e_vy(ix), #0			;; if (x_arrived): e_vy = 0
		ld 	a, e_vx(ix) 			;; | 
		or 	a 					;; if (e_vx != 0): repeat all 
		jr 	nz, _endif_y 			;; else (both 0)

		ld 	e_ai_st(ix), #e_ai_st_patrol	;; change state = pre status
		
	_endif_y:


	ret



;;Patrol
;;???
;;Inputs: 
;;Destroys: 
aiSys_patrol::

	ld	a, e_ai_patrol(ix)
	cp	#0xA0
	jp	z, _set_patrolA0
	cp	#0xB0
	jp	z, _set_patrolB0
	cp	#0
	jp	z, _set_patrol0
	cp	#1
	jp	z, _set_patrol1
	cp	#2
	jp	z, _set_patrol2
	cp	#3
	jp	z, _set_patrol3
	cp	#4
	jp	z, _set_patrol4
	cp	#5
	jp	z, _set_patrol5
	cp	#6
	jp	z, _set_patrol6
	cp	#7
	jp	z, _set_patrol7
	cp	#8
	jp	z, _set_patrol8
	cp	#9
	jp	z, _set_patrol9
	cp	#10
	jp	z, _set_patrol10
	cp	#11
	jp	z, _set_patrol11
	cp	#12
	jp	z, _set_patrol12
	cp	#13
	jp	z, _set_patrol13
	cp	#14
	jp	z, _set_patrol14
	cp	#15
	jp	z, _set_patrol15
	cp	#16
	jp	z, _set_patrol16


	_set_patrol16:
	ld	hl,	#_patrol16
	ld	a, (_patrol16_size)
	push af

	jp 	_patrol_setted

	_set_patrol15:
	ld	hl,	#_patrol15
	ld	a, (_patrol15_size)
	push af

	jp 	_patrol_setted

	_set_patrol14:
	ld	hl,	#_patrol14
	ld	a, (_patrol14_size)
	push af

	jp 	_patrol_setted

	_set_patrol13:
	ld	hl,	#_patrol13
	ld	a, (_patrol13_size)
	push af

	jp 	_patrol_setted

	_set_patrol12:
	ld	hl,	#_patrol12
	ld	a, (_patrol12_size)
	push af

	jp 	_patrol_setted

	_set_patrol11:
	ld	hl,	#_patrol11
	ld	a, (_patrol11_size)
	push af

	jp 	_patrol_setted

	_set_patrol10:
	ld	hl,	#_patrol10
	ld	a, (_patrol10_size)
	push af

	jp 	_patrol_setted

	_set_patrol9:
	ld	hl,	#_patrol9
	ld	a, (_patrol9_size)
	push af

	jp 	_patrol_setted

	_set_patrol8:
	ld	hl,	#_patrol8
	ld	a, (_patrol8_size)
	push af

	jp 	_patrol_setted

	_set_patrol7:
	ld	hl,	#_patrol7
	ld	a, (_patrol7_size)
	push af

	jp 	_patrol_setted

	_set_patrol6:
	ld	hl,	#_patrol6
	ld	a, (_patrol6_size)
	push af

	jp 	_patrol_setted

	_set_patrol5:
	ld	hl,	#_patrol5
	ld	a, (_patrol5_size)
	push af

	jp 	_patrol_setted

	_set_patrol4:
	ld	hl,	#_patrol4
	ld	a, (_patrol4_size)
	push af

	jp 	_patrol_setted

	_set_patrol3:
	ld	hl,	#_patrol3
	ld	a, (_patrol3_size)
	push af

	jp 	_patrol_setted
	
	_set_patrol2:
	ld	hl,	#_patrol2
	ld	a, (_patrol2_size)
	push af

	jp 	_patrol_setted

	_set_patrol1:
	ld	hl,	#_patrol1
	ld	a, (_patrol1_size)
	push af

	jp 	_patrol_setted

	_set_patrol0:
	ld	hl,	#_patrol0
	ld	a, (_patrol0_size)
	push af

	jp 	_patrol_setted
	
	_set_patrolA0:
	ld	hl,	#_patrolA0
	ld	a, (_patrolA0_size)
	push af

	jp _patrol_setted

	_set_patrolB0:
	ld	hl,	#_patrolB0
	ld	a, (_patrolB0_size)
	push af

	_patrol_setted:

	
	ld 	a, e_ai_step(ix)
	sla	a

	ld	b, #0
	ld	c, a

	add 	hl, bc

	ld	b, (hl)
	sla	b
	sla	b

	ld	a, e_ai_aim_x(ix)
	cp	b
	jr	z, _no_change_x

	_change_x:
	ld	e_ai_aim_x(ix), b
	
	cp	#72
	jr	z, _check_y
	cp	#4
	jr	z, _check_y
	jr	_no_check_y

	_check_y:
	push	af
	ld	a, e_ai_aim_y(ix)
	cp	#88
	jr	z, _no_change
	pop	af

	_no_check_y:
	sub	b
	jp	m, _change_to_right

	_chage_to_left:
	ld	e_curr_dir(ix), #4
	jr	_no_change_x
	
	_change_to_right:
	ld	e_curr_dir(ix), #2
	jr	_no_change_x

	_no_change:
	pop	af
	_no_change_x:
	inc 	hl

	ld	b, (hl)
	sla	b
	sla	b
	sla	b

	ld	a, e_ai_aim_y(ix)
	cp	b
	jr	z, _no_change_y

	_change_y:
	ld	e_ai_aim_y(ix), b
	sub	b
	jp	m, _change_y_to_right

	_chage_y_to_left:
	ld	e_curr_dir(ix), #1
	jr	_no_change_y
	
	_change_y_to_right:
	ld	e_curr_dir(ix), #3
	
	_no_change_y:

	ld 	e_ai_st(ix), 	#e_ai_st_move_to
	
	pop	af
	cp	e_ai_step(ix)
	jr 	z, _no_inc

	_inc:
	inc	e_ai_step(ix)
	ret
	_no_inc:
	ld	e_ai_step(ix), #0

ret
