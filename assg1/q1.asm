section .text
global _start:
_start:

mov byte[a],1
mov byte[b],1

add byte[a],30h
mov eax,4
mov ebx,1
mov ecx,a
mov edx,1
int 80h
sub byte[a],30h

add byte[b],30h
mov eax,4
mov ebx,1
mov ecx,b
mov edx,1
int 80h
sub byte[b],30h

mov byte[j],3

for:
mov al,byte[a]
mov bl,byte[b]
add al,bl
mov byte[a],bl
mov byte[b],al

add byte[b],30h
mov eax,4
mov ebx,1
mov ecx,b
mov edx,1
int 80h
sub byte[b],30h

dec byte[j]
cmp byte[j],0
jnz for

mov eax,1
mov ebx,0
int 80h

section .bss
a:resb 10
b:resb 10
j:resb 10
