; File: ex4.asm
;
; This program demonstrates the storage of data in a record
;
; Assemble using NASM:  nasm -g -f elf -F dwarf ex4.asm
; Compile using gcc:    gcc -m32 ex4.o -o ex4
; Debug using gdb:      gdb -tui ex4
;


        SECTION .data                                   ; Data section

                                                        ; simulates a text file (record)
text0:
row1:   db "Knight Rider a shadowy flight"
row2:   db "into the dangerous world of a"
        db " man who does not exist. Mich"
        db "ael Knight, a young loner on "
        db "a crusade to champion the cau"
        db "se of the innocent, the innoc"
        db "ent, the helpless in a world "
        db "of criminals who operate abov"
        db "e the law. Knight Rider, Keep"
        db " riding brave into the night."
rlen:   equ $-text0
rowlen: equ row2 - row1

        SECTION .text                                   ; Code section.
        global main

main: nop                                               ; Entry point.

                                                        ; final exit
        mov     eax,1                                   ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel