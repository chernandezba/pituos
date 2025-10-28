; stage2.asm – transición segura a 64-bit
[BITS 16]
[ORG 0x1000]

stage2_start:
    cli
    lgdt [gdt_descriptor]

    ; Activar modo protegido
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; Salto a 32-bit code segment
    jmp 0x08:protected_mode_entry

[BITS 32]
protected_mode_entry:

mov edi, 0xB8000   ; dirección del video memory

mov al,'p'
mov [edi], al
inc al
inc al

mov al,'i'
mov [edi], al
inc al
inc al

mov al,'t'
mov [edi], al
inc al
inc al

mov al,'u'
mov [edi], al
inc al
inc al


    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    ; Habilitar A20
    in al, 0x92
    or al, 0x02
    out 0x92, al

    ; Configurar paging 64-bit
    mov eax, 0x83
    mov [PD], eax

    mov eax, PD
    or eax, 0x3
    mov [PDPT], eax

    mov eax, PDPT
    or eax, 0x3
    mov [PML4], eax

    ; Activar PAE
    mov eax, cr4
    or eax, 0x20
    mov cr4, eax

    ; Activar long mode (LME)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x100
    wrmsr

    ; Cargar CR3
    mov eax, PML4
    mov cr3, eax

    ; Activar paging
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    mov eax, 0xB8000
    mov byte [eax],'X'

    ; Saltar a 64-bit
    jmp long_mode_entry

[BITS 64]
long_mode_entry:
    ; Saltar al kernel en 0x2000
    mov rax, 0x2000
    jmp rax

; ===============================
; GDT
; ===============================
[BITS 16]
gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; ===============================
; Tablas de página
; ===============================
[BITS 32]
align 4096
PML4:   resd 1
PDPT:   resd 1
PD:     resd 1

