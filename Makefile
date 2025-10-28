ALL=simpleboot


simpleboot: simpleboot.asm
	nasm -f bin simpleboot.asm -o simpleboot.bin

runsimpleboot:
	qemu-system-x86_64 -drive format=raw,file=simpleboot.bin

