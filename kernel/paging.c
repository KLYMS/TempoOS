// paging.c
#include <stdint.h>

#define PAGE_SIZE 4096
#define NUM_PAGES 1024

uint32_t page_directory[NUM_PAGES] __attribute__((aligned(PAGE_SIZE)));
uint32_t first_page_table[NUM_PAGES] __attribute__((aligned(PAGE_SIZE)));

void init_paging() {
    for (int i = 0; i < NUM_PAGES; i++) {
        first_page_table[i] = (i * PAGE_SIZE) | 3;  // Supervisor level, read/write, present
    }

    page_directory[0] = ((uint32_t)first_page_table) | 3;

    for (int i = 1; i < NUM_PAGES; i++) {
        page_directory[i] = 0 | 2;                  // Supervisor level, read/write, not present
    }

    load_page_directory(page_directory);
    enable_paging();
}

