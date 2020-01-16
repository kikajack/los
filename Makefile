
AS := as
CC := gcc
LD := ld

ASFLAGS += --32
CFLAGS += -Wall
CFLAGS += -O2
LDFLAGS += -m elf_i386
LDFLAGS += -Ttext 0x0


all: Image

Image: boot/bootsect.S
	$(AS) $(ASFLAGS) boot/bootsect.S -o boot/bootsect.o
	$(LD) $(LDFLAGS) boot/bootsect.o -o boot/bootsect.elf
	objcopy -O binary boot/bootsect.elf Image

.PHONY= clean
clean:
	rm -f boot/*.o boot/*.elf
	rm -f Image
