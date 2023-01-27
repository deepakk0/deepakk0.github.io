; File: morefltArith.asm 
;
; Assemble  nasm -g -f elf morefltArith.asm -l moreFltArith.lst  
; Link      gcc -m32 moreFltArith.o -o moreFltArith
; Debug     gdb -tui  ./moreFltArith
;
; the output from running moreFltArith and moreFltarithc is:    
; c=-5.0, a=3.000000e+00, b=4.000000e+00, c=-5.000000e+00
; c=abs(c), a=3.000000e+00, b=4.000000e+00, c=5.000000e+00
; c=a+b, a=3.000000e+00, b=4.000000e+00, c=7.000000e+00
; c=a-b, a=3.000000e+00, b=4.000000e+00, c=-1.000000e+00
; c=a*b, a=3.000000e+00, b=4.000000e+00, c=1.200000e+01
; c=c/a, a=3.000000e+00, b=4.000000e+00, c=4.000000e+00
; a=i  , a=8.000000e+00, b=1.600000e+01, c=1.600000e+01
; a<=b , a=8.000000e+00, b=1.600000e+01, c=1.600000e+01
; b==c , a=8.000000e+00, b=1.600000e+01, c=1.600000e+01
; The file  moreFltArith.c  is:
;  #include <stdio.h>
;  #include <stdlib.h>
;  int main()
;  { 
;    double a=3.0, b=4.0, c;
;    long int i=8;
;
;    c=-5.0;
;    printf("%-8s, a=%e, b=%e, c=%e\n","c=-5.0", a, b, c);
;    c=abs(c);
;    printf("%-8s, a=%e, b=%e, c=%e\n","c=abs(c)", a, b, c);
;    c=a+b;
;    printf("%-8s, a=%e, b=%e, c=%e\n","c=a+b", a, b, c);
;    c=a-b;
;    printf("%-8s, a=%e, b=%e, c=%e\n","c=a-b", a, b, c);
;    c=a*b;
;    printf("%-8s, a=%e, b=%e, c=%e\n","c=a*b", a, b, c);
;    c=c/a;
;    printf("%-8s, a=%e, b=%e, c=%e\n","c=c/a", a, b, c);
;    a=i;
;    b=a+i;
;    i=b;
;    c=i;
;    if(a<b) printf("%-8s, a=%e, b=%e, c=%e\n","a<=b", a, b, c);
;    else    printf("%-8s, a=%e, b=%e, c=%e\n","a>b", a, b, c);
;    if(b==c)printf("%-8s, a=%e, b=%e, c=%e\n","b==c", a, b, c);
;    else    printf("%-8s, a=%e, b=%e, c=%e\n","b!=c", a, b, c);
;    return 0;
; }


%define SYSCALL_EXIT  1

extern printf                               ; the C function to be called

    
    SECTION  .data                          ; preset constants, writeable
a:     dd    3.0                            ; 32-bit variable a initialized to 3.0
b:     dd    4.0                            ; 32-bit variable b initializes to 4.0
i:     dd    8                              ; a 32 bit integer
mfive: dd    -0.5E01                        ; constant -5.0

msg1:  db "c=-5.0",0                        ; operation 1
msg2:  db "c=abs(c)",0                      ; operation 2
msg3:  db "c=a+b",0                         ; operation 3
msg4:  db "c=a-b",0                         ; operation 4
msg5:  db "c=a*b",0                         ; operation 5
msg6:  db "c=c/a",0                         ; operation 6
msg7:  db "a<=b",0                          ; operation 7
msg8:  db "a>b",0                           ; operation 8
msg9:  db "b==c",0                          ; operation 9
msg10: db "b!=c",0                          ; operation 10

fmt:   db "%-8s, a=%e, b=%e, c=%e",10,0    ; format string for printf
    
    SECTION .bss                            ; unitialized space
c:     resq    1                            ; reserve a 64-bit word
    SECTION .text                           ; instructions, code segment
    global  main                            ; for gcc standard linking

main:                                       ; label

litm5:                                      ; c=-5.0;
    fld    dword [mfive]                    ; -5.0 constant
    fst    dword [c]                        ; store into c
    mov    dword [esp-32], msg1             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message

litabs:                                     ; c=-5.0;
    fabs                                    ; find absolute value
    fstp   dword [c]                        ; store into c and pop
    mov    dword [esp-32], msg2             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message
 
    
addb:                                       ; c=a+b;
    fld    dword [a]                        ; load a (pushed on flt pt stack, st0)
    fadd   dword [b]                        ; floating add b (to st0)
    fstp   dword [c]                        ; store into c (pop flt pt stack)
    mov    dword [esp-32], msg3             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message

    
subb:                                       ; c=a-b;
    fld    dword [a]                        ; load a (pushed on flt pt stack, st0)
    fsub   dword [b]                        ; floating subtract b (to st0)
    fstp   dword [c]                        ; store into c (pop flt pt stack)
    mov    dword [esp-32], msg4             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message
    
mulb:                                       ; c=a*b;
    fld    dword [a]                        ; load a (pushed on flt pt stack, st0)
    fmul   dword [b]                        ; floating multiply by b (to st0)
    fstp   dword [c]                        ; store product into c (pop flt pt stack)
    mov    dword [esp-32], msg5             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message
    
diva:                                       ; c=c/a;
    fld    dword [c]                        ; load c (pushed on flt pt stack, st0)
    fdiv   dword [a]                        ; floating divide by a (to st0)
    fstp   dword [c]                        ; store quotient into c (pop flt pt stack)
    mov    dword [esp-32], msg6             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message

intflt:                                     ; a=i;
    fild   dword [i]                        ; load integer as floating point
    fst    dword [a]                        ; store the floating point (no pop)
    fadd   st0                              ; b=a+i; 'a' as 'i'  already on flt stack
    fst    dword [b]                        ; store sum (no pop) 'b' still on stack
    fistp  dword [i]                        ; i=b; store floating point as integer
    fild   dword [i]                        ; c=i; load again from ram (redundant)
    fstp   dword [c]

cmpflt:    
    fld    dword [b]                        ; into st0, then pushed to st1
    fld    dword [a]                        ; in st0
    fcomp  st1                              ; a compare b, pop a     
                                            ;           bit position: 15 14 13 12 11 10 9  8   7  6  5  4  3  2  1  0
    fstsw  ax                               ; copy FPU status to ax  [SF ZF X  AF  X PF X CF | ES SF PE UE OE ZE DE IE]
    test   ax, 0x0100                       ; test bit position 8 (CF)
    je     cmpfl2                           ; if a < b
    mov    dword [esp-32], msg7             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message
    jmp    cmpfl3

cmpfl2:    
    mov    dword [esp-32], msg8             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message

cmpfl3:
    fld    dword [c]                        ; should equal [b]
    fcomip st0,st1                          ; 
    jne    cmpfl4
    mov    dword [esp-32], msg9             ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message
    
carrytst:
    stc                                     ; demonstration of set carry flag , verify this in gdb
    clc                                     ; demonstration of clear carry flag, verify this in gdb
    cmc                                     ; demonstration of complement carry flag, verify this in gdb
    jmp    exit

cmpfl4:
    mov    dword [esp-32], msg10            ; store format string in advance  4 + (8*3) + 4 (return address)
    call   printFL                          ; call subroutine to print message

exit:
    mov    eax,SYSCALL_EXIT                 ; system call number (sys_exit)
    xor    ebx,ebx                          ; return value
    int    80h                              ; call kernel


printFL:                                    ; we will use this subroutine to push in the values stored at a, b, and c
    fld    dword [c]                        ; load c into FPU stack
    fstp   qword [esp-8]                    ; pop top of FPU stack into memory stack
    fld    dword [b]                        ; load b into FPU stack
    fstp   qword [esp-16]                   ; pop top of FPU stack into memory stack
    fld    dword [a]                        ; load a into FPU stack
    fstp   qword [esp-24]                   ; pop top of FPU stack into memory stack
    sub    esp, 28                          ; adjust top of stack to get the pointer to custom message
    push   dword fmt                        ; store format string
    call   printf                           ; Call print function
    add    esp, 32                          ; adjust stack again   
    ret
