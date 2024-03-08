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



.include "cpctelera.h.s"
.include "man/game_manager.h.s"
.globl cpct_disableFirmware_asm
.globl cpct_waitVSYNC_asm
.globl _my_song
.globl cpct_akp_musicInit_asm
.globl cpct_akp_musicPlay_asm
.globl cpct_setInterruptHandler_asm
.globl cpct_setPALColour_asm

.area _DATA
.area _CODE



musicCont:  .db 6

int_handler:
  push  af
  push  bc
  push  de
  push  hl


  ld    a, (musicCont)
  dec   a
  jr    nz, _cont

  _zero:
  call cpct_akp_musicPlay_asm
  ld    a, #6

  _cont:
  ld    (musicCont), a

  ;;ld    h, a
  ;;ld    l, #16
  ;;call  cpct_setPALColour_asm


  pop  hl
  pop  de
  pop  bc
  pop  af


  ei
  reti

set_int_handler:

  ld    hl, #0x38
  ld    (hl), #0xC3
  inc   hl
  ld    (hl), #<int_handler
  inc   hl
  ld    (hl), #>int_handler
  inc   hl
  ld    (hl), #0xC9

  ret

_main::
   ;;call cpct_disableFirmware_asm
   call set_int_handler
   call gameMan_Init 

   ;; Initialize music

   ld 	de, #_my_song
   call cpct_akp_musicInit_asm


   ;; Loop forever
  loop: 
      call gameMan_Update
      call cpct_waitVSYNC_asm
      call gameMan_Render
   jr    loop
