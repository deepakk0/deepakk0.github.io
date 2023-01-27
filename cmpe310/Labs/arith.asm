; File: arith.asm
;
; This program demonstrates arithmetic operations
;
; Assemble using NASM:  nasm -g -f elf -F dwarf arith.asm
; Compile using gcc:    gcc -m32 arith.o -o arith
; Debug using gdb:      gdb -tui arith
;

        SECTION .text                                   ; Code section.
        global main

main:   

        mov     al,96                                   ; move data into al
        cmp     al,80                                   ; compare data in al
        sub     al,80                                   ; subtract 
        mov     al,-64                                  ; move data into al
        mov     bl,80                                   ; move data into bl
        cmp     al,bl                                   ; compare data in al and bl
        sub     al,bl                                   ; subtract
        mov     al,96                                   ; move data into al
        mov     bl,80                                   ; move data into bl
        add     al,bl                                   ; Add
        mov     al,64                                   ; move data into al
        mov     bl,-80                                  ; move data into bl
        cmp     al,bl                                   ; compare data in al and bl
        sub     al,bl                                   ; subtract
        mov     al,64                                   ; move data into al
        mov     bl,80                                   ; move data into bl
        cmp     al,bl                                   ; compare data in al and bl
        sub     al,bl                                   ; subtract
        mov     ax,2030h                                ; move data into ax
        mov     bx,1030h                                ; move data into bx
        mul     bx                                      ; multiply and observe the contents of ax and dx
        mov     ax,-34                                  ; move data into ax
        mov     bx,24                                   ; move data into bx
        imul    bx                                      ; multiply and observe the contents of ax and dx
        xor     eax,eax                                 ; clear eax
        xor     ebx,ebx                                 ; clear ebx
        xor     edx,edx                                 ; clear edx
        mov     ax,0030h                                ; move data into ax
        mov     bl,3                                    ; move data into bl
        div     bl                                      ; divide and observe the contents of ax and dx
        mov     ax,2030h                                ; move data into ax
        mov     dx,1234h                                ; move data into dx
        mov     bx,9                                    ; move data into bx
        idiv    bx                                      ; divide and observe the contents of ax and dx

                                                        ; final exit
        mov     eax,1                                   ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel