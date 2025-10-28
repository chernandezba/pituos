# PituOS

PituOS is just a simple Operating System Kernel to play with.

Don't take it seriously, it's just a hobby, nothing stable or mature or safe.

Try it at your own risk!!

----


Compile

nasm -f bin boot.asm -o boot.bin
x86_64-elf-gcc -ffreestanding -mno-red-zone -m64 -c kernel.c -o kernel.o
x86_64-elf-ld -Ttext 0x1000 -o kernel.bin kernel.o --oformat binary


cat boot.bin kernel.bin > os.img


- Run on qemu:

qemu-system-x86_64 -drive format=raw,file=os.img

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

