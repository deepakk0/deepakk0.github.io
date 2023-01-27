; File: strings.asm 
;
; This code demonstrates the applicability of string instructions
; 
; Assemble using NASM:  nasm -g -f elf -F dwarf strings.asm
; Compile using gcc:    gcc -m32 strings.o -o strings
; Debug using gdb:      gdb -tui strings
;

%define SYS_EXIT  1
%define SYS_WRITE 4
%define STDIN     0
%define STDOUT    1

%define BUFLEN    20


extern printf

section .data

src   db  'STRINGS in assembly!',0Ah,0                     ; source string
len   equ $-src                                            ; length of source string     
msg   db  'STRINGS in nasm!',0Ah,0                         ; string to compare
lenm  equ $-msg                                            ; length of comparison string 

sim   db 'Strings are similar!',0Ah,0                      ; similar message
nsim  db 'Strings are not similar from position %d!',0Ah,0 ; not similar message

fstr  db 'Character was found at position %d!', 0Ah,0      ; found message
nfstr db 'Character was not found!', 0Ah,0                 ; not found message

section	 .bss

dest  resb BUFLEN                                          ; reserve space for destination string


section	.text

   global main                                             ; must be declared for using gcc
	
main:	                                                   ; tell linker entry point

;Demonstration of movs

      mov   esi, src                                       ; esi is set to the source string's address, movs will use this information
      mov   edi, dest                                      ; edi is set to the destination string's address, movs will use this information
      mov   ecx, len                                       ; ecx is set to the length of the source string, rep will update this counter

      cld                                                  ; clear the DF flag, so esi and edi will be decremented after movs operation
  rep movsb                                                ; repeat the movsb operation until ecx is 0 

      push  dword dest	                                   ; message to write, we use the destination string's address here 
      call  printf
      add   esp, 4 
	
;Demonstration of cmps

      mov   esi, src                                       ; esi is set to the source string's address, movs will use this information
      mov   edi, msg                                       ; edi is set to the destination string's address, movs will use this information
      mov   ecx, len                                       ; ecx is set to the length of the source string, rep will update this counter

  
      cld                                                  ; clear the DF flag, so esi and edi will be decremented after cmps operation
 repe cmpsb                                                ; repeat the cmpsb operation until ecx is 0 or ZF is 0, whichever occurs first
      jecxz similar                                        ; jump when ecx is zero


      mov   ebx, len                                       ; determine actual position 
      sub   ebx, ecx         
      push  ebx                                            ; if the strings are not the same, print out the appropriate message 
      push  dword nsim	                                   ; message to write, we use the message's address here 
      call  printf                                         ; call printf to print the message
      add   esp, 8                                         ; pop/update the top of stack

      jmp   next1
	
similar:

      push  dword sim                                      ; if the strings are similar, print the appropriate message 
      call  printf                                         ; call printf to print the message
      add   esp, 4                                         ; pop/update the top of stack

next1:
;Demonstartion of scas

      mov   al,  'n'                                       ; the character to find in the string
      mov   ecx, len                                       ; the length of the string
      mov   edi, dest                                      ; the address of the string

      cld                                                  ; clear the DF flag, so esi and edi will be decremented after cmps operation
repne scasb                                                ; repeat the scasb instruction until ecx is 0 or ZF is 1, whichever occurs first
      je found                                             ; when character in AL is found, jump to print appropriate message
                                                           
      push  dword nfstr                                    ; If not not found, print appropriate message 
      call  printf                                         ; call printf to print the message
      add   esp, 4                                         ; pop/update the top of stack

      jmp   next2

found:
      
      mov   ebx, len                                       ; determine actual position
      sub   ebx, ecx
      push  ebx                                            ; position at which character was found
      push  dword fstr                                     ; if found, print appropriate message
      call  printf                                         ; call printf to print the message
      add   esp, 8                                         ; pop/update the top of stack

 
next2:    
;Demonstration of lods and stos

      mov   esi, src                                       ; esi is set to the source string's address, movs will use this information
      mov   edi, dest                                      ; edi is set to the destination string's address, movs will use this information
      mov   ecx, len                                       ; ecx is set to the length of the source string, rep will update this counter

     
loopstr:

      lodsb                                                ; load the character into AL from ESI:DS
      or    al, 20h                                        ; convert the case 
      stosb                                                ; store the character from AL into EDI:ES
      loop  loopstr	                                   ; loop over the instructions
   
      mov   byte [edi-2], 0Ah                              ; fix the linefeed character
      mov   byte [edi-1], 0                                ; fix the null character for C function call

      push  dword dest                                     ; message to write, we use the destination string's address here 
      call  printf
      add   esp, 4 	

exit:
      mov   eax,SYS_EXIT	                           ; system call number (sys_exit)
      int   80h	                                           ; call kernel
	
