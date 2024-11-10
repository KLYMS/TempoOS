// heap.c
#include <stddef.h>
#include <stdint.h>

#define HEAP_START 0x1000000
#define HEAP_SIZE  0x100000

typedef struct block {
    size_t size;
    struct block *next;
    int free;
} block_t;

block_t *heap_start = (block_t *)HEAP_START;
block_t *free_list = NULL;

void init_heap() {
    free_list = heap_start;
    free_list->size = HEAP_SIZE - sizeof(block_t);
    free_list->next = NULL;
    free_list->free = 1;
}

void *malloc(size_t size) {
    block_t *current = free_list;
    while (current != NULL) {
        if (current->free && current->size >= size) {
            if (current->size > size + sizeof(block_t)) {
                block_t *new_block = (block_t *)((uint8_t *)current + sizeof(block_t) + size);
                new_block->size = current->size - size - sizeof(block_t);
                new_block->free = 1;
                new_block->next = current->next;
                current->next = new_block;
                current->size = size;
            }
            current->free = 0;
            return (void *)((uint8_t *)current + sizeof(block_t));
        }
        current = current->next;
    }
    return NULL;
}

void free(void *ptr) {
    if (!ptr) return;

    block_t *block = (block_t *)((uint8_t *)ptr - sizeof(block_t));
    block->free = 1;

    block_t *current = free_list;
    while (current != NULL) {
        if (current->free && current->next && current->next->free) {
            current->size += current->next->size + sizeof(block_t);
            current->next = current->next->next;
        }
        current = current->next;
    }
}

