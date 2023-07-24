;Write x86 ALP to find the factorial of a given integer number on a command line by
;using recursion. Explicit stack manipulation is expected in the code.

%macro IO 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg db " Factorial is -> ",
    l1 equ $ - msg

    endline db "", 10
    l2 equ $ - endline

    base db "0001"
    l3 equ $ - base

    input db 06D ; Change the number to take different input
section .bss
    dispbuff resb 16
    result resb 4
    num resb 1

section .text
    global _start
    _start:
        IO 1, 1, msg, l1
        mov al, [input]
        cmp al, 01h
        jbe endFact

        mov bl, [input]
        call proc_fact
        mov rbx, rax
        call print

        IO 1, 1, endline, l2
        call exit
    ret

    endFact:
        IO 1, 1, base, l3
    ret

    print:
        mov rdi, dispbuff
        mov rcx, 16
    repeat:
        rol rbx, 4
        mov dl,bl
        and dl, 0fh
        add dl, 30h
        cmp dl, 39h
        jbe skip1
        add dl, 07h

        skip1:
            mov [rdi], dl
            inc rdi
            loop repeat
        IO 1, 1, dispbuff, 16
    ret

    proc_fact:
        cmp bl, 1
        jne do_calc
        mov ax, 1
    ret

    do_calc:
        push rbx
        dec bl
        call proc_fact
        pop rbx
        mul bl
    ret

    exit:
        mov rax, 60
        mov rdi, 0
        syscall
    ret

; Output:
;  Factorial is -> 00000000000002D0