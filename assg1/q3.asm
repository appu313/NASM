section .text
global _start:
_start:

mov ax,1234h

cmp al,34h
jz if

else:
mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,s1
int 80h

jmp exit

if:
mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,s2
int 80h

exit:

mov eax,1
mov ebx,0
int 80h

section .data
msg1:db "Big Endian",0Ah
s1:equ $-msg1

msg2:db "Little Endian",0Ah
s2:equ $-msg2
