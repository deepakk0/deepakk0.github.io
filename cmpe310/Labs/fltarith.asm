; File: fltarith.asm
;
; This program demonstrates arithmetic operations
;
; Assemble using NASM:  nasm -g -f elf -F dwarf fltarith.asm
; Compile using gcc:    gcc -m32 fltarith.o -o fltarith
; Debug using gdb:      gdb -tui fltarith
;



%define    SYS_EXIT   1


extern     printf

           section .data                                ;section declaration

myfloatarr times 2 dd 23.25                             ; An array of two floating point numbers initialized to 23.25.
myfloatstr db 'This number -> %f should be 23.25',0Ah,0 ; C styled message

flt1       dd  12.34                                    ; initialize some floating point numbers
           dd  23.45
           dd  34.56
           dd  45.67
           dd  56.78

flt2	   dd  0                                        ; will be used for storing results
           dd  0

r          dd  20.3
anInt	   dd  17                                       ; initialize an integer

diameter   dd  0



         section .text                                  ; Code section.
         global main

main:  

         finit                                          ; initialize the FPU

         mov    ebx, 1                                  ; Simple example of scaled index addressing mode. in C, this is the same thing as:
         fld    dword [ebx*4 + myfloatarr]              ;        st0 = myfloatarr[1];   /* assuming you could directly assign something to st0 */

         
         sub    esp, 8                                  ; Allocate 8 bytes of stack space. Loading st0 and popping it 
         fstp   qword [esp]                             ; converts the single precision number to double precision, which

         push   dword myfloatstr                        ; printf expects.
         call   printf
         add    esp, 12

         mov    ebx, 0                                  ; another example of the indexing for flt1[0]
         fld    dword [ebx*4 + flt1]  

         inc    ebx 
         fld    dword [ebx*4 + flt1]                    ; for flt1[1]

         fadd   st1                                     ; add st1 with st0, result will be stored in st0 (12.34 + 23.45
         fstp	dword [flt2]                            ; store result and pop 

         fmul	dword [myfloatarr]                      ; multiply (12.34 * 23.25)
         fstp   dword [flt2 + 4]                        ; store result and pop
	 
         fild	dword [anInt]                           ; load integer (17)

; do the expression diameter = pi * r * r, where r = 20.3
;
;  NOTE:  Notice that 20.3 is not 20.3, but rather 20.299999237060546875
;         This in an inherit error in the floating point conversions.
;

         fld   dword [r]                                ; get the value of r
	 fld   st0                                      ; now have two copies of it on the stack
	 fmul	st1                                     ; multiply st0 and st1

         fldpi                                          ; load the value of pi into the FPU using built-in instruction
         fmul	st1                                     ; multiply st0 and st1
	 fstp	dword [diameter]                        ; finish the expression.

;Exit code
	 mov   eax, SYS_EXIT                            ; call system exit        
         xor   ebx, ebx                                 ; exit code
	 int  	80h                                     ; invoke kernel
