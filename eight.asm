;Write X86/64 ALP to perform overlapped block transfer with string-specific instructions. The block containing data can be defined in the data segment.


%macro IO 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    sourceBlock db 12h,45h,87h,24h,97h, 0h, 0h, 0h, 0h, 0h
    count equ 10

    space db " "
    spacelen equ $ - space

    msgSource db 10,"The source block contains the elements : ",10
    msgSource_len equ $ - msgSource

    msgDest db 10,"The destination block contains the elements : ",10
    msgDest_len equ $ - msgDest

    bef db 10, "Before Block Transfer : ",10
    beflen equ $ - bef

    aft db 10,10 ,"After Block Transfer : ",10
    aftlen equ $ - aft

    newLine db "", 10
    nl equ $ - newLine

section .bss
    destBlock resb 5
    result resb 4
section .text
    global _start
    _start:
        IO 1, 1, bef, beflen
        IO 1, 1, msgSource, msgSource_len

        mov rsi, sourceBlock
        call printBlock

        mov rsi, sourceBlock + 03h
        mov rdi, sourceBlock + 08H

        call withoutString ; change this to switch

        IO 1, 1, aft, aftlen

        IO 1, 1, msgSource, msgSource_len
        mov rsi, sourceBlock
        call printBlock

        IO 1, 1, newLine, nl
        call exit
    ret

    withStringInstruction:
        mov rcx, 3
        std
        rep movsb
    ret

    withoutString:
        mov rcx, 3
        again:
            mov al, [rsi]
            mov [rdi],al
            dec rsi
            dec rdi
        loop again
    ret
    
    exit:
        mov rax, 60
        mov rdi, 0
        syscall
    ret

    printBlock:
        mov rbp, count
        next:
            mov al, [rsi]
            push rsi
            call print
            pop rsi
            inc rsi
            dec rbp
            jnz next
    ret

    print:
        mov bl, al
        mov rdi, result
        mov cx, 02
        repeat:
            rol bl, 04
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
                dec cx
                jnz repeat

            IO 1, 1, result, 4
            IO 1, 1, space, spacelen
    ret

; Output
; --------------------------

; Before Block Transfer : 

; The source block contains the elements : 
; 12 45 87 24 97 00 00 00 00 00 

; After Block Transfer : 

; The source block contains the elements : 
; 12 45 87 24 97 00 45 87 24 00 