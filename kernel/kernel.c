#include "../drivers/tty.c"



void main() {
    char *message = "Hello, from Protected Mode in kernel!";
    char color = 0x0A; // Light green text on black background
    print_string(message, 0, 0, color);
}
