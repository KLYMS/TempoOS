[org 0x7c00]
[bits 16]

KERNEL_OFFSET equ 0x1000  ; The same one we used when linking the kernel

mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp

mov bx, MSG_RM
call print_string_rm
call print_nl_rm

call load_kernel
call switch_to_pm ; switching to pm. we are never gonna return back here
jmp $   ; this will never be executed

load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string_rm
  call print_nl_rm

  mov bx, KERNEL_OFFSET
  mov dh, 15
  mov dl, [BOOT_DRIVE]
  call disk_load

  ; mov bx, MSG_LOAD_KERNEL_degbug 
  ; call print_string_rm
  ; call print_nl_rm

  ret


%include "16bit_rm/print.asm"
%include "16bit_rm/print_hex.asm"
%include "16bit_rm/disk.asm"
%include "gdt.asm"
%include "32bit_pm/print.asm"
%include "switch_pm.asm"
;;%include "32bit_pm/a20_line_test.asm"


[bits 32]


BEGIN_PM:
  mov ebx, MSG_PM
  call print_string_pm
  ;call is_A20_on          ; Testing A20 line is set or not
  call KERNEL_OFFSET
  jmp $

MSG_RM:
  db "Started in 16 bit real mode", 0

MSG_PM:
  db "Successfully landed in 32 bit protected mode", 0

; MSG_a20:
;    db "A20 line is set", 0

MSG_LOAD_KERNEL:
  db "Loading the kernel into memory...", 0

; MSG_LOAD_KERNEL_degbug:
;   db "Successfully Loaded kernel into memory", 0

BOOT_DRIVE:
   db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten

; bootsector
times 510-($-$$) db 0
dw 0xaa55

