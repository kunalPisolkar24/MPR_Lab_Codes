;Write an X86/64 ALP to accept five 64-bit Hexadecimal numbers from the user and store them in an array and display the accepted numbers.

%macro IO 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data

	m1 db "Enter the five 64 bit numbers:" ,10 ; 10d -> line feed 
    l1 equ $-m1        

    m2 db "The  five 64 bit numbers are:" ,10   
    l2 equ $-m2 

    m5 db 10,"Exiting now" ,10    
    l5 equ $-m5

    m6 db "incorrect input error" ,10
    l6 equ $-m6

    m7 db 10

    debug db "debug " 
    debug_l equ $-debug

	time equ 5
	size equ 8
	
section .bss
	arr resb 300
	_input resb 20
	_output resb 20
	count resb 1

section .text
	global _start

	_start:

    mov byte[count],time 
	mov rbp,arr   

	IO 1,1,m1,l1

input:	
    IO 0,0,_input,17
    IO 1,1,debug,debug_l
    IO 1,1,_input,17
    
	call ascii_to_hex
    mov [rbp],rbx   
	add rbp,size    
	dec byte[count] 
	jnz input

	mov byte[count],time 
	mov rbp,arr    
	jmp display

display:	
    mov rax,[rbp]   
	call hex_to_ascii

	IO 1,1,m7,1
	IO 1,1,_output,16

	add rbp,size  
     
	dec byte[count] ; loo
	jnz display

	jmp exit

exit:	
	IO 1,1,m5,l5
	mov rax,60
	mov rdi,0
	syscall

error:
    IO 1,1,m6,l6
    jmp exit

ascii_to_hex:
    	mov rsi,_input
    	mov rcx,16
    	xor rbx,rbx  
        xor rax,rax  
    letter:	
        rol rbx,4   
    	mov al,[rsi] 
    	cmp al,47h   
    	jge error    
    	cmp al,39h  
    	jbe skip     
    	sub al,07h   
    skip:	
        sub al,30h   
    	add rbx,rax   
    	inc rsi      
    	dec rcx     
    	jnz letter
    ret	

hex_to_ascii:
        mov rsi,_output+15   
        mov rcx,16           
    letter2:	
        xor rdx,rdx          
        mov rbx,16           
        div rbx              
        cmp dl,09h           
        jbe add30            
        add dl,07h           
    add30:	
        add dl,30h           
        mov [rsi],dl         
        dec rsi              
        dec rcx                  
        jnz letter2
ret

; Output
;----------------------------------------------------------
; Enter the five 64 bit numbers:
; AAAAAAAAAAAAAAAA
; debug AAAAAAAAAAAAAAAA
; 5555555555555555
; debug 5555555555555555
; FFFFFFFFFFFFFFFF
; debug FFFFFFFFFFFFFFFF
; 1111111111111111
; debug 1111111111111111
; 9999999999999999
; debug 9999999999999999

; AAAAAAAAAAAAAAAA
; 5555555555555555
; FFFFFFFFFFFFFFFF
; 1111111111111111
; 9999999999999999
; Exiting now