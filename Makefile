all: simpleboot bootwithsecond

clean:
	rm -f *.bin *.o

simpleboot.bin: simpleboot.asm
	nasm -f bin simpleboot.asm -o simpleboot.bin

simpleboot: simpleboot.bin

runsimpleboot: simpleboot
	qemu-system-x86_64 -drive format=raw,file=simpleboot.bin


bootwithsecond.bin: bootwithsecond.asm
	nasm -f bin bootwithsecond.asm -o bootwithsecond.bin

loader_entry.o: loader.asm
	nasm loader.asm -f elf32 -o loader_entry.o

loader.o: loader.c
	gcc -fno-pie -O0 -g -ffreestanding -m32 -c loader.c -o loader.o

loader.bin: loader_entry.o loader.o
	ld -o loader.bin -m elf_i386 -Ttext 0x1000 loader_entry.o loader.o --oformat binary

image.bin: bootwithsecond.bin loader.bin
	cat bootwithsecond.bin loader.bin > image.bin

bootwithsecond: bootwithsecond.bin loader_entry.o loader.o loader.bin image.bin

runbootwithsecond: bootwithsecond
	qemu-system-x86_64 -drive format=raw,file=image.bin
