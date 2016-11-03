#http://wiki.osdev.org/Raspberry_Pi_Bare_Bones
armv7a-hardfloat-linux-gnueabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -c boot.S -o boot.o
armv7a-hardfloat-linux-gnueabi-gcc -mcpu=arm1176jzf-s -fpic -ffreestanding -std=gnu99 -c kernel.c -o kernel.o -O2 -Wall -Wextra
armv7a-hardfloat-linux-gnueabi-gcc -T linker.ld -o myos.elf -ffreestanding -O2 -nostdlib boot.o kernel.o
armv7a-hardfloat-linux-gnueabi-objcopy myos.elf -O binary myos.bin
echo qemu-system-arm -kernel kernel.elf -cpu arm1176 -m 256 -M raspi2 -serial stdio
