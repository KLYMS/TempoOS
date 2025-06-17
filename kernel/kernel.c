#include <stdint.h>
#include <stddef.h>

//////////////////////////////////////////////   Implemerntation For the terminal use 
#include "../drivers/tty.h"

size_t terminal_row =0;
size_t terminal_column =0;
uint8_t terminal_vcolor;
uint16_t* terminal_buffer = (uint16_t*)(0xB8000);

void disable_interrupts() { asm volatile("cli"); }

void enable_interrupts(){ asm volatile("sti"); }

uint8_t terminal_color(enum VGA_COLOR fg, enum VGA_COLOR bg){
  
  return (bg << 4) | (fg & 0x0F);
}

uint16_t terminal_make_char(char c, uint8_t colour){

  return (colour << 8) | c;
}

void terminal_scroll(){

  for(size_t y=0; y<VGA_SCREEN_HEIGTH; y++){
    for(size_t x=0; x<VGA_SCREEN_WIDTH; x++){
      size_t index_current = (y*VGA_SCREEN_WIDTH) + x;
      size_t index_previous = ((y-1)*VGA_SCREEN_WIDTH) + x;
      terminal_buffer[index_previous] = terminal_buffer[index_current];
    }
  }
  for (size_t x = 0; x < VGA_SCREEN_WIDTH; x++) {
    size_t last_rowindex = (VGA_SCREEN_HEIGTH - 1) * VGA_SCREEN_WIDTH + x;
    terminal_buffer[last_rowindex] =terminal_make_char(' ', terminal_vcolor);
  }
  terminal_row = VGA_SCREEN_HEIGTH - 1;
}

size_t strlen(const char* str){
  size_t len = 0;
  while(str[len]){
    len++;
  }
  return len;
}

void terminal_setcolor(uint8_t color){
  terminal_vcolor = color;
}

void terminal_putcharat(char c, uint8_t color, size_t x, size_t y){
  if (x >= VGA_SCREEN_WIDTH || y >= VGA_SCREEN_HEIGTH) {
    return; // Ignore invalid coordinates
  }
  size_t index = (y * VGA_SCREEN_WIDTH) + x;
  terminal_buffer[index] = terminal_make_char(c, color);
} 

void terminal_writechar(char c, uint8_t color){

  if(c == '\n'){
    terminal_row++;
    terminal_column = 0;
    if (terminal_row == VGA_SCREEN_HEIGTH) {
      terminal_scroll();
    }
    return;
  }
  
  if(c == '\t'){
    size_t spaces_to_next_tab = 4 - (terminal_column % 4);
    terminal_column += spaces_to_next_tab;
    if (terminal_column >= VGA_SCREEN_WIDTH) {
      terminal_column = 0;
      terminal_row++;
      if (terminal_row == VGA_SCREEN_HEIGTH) {
        terminal_scroll();
      }
    }
    return;
  }
  terminal_putcharat(c, color, terminal_column, terminal_row);

  if(++terminal_column == VGA_SCREEN_WIDTH){
    terminal_column = 0;
    if(++terminal_row == VGA_SCREEN_HEIGTH){
      /* terminal_row=0; */
      terminal_scroll();
    }
  }
}

void terminal_writestr(const char* data, size_t size, uint8_t color){
  for(size_t x=0; x<size; x++){
    terminal_writechar(data[x], color);
  }
}

void terminal_initialize(){
  terminal_row = 0;
  terminal_column = 0;
  terminal_vcolor = terminal_color(GREEN, BLACK);
  for(size_t y=0; y<VGA_SCREEN_HEIGTH; y++){
    for(size_t x=0; x<VGA_SCREEN_WIDTH; x++){
      terminal_putcharat(' ', terminal_vcolor, x,y);
    }
  }
}

void print1(const char* msg){
  print2(msg, terminal_vcolor);
}

void print2(const char* msg, uint8_t color){
  size_t len = strlen(msg);
  terminal_writestr(msg, len, color);
}
////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////// IDT Implementation




////////////////////////////////////////////////////////////////////////

void main() {
  terminal_initialize();
  char* msg = "Hii,....";
  print(msg);
}

