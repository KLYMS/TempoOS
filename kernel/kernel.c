void main() {
    // Pointer to the start of video memory
    char* video_memory = (char*) 0xb8000;

    char* message = "Yamete...haa..haaa..hmm..haaaa...Yameeeteee Oniichannnn........";
    char attribute_byte = 0x0a;
    int i = 0;
    while (message[i] != '\0') {
        video_memory[i * 2] = message[i];
        video_memory[i * 2 + 1] = attribute_byte;
        i++;
    }
}


