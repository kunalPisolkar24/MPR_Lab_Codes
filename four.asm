%macro IO 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3 
    mov rdx, %4
    syscall
%endmacro

section .data
    msg1 db "Count of Positive numbers: ",
    len1 equ $-msg1

    msg2 db 10,"Count of negative numbers: ",
    len2 equ $-msg2

    array db 10,12,-21,-12,-19,-34,41

    newline db 10,""
    new equ $ - newline

section .bss
    count resb 2
    pcount resb 2
    ncount resb 2
    totalcount resb 2

section .text
    global _start
    _start:
        mov byte[count],07
        mov byte[pcount],00
        mov byte[ncount],00
        mov rsi,array

        mov rcx, 07
        repeat:
            mov al,00
            add al,[rsi]
            js neg

            inc byte[pcount]
            jmp skip

            neg:
                inc byte[ncount]
        skip:
            inc rsi
            dec byte[count]
            loop repeat


        IO 1, 1, msg1,len1

        mov bh,[pcount]
        call disp
        IO 1, 1, msg2,len2

        mov bh,[ncount]
        call disp
        IO 1, 1, newline, new

        call exit
    ret

    disp:
        mov byte[count], 02
        repeat2:
            rol bh,04
            mov al,bh
            AND al,0FH
            cmp al,09H

            jbe l1
            add al,07h

            l1:
                add al,30h
                
            mov[totalcount],al
            IO 1, 1, totalcount,02
            dec byte[count]
        loopne repeat2
    ret

    exit:
        mov rax,60
        mov rdi,00
        syscall
    ret

;     Output
;----------------------
;     Count of Positive numbers: 03
;     Count of negative numbers: 04