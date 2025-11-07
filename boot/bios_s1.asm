org 0x7C00
bits 16


%define STAGE2_seg 0x0000
%define STAGE2_OFF 0x8000
%define STAGE2_LBA 1 
%define STAGE2_SECTORS 16

cli
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00
sti

mov si, _str
call print
jmp execute


disk_fail:
	mov si, msg_fail
	call print
	jmp halt

halt:
	hlt 
	jmp halt

put_char:
	mov ah, 0x0E
	mov bx, 0x0007
	int 0x10
	ret

print:
	lodsb
	test al, al
	jz .done
	call put_char
	jmp print

.done:
	ret

execute:
	dap:
		.size		dw 0x0010
		.resv		dw 0 
		.sectors	dw 0 
		.dst_off	dw 0 
		.dst_seg	dw 0 
		.lba_lo		dd 0 
		.lba_hi		dd 0 

	boot_drive db 0

	mov [boot_drive], dl 

	mov word [dap.size], 0x0010 
	mov word [dap.sectors], STAGE2_SECTORS
	mov word [dap.dst_off], STAGE2_OFF
	mov word [dst_seg], STAGE2_seg
	mov word [dap.lba_lo], STAGE2_LBA
	mov word [dap.lba_hi], 0

	



_str 		db "Hello, there", 0
_disk_fail 	db "[Error] disk init failed", 0
times 510-($-$$) db 0 
dw 0xAA55
