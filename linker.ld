ENTRY(_start)
SECTIONS
{
    . = 0x1000;               /* Kernel starts at address 0x1000 */
    .text : {
        *(.text)              /* Include all .text sections */
    }
    .data : {
        *(.data)              /* Include all .data sections */
    }
    .bss : {
        *(.bss)               /* Include all .bss sections */
    }
}
