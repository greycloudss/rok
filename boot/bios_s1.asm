org 0x7C00
bits 16


%define STAGE2_SEG 0x0000
%define STAGE2_OFF 0x8000
%define STAGE2_LBA 1 
%define STAGE2_SECTORS 1


cli
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7000
sti
cld

mov si, _str
call printer

mov byte [dap.size], 0x10
mov byte [dap.resv], 0
mov word [dap.sectors], STAGE2_SECTORS
mov word [dap.dst_off], STAGE2_OFF
mov word [dap.dst_seg], STAGE2_SEG
mov dword [dap.lba_lo], STAGE2_LBA
mov dword [dap.lba_hi], 0

mov [boot_drive], dl
xor ax, ax
int 0x13

mov si, dap
mov dl, [boot_drive]
mov ah, 0x42
int 0x13
jnc .ok


mov ax,0x0000
mov es,ax
mov bx,0x8000
mov ah,0x02
mov al,1
mov ch,0
mov cl,2
mov dh,0
mov dl,[boot_drive]
int 13h
jc disk_fail


.ok:
	jmp STAGE2_SEG:STAGE2_OFF

disk_fail:
	mov si, _disk_fail
	call printer

.halt:
	hlt 
	jmp .halt

put_char:
	mov ah, 0x0E
	mov bx, 0x0007
	int 0x10
	ret

printer:
	lodsb
	test al, al
	jz .done
	call put_char
	jmp printer

.done:
	ret

dap:
	.size		db 0x10
	.resv		db 0 
	.sectors	dw 0 
	.dst_off	dw 0 
	.dst_seg	dw 0 
	.lba_lo		dd 0 
	.lba_hi		dd 0  


boot_drive db 0	

_str 		db "Hello, there", 13, 10, 0
_disk_fail 	db "[Error] disk init failed", 13, 10, 0

times 446-($-$$) db 0
db 0x80, 0, 1, 0,  0x0C, 0, 1, 0,  1, 0, 0, 0,  STAGE2_SECTORS, 0, 0, 0
times 510-($-$$) db 0
dw 0xAA55