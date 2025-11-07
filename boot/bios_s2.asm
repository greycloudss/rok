org 0x8000
bits 16

cld
push cs
pop ds


mov si, msg
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

msg db "General Kenobi", 13, 10, 0