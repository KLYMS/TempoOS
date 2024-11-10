; paging.asm
global load_page_directory
global enable_paging

load_page_directory:
    mov eax, [esp+4]
    mov cr3, eax        ; Load page directory base address into CR3
    ret

enable_paging:
    mov eax, cr0
    or eax, 0x80000000  ; Set paging bit in CR0
    mov cr0, eax
    ret

