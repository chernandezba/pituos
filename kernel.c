#include <stdint.h>

static volatile uint16_t* const VGA = (uint16_t*)0xB8000;

void print(const char* s) {
    uint16_t* vga = (uint16_t*)VGA;
    uint16_t i = 0;
    while (s[i]) {
        vga[i] = (0x07 << 8) | s[i];
        i++;
    }
}

void kernel_main() {
    print("Hello from PituOS v0.001");
    for (;;) __asm__("hlt");
}

