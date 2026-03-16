org 0x0000
bits 16

start:
    ; print 'K' using BIOS
    mov ah, 0x0e
    mov al, 'K'
    int 0x10

.halt:
    hlt
    jmp .halt
