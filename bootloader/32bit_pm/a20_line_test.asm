[bits 32]
is_A20_on:

  pushad
  mov edi,0x112345  ;odd megabyte address.
  mov esi,0x012345  ;even megabyte address.
  mov [esi],esi     ;making sure that both addresses contain diffrent values.
  mov [edi],edi     ;(if A20 line is cleared the two pointers would point to the address 0x012345 that would contain 0x112345 (edi)) 
  cmpsd             ;compare addresses to see if the're equivalent.
  popad
  jne A20_on        ;if not equivalent , A20 line is set.
  ret               ;if equivalent , the A20 line is cleared.

A20_on:
  mov ebx, MSG_a20
  call Puts32
  ret

