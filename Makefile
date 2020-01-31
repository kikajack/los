
AS := as
CC := gcc
LD := ld

ASFLAGS += --32
ASFLAGS += -g
CFLAGS += -Wall
CFLAGS += -O2
LDFLAGS += -m elf_i386
LDFLAGS += -Ttext 0x0


all: Image

Image: boot/bootsect boot/setup
	cp boot/bootsect.bin Image
	cat boot/setup.bin >> Image
#	dd if=/dev/zero of=Image bs=512 count=2
#	dd if=boot/bootsect.bin of=Image bs=512 count=1 conv=notrunc
#	dd if=boot/setup.bin of=Image seek=1 bs=512 conv=notrunc

boot/bootsect:
	$(AS) $(ASFLAGS) boot/bootsect.S -o boot/bootsect.o
	$(LD) $(LDFLAGS) boot/bootsect.o -o boot/bootsect.elf
	objcopy -O binary boot/bootsect.elf boot/bootsect.bin

boot/setup:
	$(AS) $(ASFLAGS) boot/setup.S -o boot/setup.o
	$(LD) $(LDFLAGS) boot/setup.o -o boot/setup.elf
	objcopy -O binary boot/setup.elf boot/setup.bin

.PHONY= clean
clean:
	rm -f boot/*.o boot/*.elf boot/*.bin
	rm -f Image

run:
	qemu-system-i386 -boot a -fda Image
#	qemu-system-i386 -drive file=./Image,format=raw
