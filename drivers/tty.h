#ifndef TTY_H
#define TTY_H

#include <stdint.h>
#include <stddef.h>

// VGA Constants
#define VGA_SCREEN_WIDTH 80
#define VGA_SCREEN_HEIGTH 25
#define VIDEO_MEMORY 0xB8000  

// VGA Color Enumerations
enum VGA_COLOR {
    BLACK = 0,
    BLUE = 1,
    GREEN = 2,
    CYAN = 3,
    RED = 4,
    MAGENTA = 5,
    BROWN = 6,
    LIGHT_GRAY = 7,
    DARK_GRAY = 8,
    LIGHT_BLUE = 9,
    LIGHT_GREEN = 10,
    LIGHT_CYAN = 11,
    LIGHT_RED = 12,
    LIGHT_MAGENTA = 13,
    YELLOW = 14,
    WHITE = 15
};

// Global Variables (should be declared as extern)
extern size_t terminal_row;
extern size_t terminal_column;
extern uint8_t terminal_vcolor;
extern uint16_t* terminal_buffer;

// Function Prototypes
void disable_interrupts();
void enable_interrupts();
uint8_t terminal_color(enum VGA_COLOR fg, enum VGA_COLOR bg);
uint16_t terminal_make_char(char c, uint8_t colour);
void terminal_scroll();
size_t strlen(const char* str);
void terminal_setcolor(uint8_t color);
void terminal_putcharat(char c, uint8_t color, size_t x, size_t y);
void terminal_writechar(char c, uint8_t color);
void terminal_writestr(const char* data, size_t size, uint8_t color);
void terminal_initialize();

// Print Macros and Functions
#define _GET_MACRO(_1, _2, NAME, ...) NAME
#define print(...) _GET_MACRO(__VA_ARGS__, print2, print1)(__VA_ARGS__)
void print1(const char* msg);
void print2(const char* msg, uint8_t color);

#endif 
