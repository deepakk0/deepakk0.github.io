; File: ex3.asm
;
; This program demonstrates the storage of data in a matrix
;
; Assemble using NASM:  nasm -g -f elf -F dwarf ex3.asm
; Compile using gcc:    gcc -m32 ex3.o -o ex3
; Debug using gdb:      gdb -tui ex3
;


        SECTION .data                                   ; Data section
                                                        ; simulates a 2-dim array
matrix0:
row1:   dd 00, 01, 02, 03, 04, 05, 06, 07, 08, 09 
row2:   dd 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 
        dd 20, 21, 22, 23, 24, 25, 26, 27, 28, 29 
        dd 30, 31, 32, 33, 34, 35, 36, 37, 38, 39 
        dd 40, 41, 42, 43, 44, 45, 46, 47, 48, 49 
        dd 50, 51, 52, 53, 54, 55, 56, 57, 58, 59 
        dd 60, 61, 62, 63, 64, 65, 66, 67, 68, 69 
        dd 70, 71, 72, 73, 74, 75, 76, 77, 78, 79 
        dd 80, 81, 82, 83, 84, 85, 86, 87, 88, 89 
        dd 90, 91, 92, 93, 94, 95, 96, 97, 98, 99 

rowlen: equ row2 - row1


        SECTION .text                                   ; Code section.
        global main

main:   nop                                             ; Entry point.

                                                        ; final exit
        mov     eax,1                                   ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel