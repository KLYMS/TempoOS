print_string_rm:
    pusha

  print_string_rm_loop:
      mov al, [bx] ; 'bx' is the base address for the string
      cmp al, 0 
      je print_string_rm_done

      mov ah, 0x0e
      int 0x10

      add bx, 1
      jmp print_string_rm_loop

print_string_rm_done:
    popa
    ret

print_nl_rm:
    pusha
    
    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10
    jmp print_string_rm_done

