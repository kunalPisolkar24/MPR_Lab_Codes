; Write X86/64 ALP to convert 4-digit Hex number into its equivalent BCD number and 5-digit BCD number into its equivalent HEX number. 
; Make your program user-friendly to accept the choice from the user for: (a) HEX to BCD (b) BCD to HEX (c) EXIT.
; Display proper strings to prompt the user while accepting the input and displaying the result. (Wherever necessary, use 64-bit registers).

%macro IO 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro

section .data
	nline db 10,10
	nline_len equ $ - nline
	
	ano db 10,"------------------------------------------------",
		db 10, "Conversion From Hex to BCD and BCD to Hex number",
		db 10, "-------------------------------------------------", 10
	ano_len equ $ - ano

	menu db 10,"1.HEX to BCD", 
	db 10, "2.BCD to HEX",
	db 10, "3.Exit",
	db 10, "Enter your choice: "
	menu_len equ $ - menu

	hmsg db 10,"Enter 4 digit Hex number >> ";
	hmsg_len equ $ - hmsg

	bmsg db 10, "Enter 5 digit BCD number >> ";
	bmsg_len equ $ - bmsg

	ebmsg db 10, "The Equivalent BCD number >> ";
	ebmsg_len equ $ - ehmsg

	ehmsg db 10,"The Equivalent HEX number is >> "
	ehmsg_len equ $ - ehmsg

	emsg db 10, "INVALID NUMBER input", 10
	emsg_len equ $ - emsg

section .bss

	buf resb 6
	char_ans resb 4
	ans resw 1

section .text
	global _start

	_start:

			IO 1, 1, ano, ano_len
		Menu:
			IO 1, 1, menu, menu_len
			IO 0, 0, buf, 2

			mov al, [buf]

			c1:
				cmp al, '1'
				jne c2
				call hexToBcd
				jmp Menu

			c2: 
				cmp al, '2'
				jne c3
				call bcdHex
				jmp Menu
			
			c3:
				cmp al, '3'
				jne invalid
				call exit
			
			invalid:
				IO 1, 1, emsg, emsg_len
				jmp Menu
		
		hexToBcd:
			IO 1, 1, hmsg, hmsg_len
			call acceptInput
			mov ax, bx
			mov bx, 10
			xor bp, bp

			back:
			 	xor dx, dx
				div bx
				push dx
				inc bp
				cmp ax, 0
				jne back
				IO 1, 1, ebmsg, ebmsg_len

			back1:
				pop dx
				add dl, 30h
				mov [char_ans], dl
				IO 1, 1, char_ans, 1

				dec bp
				jnz back1
		ret

		bcdHex:
			IO 1, 1, bmsg, bmsg_len
			IO 0, 0, buf, 6

			mov rsi, buf
			xor ax, ax
			mov rbp, 5
			mov rbx, 10

		next:
			xor cx, cx
			mul bx
			mov cl, [rsi]
			sub cl, 30h
			add ax, cx

			inc rsi
			dec rbp
			jnz next

			mov [ans], ax
			IO 1, 1, ehmsg, ehmsg_len

			mov ax, [ans]
			call display16
		ret

		display16:
			mov rsi, char_ans + 3
			mov rcx, 4
			mov rbx, 16

			nextDigits:
				xor rdx, rdx
				div rbx
				cmp dl, 9
				jbe add30
				add dl, 07h

			add30:
				add dl, 30h
				mov [rsi], dl
				
				dec rsi
				dec rcx 
				jnz nextDigits

				IO 1, 1, char_ans, 4
		ret

		acceptInput:
			IO 0, 0, buf, 5
			mov rcx, 4
			mov rsi, buf
			xor bx, bx

			nextByte:
				shl bx, 4
				mov al, [rsi]

				cmp al, '0'
				jb error 
				cmp al, '9'
				jbe sub30

				cmp al, 'A'
				jb error
				cmp al,'F'
				jbe sub37

				cmp al, 'a'
				jb error
				cmp al, 'f'
				jbe sub57

			error:
				IO 1, 1, emsg, emsg_len
				call exit;

				sub57: 
					sub al, 20h
				
				sub37:
					sub al, 07h
				
				sub30:
					sub al, 30h
				
				add bx, ax
				inc rsi
				dec rcx
				jnz nextByte
			ret

		exit:
			IO 1,1, nline, nline_len
			mov rax, 60
			mov rdi, 0
			syscall
		ret
	ret

; Output
---------------------------------------------------------------------------------------

; ------------------------------------------------
; Conversion From Hex to BCD and BCD to Hex number
; -------------------------------------------------

; 1.HEX to BCD
; 2.BCD to HEX
; 3.Exit
; Enter your choice: 1

; Enter 4 digit Hex number >> abcd 
; 43981
; 1.HEX to BCD
; 2.BCD to HEX
; 3.Exit
; Enter your choice: 2

; Enter 5 digit BCD number >> 43981

; The Equivalent HEX number is >> ABCD
; 1.HEX to BCD
; 2.BCD to HEX
; 3.Exit
; Enter your choice: 3
