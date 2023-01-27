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

	;; When using interrupts use the following instruction (jmp $) to sit in a busy loop, turn on interrupts before that
	;; jmp $
	
	
	
   ; Setup up interrupt vector table
   ; -------------------------------
;;; EXAMPLE, take this code out when not using interrupts. This loads two interrupt vectors at vectors 0x09 and 0x0A 
	
    mov bx, 8H * 4		;Interrupt vector table 0x08 base address
    mov cx, INTR1		;INTR1 service routine
    mov [es:bx+4], cx		;offset
    mov [es:bx+6], cs		;current code segment
    mov cx, INTR2		;INTR2 service routine
    mov [es:bx+8], cx		;offset
    mov [es:bx+10], cs		;segment

; --------------------------------------------------------------------------------------------------------------------------
; 													      			
; RAM data section, align at 16 byte boundry, 16-bit
; --------------------------------------------------------------------------------------------------------------------------	
;;; THIS IS YOUR DATA SEGMENT

section CONSTSEG USE16 ALIGN=16 CLASS=CONST
	