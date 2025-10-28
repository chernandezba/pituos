all: simpleboot bootwithsecond


simpleboot: simpleboot.asm
	nasm -f bin simpleboot.asm -o simpleboot.bin

runsimpleboot:
	qemu-system-x86_64 -drive format=raw,file=simpleboot.bin

bootwithsecond: bootwithsecond.asm loader.asm loader.c
	nasm -f bin bootwithsecond.asm -o bootwithsecond.bin
	nasm loader.asm -f elf32 -o loader_entry.o
	gcc -fno-pie -O0 -g -ffreestanding -m32 -c loader.c -o loader.o
	ld -o loader.bin -m elf_i386 -Ttext 0x1000 loader_entry.o loader.o --oformat binary
	cat bootwithsecond.bin loader.bin > image.bin

runbootwithsecond:
	qemu-system-x86_64 -drive format=raw,file=image.bin
