// kernel.c – kernel 64-bit
void kernel_main() {
    volatile char *video = (volatile char*)0xB8000;
    video[0] = 'H';
    video[1] = 0x07; // color gris
    video[2] = 'i';
    video[3] = 0x07;

    while (1) { } // bucle infinito
}

