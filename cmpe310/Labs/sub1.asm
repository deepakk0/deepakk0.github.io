; File: sub1.asm
;
; This program demonstrates the use of a called subroutine
;
; Assemble using NASM:  nasm -g -f elf -F dwarf sub1.asm
; Compile using gcc:    gcc -m32 sub1.o -o sub1
; Debug using gdb:      gdb -tui sub1
;

        section .data                                   ; section declaration
msg     db  'Inside Subroutine!',0xA                    ; our string
len     equ $ - msg                                     ; length of our string

        section .text                                   ; Code section.
        global main

main:   
        mov     ecx,234                                 ; move data into ecx
        mov     eax,20                                  ; move data into eax
l0:     inc     ecx                                     ; increment the value in ecx
        inc     eax                                     ; increment the value in eax
        cmp     eax,37                                  ; compare eax with decimal 37
        jnz     l0                                      ; jump to label l0 if zero flag was not set

        
        call    subrt                                   ; call subroutine
        jmp     exit                                    ; jump to exit after returning from subroutine

subrt:      
        mov     eax,4                                   ; system call number (sys_write)
        mov     ebx,1                                   ; file descriptor (stdout)
        mov     ecx,msg                                 ; message to write
        mov     edx,len                                 ; message length
        int     0x80                                    ; call kernel
        ret
        
exit:                                                   ; final exit
        mov     eax,1                                   ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel
