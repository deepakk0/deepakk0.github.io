; Final Project
; CMPE 310 Patel
; Christopher Pagan
; Elise Donkor
; Emmett Cummings

; Force 16-bit code and 8086 instruction set
; ------------------------------------------

;;; DON'T CHANGE
	
BITS 16
CPU 8086

; Keyboard Display Controller Port Addresses
; ------------------------------------------	
;;; EXAMPLE

%define	KBD_CMD 0xFFF2		;keyboard command register
%define KBD_DAT 0xFFF0		;keyboard data register
	
; Interrupt Controller Port addresses
; -----------------------------------
;;; EXAMPLE
	
%define INT_A0  0xFFF4 		;8259 A0=0
%define INT_A1  0XFFF6		;8259 A0=1
			
; --------------------------------------------------------------------------------------------------------------------------
; 															      			
; ROM code section, align at 16 byte boundry, 16-bit code 								      	
; Code segment: PROGRAM, relocate using loc86 AD option to 0xF0000 size is variable, burn at location 0x18000 in the Flash    
; Use loc86 BS option to put a jump from 0xFFFF0 (reset location) to the code segment, burn at location 0x1FFF8 in the Flash  
; 															      
; --------------------------------------------------------------------------------------------------------------------------
;;THIS IS YOUR CODE SEGMENT, don't change anything till the cli instruction

section PROGRAM USE16 ALIGN=16 CLASS=CODE
	
..start

   cli				; Turn off interrupts
	  mov ax, 0
   mov bx, welcomemsg
   mov cx, 80
   mov dx, 0
   mov si, ds
   int 10H
   
	;set the clock
	;001 says clock
	; 11001 is 25 because .5 MHz /25 = 100 KHz and we want 100 kHz
   mov dx, KBD_CMD
   mov ax, 00111001b
   out	dx, ax
   
   ; Setup the keyboard
   mov dx, KBD_CMD
   mov ax, 00000001b
   out 	dx, ax
   
   ;clear the FIFO
   mov dx, KBD_CMD
   mov ax, 11000011b
   out 	dx, ax
   
   
   pullLoop:
   
   read_FIFO:
   ;read the FIFO
   ; first check to see if anything was pressed
   mov dx, KBD_CMD
   in ax, dx 
   
   and al,  00000111b
   cmp al, 0
   ; if no keyboard was pressed read FIFO again
   je read_FIFO
   
   
   mov ax, 2 ; second row
   mov bx, " "
   mov cx, 1
   mov dx, 15
   mov si, ds
   int 10H
   
   ;moved data from keyboard into al
   mov dx, KBD_DAT
   in ax, dx
   ;clear the first two characters
   and al, 00111111b ; 
   mov cl, al ;;;;;;;;;;;
   mov bx, table
   ; goes to location of table the corresponds to al
   xlat
   
  ;mov contents of al into the key variable
   mov byte[key], al
   
   ;mov cl, al ;transfer character to another register 
   and cl, 00000100b ; and with the first bits zero to find the values of the last three bits (RETURN) 
   ;cmp cl, 00000100b ; if the value of the last three bits is five, then print F in front of it
   ;and cl, 00000100b
   jz print
   
   mov ax, 2 ; second row
   mov bx, fKey
   mov cx, 1
   mov dx, 15
   mov si, ds
   int 10H
   
   
   print:
   mov ax, 2 ; second row
   mov bx, key
   mov cx, 1
   mov dx, 16
   mov si, ds
   int 10H
   
   ; al now has the letter that we pressed
   
   jmp pullLoop
   
   
   
	;; When using interrupts use the following instruction (jmp $) to sit in a busy loop, turn on interrupts before that
	;; jmp $
	
	
	
   ; Setup up interrupt vector table
   ; -------------------------------
;;; EXAMPLE, take this code out when not using interrupts. This loads two interrupt vectors at vectors 0x09 and 0x0A 
	



; --------------------------------------------------------------------------------------------------------------------------
; 													      			
; RAM data section, align at 16 byte boundry, 16-bit
; --------------------------------------------------------------------------------------------------------------------------	


section CONSTSEG USE16 ALIGN=16 CLASS=CONST
	
welcomemsg:	db "                    "
			db "                    "
			db "    Key Display     "
			db "                    "
			
table:  db '0'
	    db '1'
		db '2'
		db '3'
		db '1'
		db '0'
		db '0'
		db '0'
		db '4'
		db '5'
		db '6'
		db '7'
		db '2'
		db '0'
		db '0'
		db '0'
		db '8'
		db '9'
		db 'A'
		db 'B'
		db '3'
		db '0'
		db '0'
		db '0'
		db 'C'
		db 'D'
		db 'E'
		db 'F'
		db '4'
		
fKey:	db 'F'
		
key:	db 0 
		
		
		

