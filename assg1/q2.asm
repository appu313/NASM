section .bss
num:resb 10
sum:resb 10
res1:resb 10
res2:resb 10
junk:resb 10

section .text
global _start:
_start:

mov eax,3
mov ebx,0
mov ecx,num
mov edx,1
int 80h 

mov eax,3
mov ebx,0
mov ecx,junk
mov edx,1
int 80h 

sub byte[num],30h
mov byte[sum],0

for:
mov al,byte[num]
add [sum],al
dec byte[num]
cmp byte[num],0
jnz for

mov bl,10
mov ax,word[sum]
div bl

cmp al,0
jz if

else:
mov [res1],al
mov [res2],ah

add byte[res1],30h
add byte[res2],30h

mov eax,4
mov ebx,1
mov ecx,res1
mov edx,1
int 80h

mov eax,4
mov ebx,1
mov ecx,res2
mov edx,1
int 80h

jmp l2

if:
mov [res2],ah
add byte[res2],30h

mov eax,4
mov ebx,1
mov ecx,res2
mov edx,1
int 80h

l2:

mov eax,1
mov ebx,0
int 80h


