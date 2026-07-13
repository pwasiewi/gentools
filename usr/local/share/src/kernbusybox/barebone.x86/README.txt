#http://wiki.osdev.org/Bare_Bones
i686-none-linux-gnueabi-as boot.s -o boot.o
i686-none-linux-gnueabi-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
i686-none-linux-gnueabi-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

mkdir -p isodir/boot/grub
cp myos.bin isodir/boot/myos.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o myos.iso isodir

qemu-system-i386 -cdrom myos.iso
qemu-system-i386 -kernel myos.bin
