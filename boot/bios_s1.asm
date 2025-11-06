org 0x7C00
bits 16


cli
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7C00
sti

mov si, _str
call print


._hang:
	hlt
	jmp ._hang


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

_str db 'Hello, there', 0

times 510-($-$$) db 0 
dw 0xAA55
