; boot.asm – bootloader mínimo
[BITS 16]
[ORG 0x7C00]

start:
    cli

mov ax, 0xB800   ; dirección del video memory
mov es, ax        ; cargar segmento en ES
xor di, di        ; offset 0 dentro de ES
mov al, 'P'       ; caracter
mov [es:di], al   ; escribir en pantalla
inc di
inc di
mov al, 'I'
mov [es:di], al
inc di
inc di
mov al, 'T'
mov [es:di], al
inc di
inc di
mov al, 'U'
mov [es:di], al


    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Copiar stage2 (512 bytes mínimo) a 0x1000
    mov si, stage2_source
    mov di, 0x1000
    mov cx, stage2_size
.copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop .copy_loop

    ; Saltar a stage2
    jmp 0x0000:0x1000

; ===============================
; Datos bootloader
; ===============================
stage2_source:
    ; Aquí se rellena con cat stage2.bin si quieres, o se deja como placeholder
    ; Para compilación independiente, se ignora

stage2_size equ 512

; ===============================
; Boot signature
; ===============================
times 510-($-$$) db 0
dw 0xAA55

