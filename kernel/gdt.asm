; gdt.asm
global load_gdt
load_gdt:
    lgdt [esp+4]        ; Load GDT using address on the stack
    mov ax, 0x10        ; Data segment selector
    mov ds, ax          ; Load segment registers
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x08:.flush     ; Code segment selector
.flush:
    ret

