; Write X86/64 ALP to detect protected mode and display the values of GDTR, LDTR, IDTR, TR, and MSW Registers.

%macro IO 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    m1 db 10, 10, "GDTR Contents : ", 10
    l1 equ $ - m1

    m2 db "We are in protected mode :) ", 10
    l2 equ $ - m2

    m3 db "We aren't in protected mode :( ", 10
    l3 equ $ - m3

    m4 db 10, 10, "LDTR contents are : ", 10
    l4 equ $ - m4

    m5 db 10, 10, "IDTR contents are : ", 10
    l5 equ $ - m5

    m6 db 10, 10, "MSW contents are : ", 10
    l6 equ $ - m6

    m7 db 10, 10, "TR contents are : ", 10
    l7 equ $ - m7
    
    colon db " : "
    col equ $ - colon

    newLine db " ",10
    nl equ $ - newLine

section .bss
    gdt: resd 01 
        resw 01

    ldt: resw 01

    idt: resd 01
        resw 01

    msw: resw 01

    tr: resw 01

    result resw 01

section .text
    global _start
    _start:
        call protectedModeCheck

        call getGDT

        call getLDT

        call getIDT

        call getMSW

        call getTR

        IO 1, 1, newLine, nl 

        mov rax, 60
        mov rdi, 0
        syscall

    getGDT:
        sgdt[gdt]
        IO 1, 1, m1, l1

        mov bx, word[gdt + 4]
        call print
        mov bx, word[gdt + 2]
        call print

        IO 1, 1, colon, col
        mov bx, word[gdt]
        call print
    ret

    getLDT:
        sldt[ldt]
        IO 1, 1, m4, l4
        mov bx, word[ldt + 2]
        call print
        IO 1, 1, colon, col
        mov bx, word[ldt]
        call print
    ret

    getIDT:
        sidt[idt]
        IO 1, 1, m5, l5

        mov bx, word[idt + 4]
        call print

        mov bx, word[idt + 2]
        call print
        
        IO 1, 1, colon, col

        mov bx, word[idt]
        call print
    ret

    getMSW:
        smsw[msw]
        IO 1, 1, m6, l6
        mov bx, word[msw]
        call print
    ret

    getTR:
        str[tr]
        IO 1, 1, m7, l7
        mov bx, word[tr]
        call print
    ret

    protectedModeCheck:
        bt ax, 0
        jc next
        jnc next2 
        next:
            IO 1, 1, m2, l2
        next2:
            IO 1, 1, m3, l3
    ret

    print:
        mov rcx, 4
        mov rdi, result
        repeat:
            rol bx, 4
            mov al, bl
            and al, 0fh
            cmp al, 09h

            jg add37

            add al, 30h

            jmp skip

            add37:
                add al, 37h

            skip:
                mov [rdi], al
                inc rdi
                loop repeat

        IO 1, 1, result, 4
    ret
    
    ret

; Output 
; -----------------------------
; We aren't in protected mode :( 


; GDTR Contents : 
; 00077000 : 007F

; LDTR contents are : 
; FFFF : 0000

; IDTR contents are : 
; 00000000 : 0FFF

; MSW contents are : 
; 0033

; TR contents are : 
; 0040 
