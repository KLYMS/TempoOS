#define VIDEO_MEMORY 0xB8000
#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25

int cursor_row = 0;
int cursor_col = 0;

void print_char(char c, int row, int col, char color) {
    unsigned char *video_memory = (unsigned char*) VIDEO_MEMORY;
    int offset = (row * SCREEN_WIDTH + col) * 2;
    video_memory[offset] = c;
    video_memory[offset + 1] = color;
}

void print_string(const char *str, int row, int col, char color) {
    int i = 0;
    while (str[i] != '\0') {
        print_char(str[i], row, col + i, color);
        i++;
    }
}

void scroll_screen() {
    unsigned char *video_memory = (unsigned char*) VIDEO_MEMORY;

    // Move each line up
    for (int row = 1; row < SCREEN_HEIGHT; row++) {
        for (int col = 0; col < SCREEN_WIDTH; col++) {
            int dest_offset = ((row - 1) * SCREEN_WIDTH + col) * 2;
            int src_offset = (row * SCREEN_WIDTH + col) * 2;
            video_memory[dest_offset] = video_memory[src_offset];
            video_memory[dest_offset + 1] = video_memory[src_offset + 1];
        }
    }

    // Clear the last row
    for (int col = 0; col < SCREEN_WIDTH; col++) {
        int offset = ((SCREEN_HEIGHT - 1) * SCREEN_WIDTH + col) * 2;
        video_memory[offset] = ' ';
        video_memory[offset + 1] = 0x0F; // White text on black background
    }

    cursor_row = SCREEN_HEIGHT - 1;
    cursor_col = 0;
}

void print_char_with_cursor(char c, char color) {
    if (c == '\n') {
        cursor_row++;
        cursor_col = 0;
    } else {
        print_char(c, cursor_row, cursor_col, color);
        cursor_col++;
        if (cursor_col >= SCREEN_WIDTH) {
            cursor_col = 0;
            cursor_row++;
        }
    }

    if (cursor_row >= SCREEN_HEIGHT) {
        scroll_screen();
        cursor_row = SCREEN_HEIGHT - 1;
    }
}

void print_string_with_cursor(const char *str, char color) {
    int i = 0;
    while (str[i] != '\0') {
        print_char_with_cursor(str[i], color);
        i++;
    }
}
