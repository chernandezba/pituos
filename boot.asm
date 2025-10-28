[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00

; ========================
; Habilitar línea A20
; ========================
EnableA20:
    in al, 0x92
    or al, 00000010b
    out 0x92, al

; ========================
; Configurar GDT
; ========================
gdt_start:
    dq 0x0000000000000000        ; Descriptor nulo
    dq 0x00CF9A000000FFFF        ; Código 32-bit
    dq 0x00CF92000000FFFF        ; Datos 32-bit
    dq 0x00209A0000000000        ; Código 64-bit
    dq 0x0000920000000000        ; Datos 64-bit
gdt_end:

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; ========================
; Entrar en modo protegido
; ========================
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:ProtectedMode

; ========================
; MODO PROTEGIDO (32-bit)
; ========================
[BITS 32]
ProtectedMode:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x90000

; ========================
; Configurar PAE y Long Mode
; ========================
    mov ecx, 0xC0000080   ; MSR EFER
    rdmsr
    or eax, (1 << 8)      ; bit LME
    wrmsr

    mov eax, cr4
    or eax, (1 << 5)      ; habilitar PAE
    mov cr4, eax

; ========================
; Configurar tablas de paginación mínimas
; ========================
    ; 1 GB identity map
    ;mov dword [PML4], PDPT | 0x3

mov eax, PDPT
or eax, 0x3
mov [PML4], eax

    ;mov dword [PDPT], PD | 0x3

mov eax, PD
or eax, 0x3
mov [PDPT], eax


    mov dword [PD], 0x00000083  ; 1GB page

    mov eax, PML4
    and eax, 0xFFFFF000   ; alinear a 4 KiB
    mov cr3, eax

; Activar paging + long mode
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

; Saltar a modo largo
    jmp 0x18:LongMode

; ========================
; Tablas de paginación
; ========================
;align 4096
PML4: dq 0
PDPT: dq 0
PD:   dq 0

; ========================
; MODO LARGO (64-bit)
; ========================
[BITS 64]
LongMode:
    mov ax, 0x20
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov rsp, 0x80000

    ; Llamar directamente al kernel en dirección fija
    call 0x0000000000001000   ; dirección del kernel

    ;extern kernel_main
    ;call kernel_main

hang:
    hlt
    jmp hang

times 510-($-$$) db 0
dw 0xAA55

