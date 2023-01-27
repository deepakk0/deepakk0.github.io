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
	
%define INT_A0  0xFFF4 		;8259 A0=0 Data
%define INT_A1  0XFFF6		;8259 A0=1 Command
			
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
   mov al, 00111001b
   out dx, al
   
   ; Setup the keyboard
   mov dx, KBD_CMD
   mov al, 00000001b
   out 	dx, al
   
   ;clear the FIFO
   mov dx, KBD_CMD
   mov al, 11000011b
   out 	dx, al
   
   ; Send initialization control words (ICWs) to interrupt controller
   mov dx, INT_A0 ; 8259 command
   mov al, 00010011b ; ICW1
   out dx, al
   
   mov dx, INT_A1
   mov al,  00001000b; ICW2
   out dx, al
   
   mov dx, INT_A1
   mov al, 000000001b ; ICW4
   out dx, al
   
   mov dx, INT_A1 ; OCW1
   mov al, 11111101b
   out dx, al
   
; Setup up interrupt vector table
; -------------------------------
	
    mov bx, 8H * 4		;Interrupt vector table 0x08 base address
	mov ax, 0
	mov es, ax
    mov cx, intr1 ;INTR1 service routine
    mov [es:bx+4], cx		;offset to IR1
    mov [es:bx+6], cs		;current code segment

    ; mov cx, INTR2		;INTR2 service routine for timer
    ; mov [es:bx+16], cx		;offset to IR4
    ; mov [es:bx+18], cs		;segment
   
   sti ; turn on interrupts
 
  
  
	;; When using interrupts use the following instruction (jmp $) to sit in a busy loop, turn on interrupts before that
	jmp $

;---------------------------------------
  ; Interrupt service routine for keyboard
  intr1:
   read_FIFO:
   ;push bp
   ;mov sp, bp
   ; jprint:
   ;mov ax, 2 ; second row
   ;mov bx, message
   ;mov cx, 20
   ;mov dx, 0
   ;mov si, ds
   ;int 10H
   
   ;read the FIFO
   ; first check to see if anything was pressed
   ;mov dx, KBD_CMD
   ;in ax, dx 
   
 ;  and al,  00000111b
  ; cmp al, 0
   ; if no keyboard was pressed read FIFO again
   ;je read_FIFO
   
   ; print space
   mov ax, 2 ; second row
   mov bx, " "
   mov cx, 1
   mov dx, 16
   mov si, ds
   int 10H
   
   ;moved data from keyboard into al
   mov dx, KBD_DAT
   in ax, dx
   ;clear the first two bits
   ;first 2 bits are don't cares
   and al, 00111111b ; 
   mov cl, al ;;;;;;;;;;;
   mov bx, table
   ; goes to location of table the corresponds to al
   xlat
   
  ;mov contents of al into the key variable
   mov byte[key], al
   
   ;mov cl, al ;transfer character to another register 
   and cl, 00000100b ; and with the first bits zero to find the values of the last three bits (RETURN) 
   jz print
   
   mov ax, 2 ; second row
   mov bx, fKey
   mov cx, 1
   mov dx, 16
   mov si, ds
   int 10H
   
   
   print:
   mov ax, 2 ; second row
   mov bx, key
   mov cx, 1
   mov dx, 17
   mov si, ds
   int 10H
   
   mov dx, INT_A0 ; 8259 command
   mov al, 00100000b ; OCW2
   out dx, al
  

   ;mov sp, bp
  ; pop bp
   
   iret
   

   

; --------------------------------------------------------------------------------------------------------------------------
; 													      			
; RAM data section, align at 16 byte boundry, 16-bit
; --------------------------------------------------------------------------------------------------------------------------	


section CONSTSEG USE16 ALIGN=16 CLASS=CONST
	
welcomemsg:	db "                    "
			db "                    "
			db "    Key Display     "
			db "                    "
message:    db "     Hi              "
			
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
		
		
		

