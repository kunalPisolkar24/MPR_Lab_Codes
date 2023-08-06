; Write X86/64 ALP to perform multiplication of two 8-bit hexadecimal numbers. Use successive addition and add and shift method.

%macro IO 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    m1 db "Enter x : "
    l1 equ $ - m1
    
    m2 db 10,"Enter y: "
    l2 equ $ - m2

    res db 10, 10, "Result : "
    l3 equ $ - res

    blanks db 10," ", 10
    bla equ $ - blanks

section .bss
    numascii resb 03
    num1 resb 02
    num2 resb 02
    result resb 01
    dispbuff resb 04

section .text
    global _start
    _start:
        IO 1, 1, m1, l1
        IO 0, 0, numascii, 3

        call fetchInput
        mov byte[num1], bl

        IO 1, 1, m2, l2
        IO 0, 0, numascii, 3

        call fetchInput
        mov byte[num2], bl

        call shiftAdd ; Change this to switch

        IO 1, 1,res, l3
        mov ebx, [result]
        call print

        IO 1, 1, blanks, bla

        call exit
    ret

    successiveAdd:
        mov cx, [num2]
        mov edx, 00h
        mov eax, [num1]

        addup:
            add edx, eax
            loop addup
        
        mov [result], edx

    ret

    shiftAdd:
        mov al, [num1]
        mov cl, 0
        mov edx, 0
        mov edx, 08h

        addup1: 
            rcr al, 01
            jnc next1
            mov bh, 00h
            shl bx, cl
            add [result], bx
            mov bl, [num2]
        next1:
                inc cl
                dec edx
        jnz addup1
    ret

    fetchInput:
        mov bl, 0
        mov ecx, 02
        mov esi, numascii

        again1:
            rol bl, 04
            mov al, [esi]
            cmp al, 39h
            jbe skip1
            sub al, 07h
        skip1:
            sub al, 30h
            add bl, al
            inc esi
            loop again1 
    ret

    print:
        mov ecx, 4
        mov edi, dispbuff
        again2:
            rol bx, 4
            mov al, bl
            and al, 0fh
            cmp al, 09h
            jbe skip2
            add al, 07h

            skip2:
                add al, 30h
                mov [edi], al
                inc edi
            loop again2
        IO 1, 1, dispbuff, 4
    ret

    exit:
        mov rax, 60
        mov rdi, 0
        syscall
    ret
    
; Output
;-------------------------------------
; Enter x : 05

; Enter y: 05


; Result : 0019