; Write an X86/64 ALP to find the largest of given Byte/Word/Dword/64-bit numbers.

%macro IO 4
    mov rax,%1
    mov rdi,%2
    mov rsi,%3
    mov rdx,%4
    syscall
%endmacro

section .data
    array db 11h,59h,33h,22h,44h
   
    msg2 db 10,"The Array contains the elements : ",10
    msg2_len equ $ - msg2

    msg3 db 10,10, "The Largest number in the array is : ",
    msg3_len equ $ - msg3

    spa db " "
    sp1 equ $ - spa

    newLine db 10, " ",10
    newStuff equ $ - newLine

section .bss
    counter resb 1
    result resb 4

section .text
    global _start
    _start:
        IO 1, 1, msg2 , msg2_len

        mov byte[counter],05
        mov rsi,array

        call printBlock

        IO 1, 1, msg3 , msg3_len

        mov byte[counter],05
        mov rsi, array

        call comparision
        call disp

        IO 1, 1, newLine, newStuff

        call exit
    ret

    printBlock:
        next: 
            mov al,[rsi]
            push rsi
            call disp
            pop rsi
            inc rsi
            dec byte[counter]
            jnz next
    ret

    comparision:
        mov al, 0 
        repeat: 
            cmp al,[rsi] 
            jg skip
            mov al,[rsi]
            
            skip: 
                inc rsi
                dec byte[counter]
                jnz repeat
    ret

    disp:
        mov bl,al 
        mov rdi, result 
        mov rcx,02 

        repeat1:
            rol bl,04 
            mov al,bl 
            and al,0fh 
            cmp al,09h 

            jg add_37 
            add al,30h
            jmp skip1 

            add_37: 
                add al,37h

            skip1:
                mov [rdi],al 
                inc rdi  
            loop repeat1

        IO 1, 1, result , 4
        IO 1, 1, spa, sp1
    ret

    exit:
        mov rax,60
        mov rdi,1
        syscall
    ret

; Output
; The Array contains the elements : 
; 11 59 33 22 44 

; The Largest number in the array is : 59 

