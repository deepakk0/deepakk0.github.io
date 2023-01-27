; File: loop.asm
;
; This program demonstrates the use of a loop sequence
;
; Assemble using NASM:  nasm -g -f elf -F dwarf loop.asm
; Compile using gcc:    gcc -m32 loop.o -o loop
; Debug using gdb:      gdb -tui loop
;

        SECTION .text                                   ; Code section.
        global main

main:   
        mov     ecx,234                                 ; move data into ecx
        mov     eax,20                                  ; move data into eax
l0:     inc     ecx                                     ; increment the value in ecx
        inc     eax                                     ; increment the value in eax
        cmp     eax,37                                  ; compare eax with decimal 37
        jnz     l0                                      ; jump to label l0 if zero flag was not set


l1:     mov     ebx,40                                  ; move data into ebx
        dec     ebx                                     ; decrement the value in ebx
        cmp     ebx,eax                                 ; compare eax with ebx
        jge     l1                                      ; jump if value in ebx is greater than or equal to eax
        jmp     l2                                      ; jump to label l2

l2:
                                                        ; final exit
        mov     eax,1                                   ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel