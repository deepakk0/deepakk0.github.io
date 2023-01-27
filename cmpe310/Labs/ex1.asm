; File: ex1.asm
;
; This program demonstrates the use of general purpose registers
;
; Assemble using NASM:  nasm -g -f elf -F dwarf ex1.asm
; Compile using gcc:    gcc -m32 ex1.o -o ex1
; Debug using gdb:      gdb -tui ex1
;


        SECTION .text                                   ; Code section.
        global main

main:   
        mov     eax,0xABCDEF01                          ; move data into eax
        mov     ecx,0xABCDEF02                          ; move data into ecx
        mov     edx,0xABCDEF03                          ; move data into edx
        mov     ebx,0xABCDEF04                          ; move data into ebx
        mov     esp,0xABCDEF05                          ; move data into esp
        mov     ebp,0xABCDEF06                          ; move data into ebp
        mov     esi,0xABCDEF07                          ; move data into esi
        mov     edi,0xABCDEF08                          ; move data into edi

                                                        ; final exit
        mov     eax,1                                   ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel