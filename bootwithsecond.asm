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
	jz cargar
	mov [es:di], al
	inc di
	jmp short print

cargar:
OFFSET equ 0x1000 ; where to store boot loader binaries
	mov bx, OFFSET    ; set address to bx
	call disk_read    ; read our binaries and store by offset above
	call OFFSET       ; give execution to our loaded binaries
	jmp $


texto: db 'P',0x70,'i',0x70,'t',0x70,'u',0x70,'O',0x70,'S',0x70,' ',0x07,0


disk_read:
	;; store all register values
	pusha
	push dx

	;; prepare data for reading the disk
	;; al = number of sectors to read (1 - 128)
	;; ch = track/cylinder number
	;; dh = head number
	;; cl = sector number
	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov dh, 0x00
	mov cl, 0x02
	int 0x13

	;; in case of read error
	;; show the message about it
	jc disk_read_error

	;; check if we read expected count of sectors
	;; if not, show the message with error
	pop dx
	cmp dh, al
	jne disk_read_error

	;; restore register values and ret
	popa
	ret

disk_read_error:
	;mov bx, DISK_READ_ERROR_MSG
	;call print_string
	hlt


; ===============================
; Boot signature
; ===============================
times 510-($-$$) db 0
dw 0xAA55

