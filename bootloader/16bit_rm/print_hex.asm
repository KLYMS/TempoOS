; Receiving the data in 'dx'
print_hex_rm:
    pusha                    ; Save all general-purpose registers

    mov cx, 4                ; We will process 4 hex digits (for a 16-bit value)
    mov bx, HEX_OUT + 5      ; Load the base address of the output buffer

hex_loop:
    ; Convert the last character of 'dx' to ASCII
    mov ax, dx               ; Move the value in 'dx' to 'ax'
    and al, 0x0F             ; Isolate the last 4 bits (hex digit)

    ; Convert to ASCII: '0' (0x30) to '9' (0x39) and 'A' (0x41) to 'F' (0x46)
    add al, 0x30             ; Convert number to ASCII ('0' - '9')
    cmp al, 0x39             ; Check if it's greater than '9'
    jbe store_char           ; If less than or equal to '9', jump to store
    add al, 0x07             ; Adjust to 'A' (65) - ('9' + 1) (58), so 65 - 58 = 7

store_char:
    mov [bx], al             ; Store the ASCII character in the output buffer
    ror dx, 4                ; Rotate right 'dx' to process the next hex digit

    dec bx                   ; Move to the previous position in the buffer
    loop hex_loop            ; Repeat for all 4 hex digits

    ; Prepare the parameter and call the print function
    mov bx, HEX_OUT          ; Load the address of HEX_OUT into BX
    call print_string_rm     ; Call the print function to display the string

    popa                     ; Restore all general-purpose registers
    ret                      ; Return from the function

HEX_OUT:
    db '0x0000', 0          ; Reserve memory for our new string

