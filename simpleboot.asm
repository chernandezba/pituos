[BITS 16]
[ORG 0x7C00]

start:
    	cli

	mov ax, 0xB800   ; dirección del video memory
	mov es, ax        ; cargar segmento en ES
	xor di, di        ; offset 0 dentro de ES

	mov si, texto

print:  lodsb
	or al,al
	jz nosalir
	mov [es:di], al
	inc di
	jmp short print

nosalir:	hlt
	jmp short nosalir

texto: db 'P',0x70,'i',0x70,'t',0x70,'u',0x70,'O',0x70,'S',0x70,' ',0x07,0


; ===============================
; Boot signature
; ===============================
times 510-($-$$) db 0
dw 0xAA55

