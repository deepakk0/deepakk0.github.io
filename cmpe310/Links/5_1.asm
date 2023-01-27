; Final Project
; CMPE 310 Patel



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

; --------------------------------------------------------------------------------------------------------------------------
; 													      			
; RAM data section, align at 16 byte boundry, 16-bit
; --------------------------------------------------------------------------------------------------------------------------	


section CONSTSEG USE16 ALIGN=16 CLASS=CONST
	
welcomemsg:	db "Welcome to CMPE 310!"
			db " team members names  "
			db "Fun Lab- write your "
			db "  and Enjoy!!!!  "
			
			
			