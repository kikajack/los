.code16
.global _start

.equ INITSEG, 0x07c0
.equ SETUPSEG, 0x07e0
.equ SYSSEG, 0x1000

_start:
    mov $0x06, %ah /*clear screen*/
    mov $0, %al
    mov $0, %cx
    mov $2479, %dx
    mov $0x07, %bh
    int $0x10

    mov $0x03, %ah
    int $0x10                       # get current cursor position
    mov $SETUPSEG, %ax
    mov %ax, %es
    mov $msg1, %ax
	mov %ax, %bp
    mov $0x1301, %ax
    mov $0x0007, %bx
    mov $20, %cx
    int $0x10                       # show string
loop:
	jmp loop

msg1:
    .ascii "msg1 from setup.S"
