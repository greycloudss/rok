org 0x8000
bits 16



mov si, msg
call print

.halt
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
	jmp put_char
.done:
	ret

msg db "General Kenobi", 0
