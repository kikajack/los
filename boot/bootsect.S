.code16
.global _start

.equ BOOTSEG, 0x07c0
/*ljmp $BOOTSEG, $_start*/
jmp _start
nop

/*FAT12 Start*/
.ascii "MSWIN4.1"
.word 0x0200
.byte 0x1
.word 0x1
.byte 0x2
.word 0xe0
.word 0x0b40
.byte 0xf0
.word 0x9
.word 0x12
.word 0x02
.word 0
.word 0
.word 0
.word 0
.byte 0
.byte 0
.byte 0x29
.word 0
.word 0
.ascii "hello world"
.ascii "FAT12   "
/*FAT12 End*/

_start:
	mov $0x03, %ah
	int $0x10
	mov $BOOTSEG, %ax
	mov %ax, %es
	mov $_string, %bp
	mov $0x1301, %ax
	mov $0x0007, %bx
	mov $9, %cx
	int $0x10
loop:
	jmp loop

_string:
	.ascii "hello los"

.=510

signature:
	.word 0xaa55
