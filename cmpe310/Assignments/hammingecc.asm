; File: hammingecc.asm
;
; This program implements the Hamming (8,4) ECC.
; Input is limited to 8 characters (minimum and maximum).
;
; Encoding format:
;                 ------------------------------------------------
; bit position    | 8   | 7   | 6   | 5   | 4   | 3   | 2   | 1  |
;                 ------------------------------------------------
; parity order    | p4  | d4  | d3  | d2  | p3  | d1  | p2  | p1 |
;                 ------------------------------------------------     
;
; Assemble using NASM:  nasm -g -f elf -F dwarf hammingecc.asm
; Compile using gcc:    gcc -m32 hammingecc.o -o hammingecc
; Debug using gdb:      gdb -tui hammingecc
;
;

%define STDIN         0
%define STDOUT        1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN        9

        section .data                                   ; section declaration
msg     db  'Input Data: '                              ; Input prompt
len     equ $ - msg                                     ; length of input prompt


msgI    db  'Invalid Data!',0Ah                         ; Invalid data message
lenI    equ $ - msgI                                    ; length of invalid data message


msgE    db  'Two or more bit errors detected!',0Ah      ; Two or more bit errors detected
lenE    equ $ - msgE                                    ; length of two or more bit errors detected


bitE    db  'Bit error detected at position: '          ; Bit error string
lenBE   equ $ - bitE                                    ; length of bit error string

msgC    db  'Corrected bit sequence: ',                 ; Corrected string
lenC    equ $ - msgC                                    ; length of corrected string


msgA    db  'Overall Parity Error Detected',0Ah         ; our string
lenA    equ $ - msgA                                    ; length of our string

bitNE   db  'No Error Detected',0Ah                     ; our string
lenNE   equ $ - bitNE                                   ; length of our string


        section .bss                                    ; section declaration
temp    resb BUFLEN+10                                  ; our string
binD    resb 1                                          ; original binary
pos     resb 2                                          ; bit error position
result  resb BUFLEN                                     ; corrected result


        section .text                                   ; Code section.
        global main

main:   
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,msg                                 ; message to write
        mov     edx,len                                 ; message length
        int     80h                                     ; call kernel


        mov     eax,SYSCALL_READ                        ; system call number (sys_read)
        mov     ebx,STDIN                               ; file descriptor (stdin)
        mov     ecx,temp                                ; message to write
        mov     edx,BUFLEN+10                           ; message length
        int     80h                                     ; call kernel

        cmp     eax,BUFLEN                              ; check to see if user input exceeded limit                 
        jg      invalid                                 ; if exceeded, print invalid message

initbin:                                                ; sequence that converts user input in ASCII to binary
        mov     edx, temp                               ; initialize EDX with the address of user input
        xor     edi, edi                                ; initialize EDI for index tracking
        mov     ecx, BUFLEN-1                           ; initialize counter ECX to keep track of user input
        mov     ebx, 0                                  ; initialize EBX, which will eventually hold the ...
                                                        ; ... converted binary in its upper byte BH

binchk:                                                 ; loop that converts user input to binary 
        mov     bl, byte[edx+edi]                       ; BL will initially hold each character in the user input     
        inc     edi                                     ; proceed to next character index
        sub     bl, '0'                                 ; determine the decimal equivalent of the character
        cmp     bl, 1                                   ; this comparison additionally checks for invalid characters
        jg      invalid                                 ; if the user input an invalid character print invalid message
        shl     bh, 1                                   ; shift value in BH by one bit position to accomodate the ...
        xor     bh, bl                                  ; ... next converted bit
        loop    binchk                                  ; loop instruction performs a jmp after decrementing ECX by one ...
                                                        ; ... if ECX is 0, no jmp is performed and the next instruction ...
                                                        ; ... is executed

begin:                                                  ; implement your parity checker here
                                                        ; call/jmp to appropriate routine when necessary

printRes:
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,bitE                                ; message to write
        mov     edx,lenBE                               ; message length
        int     80h                                     ; call kernel


        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,pos                                 ; message to write
        mov     edx,2                                   ; message length
        int     80h                                     ; call kernel

        jmp     corrected                               ; print the corrected bit sequence

allParPrint:
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,msgA                                ; message to write
        mov     edx,lenA                                ; message length
        int     80h                                     ; call kernel

corrected:
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,msgC                                ; message to write
        mov     edx,lenC                                ; message length
        int     80h                                     ; call kernel

        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,result                              ; message to write
        mov     edx,BUFLEN                              ; message length
        int     80h                                     ; call kernel
        jmp     exit

valid:  
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,bitNE                               ; message to write
        mov     edx,lenNE                               ; message length
        int     80h                                     ; call kernel
        jmp     exit

invdet:
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,msgE                                ; message to write
        mov     edx,lenE                                ; message length
        int     80h                                     ; call kernel
        jmp     exit

invalid:
        mov     eax,SYSCALL_WRITE                       ; system call number (sys_write)
        mov     ebx,STDOUT                              ; file descriptor (stdout)
        mov     ecx,msgI                                ; message to write
        mov     edx,lenI                                ; message length
        int     80h                                     ; call kernel

exit:                                                   ; final exit
        mov     eax,SYSCALL_EXIT                        ; system call number (sys_exit)
        xor     ebx,ebx                                 ; sys_exit return status
        int     0x80                                    ; call kernel