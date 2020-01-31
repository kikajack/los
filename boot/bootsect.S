.code16
.global _bootstart

.equ BOOTSEG, 0x07c0
.equ INITSEG, 0x07c0
.equ SETUPSEG, 0x07e0
.equ SETUPLEN, 0x4        # len
.equ SYSSEG, 0x1000
.equ SYSSIZE, 0x1000         # SYSSIZE * 16 is the os size, 0x1000 is 0x10000 bytes, 64kB 

ljmp $BOOTSEG, $_bootstart  # clean cache & jump

_bootstart:
    mov $0x03, %ah
    int $0x10                       # get current cursor position
    mov $BOOTSEG, %ax
    mov %ax, %es
    mov $_string, %bp
    mov $0x1301, %ax
    mov $0x0007, %bx
    mov $9, %cx
    int $0x10                       # show string

load_setup:
	mov	$0x0000, %dx	    # drive 0, head 0
	mov	$0x0002, %cx		# sector 2, track 0
	mov	$0x0200, %bx	    # address = 512, in INITSEG
	mov $0x02, %ah
	mov $1, %al
	int	$0x13			    # read it
	ljmp $SETUPSEG, $0
	jnc	load_os	        	# ok - continue
	mov	$0x0000, %dx
	mov	$0x0000, %ax	    # reset the diskette
	int	$0x13
	jmp	load_setup

load_os:
	mov	$0x0000, %dx	    # drive 0, head 0
	mov	$0x0002, %cx		# sector 2, track 0
	mov	$0x1000, %bx	    # address = 4096kB, in INITEG
	mov $SYSSIZE / 512, %ax
	add $0x0200, %ax    	# service 2, nr of sectors
	int	$0x13			    # read it
	jnc	ok_load_os   		# ok - continue
	mov	$0x0000, %dx
	mov	$0x0000, %ax	    # reset the diskette
	int	$0x13
	jmp	load_os

ok_load_os:
    ljmp $SETUPSEG, $0x0

_string:
    .ascii "hello los"

.=510

signature:
    .word 0xaa55
