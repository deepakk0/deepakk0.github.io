; File: llfiles.asm 
;
; This code demonstrates low level file operations
; 
; Assemble using NASM:  nasm -g -f elf -F dwarf llfiles.asm
; Compile using gcc:    gcc -m32 llfiles.o -o llfiles
; Debug using gdb:      gdb -tui llfiles
;

%define SYS_OPEN  5
%define SYS_CLOSE 6
%define SYS_CREAT 8
%define SYS_READ  3
%define SYS_WRITE 4
%define SYS_EXIT  1
%define STDIN     0
%define STDOUT    1

;Access modes while opening a file

%define O_RDONLY  0
%define O_WRONLY  1
%define O_RDWR    2

;length of message to be written into file

%define BUFLEN    40


       section .data
filename  db 'myfile.txt',0                             ;name of the file
msg       db 'CMPE310-Low Level File Handling',0Ah      ;message to be written into file
len       equ  $-msg                                    ;length of message

mdone     db 'File write complete!',0Ah                 ;message to announce completion of file write
ldone     equ $-mdone                                   ;length of announcement message                            

       section .bss
fdwr      resd 1
fdrd      resd 1
dest      resb BUFLEN


       section .text
       global main                                      ;must be declared for using gcc
	
main:                                                   ;tell linker entry point
;create the file
   mov  eax, SYS_CREAT                                  ;system call to create a file
   mov  ebx, filename                                   ;specify the filename
   mov  ecx, 0700o                                      ;read, write and execute permissions for user 
   int  80h                                             ;call kernel
	
   mov  [fdwr], eax                                     ;file handle/pointer to file
    
;write message into the file
   mov  eax, SYS_WRITE                                  ;system call number (sys_write)
   mov  ebx, [fdwr]                                     ;file descriptor 
   mov  ecx, msg                                        ;message to write
   mov  edx, len                                        ;number of bytes
   int  80h                                             ;call kernel
	
;close the file
   mov  eax, SYS_CLOSE                                  ;system call to close the file
   mov  ebx, [fdwr]                                     ;specify file handle/pointer for writing
   int  80h                                             ;call kernel
    
;write the message announcing file write completion
   mov  eax, SYS_WRITE                                  ;system call number (sys_write)
   mov  ebx, STDOUT                                     ;standard output 
   mov  ecx, mdone                                      ;message to write
   mov  edx, ldone                                      ;number of bytes
   int  80h                                             ;call kernel
    
;open the file for reading
   mov  eax, SYS_OPEN                                   ;system call to open the file
   mov  ebx, filename                                   ;specify the filename
   mov  ecx, O_RDONLY                                   ;for read only access
   mov  edx, 0700o                                      ;read, write and execute permissions for user
   int  80h                                             ;call kernel
	
   mov  [fdrd], eax                                     ;store file handle/pointer for reading
    
;read from file
   mov  eax, SYS_READ                                   ;system call number (sys_read)
   mov  ebx, [fdrd]                                     ;file descriptor 
   mov  ecx, dest                                       ;message to read
   mov  edx, BUFLEN                                     ;number of bytes
   int  80h                                             ;call kernel
    
;close the file
   mov  eax, SYS_CLOSE                                  ;system call to close the file  
   mov  ebx, [fdrd]                                     ;specify file handle/pointer for reading
   int  80h                                             ;call kernel
	
;print the message that was read from the file
   mov  eax, SYS_WRITE                                  ;system call number (sys_write)
   mov  ebx, STDOUT                                     ;standard output 
   mov  ecx, dest                                       ;message to write
   mov  edx, BUFLEN                                     ;number of bytes
   int  80h                                             ;call kernel
       
   mov  eax,SYS_EXIT                                    ;system call number (sys_exit)
   int  80h                                             ;call kernel
