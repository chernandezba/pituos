# PituOS

PituOS is just a simple Operating System Kernel to play with.

Don't take it seriously, it's just a hobby, nothing stable or mature or safe.

Try it at your own risk!!

----


Compile


x86_64-elf-gcc -ffreestanding -c kernel.c -o kernel.o -O2 -Wall
x86_64-elf-ld -Ttext 0x2000 -o kernel.bin kernel.o --oformat binary


nasm -f bin boot.asm -o boot.bin
nasm -f bin stage2.asm -o stage2.bin


cat boot.bin stage2.bin kernel.bin > os.img

- Run on qemu:

qemu-system-x86_64 -drive format=raw,file=os.img
o
qemu-system-x86_64 -kernel kernel.bin

- Run on Virtual Box

VBoxManage convertfromraw os.img os.vdi --format VDI

New machine:

Type: Other

Version: Other/Unknown (64-bit)

Memory: 64 MB or more

Select os.vdi as disk

Remove floppy from boot priority

Sytem - Processor - Enable PAE/NX (not really necessary but helps)

Acceleration: enable VT-x/AMD-V  (long mode needs real virtualization)

