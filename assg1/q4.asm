section .bss
n11:resb 10
n12:resb 10
n21:resb 10
n22:resb 10
n31:resb 10
n32:resb 10
num1:resb 10
num2:resb 10
num3:resb 10
res1:resb 10
res2:resb 10
junk:resb 10

section .text
global _start:
_start:

mov eax,3
mov ebx,1
mov ecx,n11
mov edx,1
int 80h
sub byte[n11],30h

mov eax,3
mov ebx,0
mov ecx,n12
mov edx,1
int 80h
sub byte[n12],30h

mov eax,3
mov ebx,0
mov ecx,junk
mov edx,1
int 80h

mov eax,3
mov ebx,0
mov ecx,n21
mov edx,1
int 80h
sub byte[n21],30h

mov eax,3
mov ebx,0
mov ecx,n22
mov edx,1
int 80h
sub byte[n22],30h

mov eax,3
mov ebx,0
mov ecx,junk
mov edx,1
int 80h

mov eax,3
mov ebx,0
mov ecx,n31
mov edx,1
int 80h
sub byte[n31],30h

mov eax,3
mov ebx,0
mov ecx,n32
mov edx,1
int 80h
sub byte[n32],30h


mov eax,3
mov ebx,0
mov ecx,junk
mov edx,1
int 80h


mov al,10
mul byte[n11]
add al,byte[n12]
mov [num1],al




mov al,10
mul byte[n21]
add al,byte[n22]
mov [num2],al

mov al,10
mul byte[n31]
add al,[n32]
mov [num3],al

;mov ax,word[num3]
;mov bl,10
;div bl
;mov [res1],al
;mov [res2],ah
;add byte[res1], 30h
;	add byte[res2], 30h
;
;	mov eax, 4
;	mov ebx, 1
;	mov ecx, res1
;	mov edx, 1
;	int 80h
;
;	mov eax, 4
;;	mov ebx, 1
;	mov ecx, res2
;;	mov edx, 1
;	int 80h
;;
;	mov eax, 1
;	mov ebx, 0
;	int 80h



mov al,byte[num1]
mov bl,byte[num2]
mov cl,byte[num3]

cmp al,bl
ja if1

else1:
cmp bl,cl
ja if2

else2:
add byte[n31],30h
mov eax,4
mov ebx,1
mov ecx,n31
mov edx,1
int 80h

add byte[n32],30h
mov eax,4
mov ebx,1
mov ecx,n32
mov edx,1
int 80h

jmp exit

if2:
add byte[n21],30h
mov eax,4
mov ebx,1
mov ecx,n21
mov edx,1
int 80h

add byte[n22],30h
mov eax,4
mov ebx,1
mov ecx,n22
mov edx,1
int 80h

jmp exit

if1:
cmp al,cl

ja if3

else3:
add byte[n31],30h
mov eax,4
mov ebx,1
mov ecx,n31
mov edx,1
int 80h

add byte[n32],30h
mov eax,4
mov ebx,1
mov ecx,n32
mov edx,1
int 80h

jmp exit

if3:
add byte[n11],30h
mov eax,4
mov ebx,1
mov ecx,n11
mov edx,1
int 80h

add byte[n12],30h
mov eax,4
mov ebx,1
mov ecx,n12
mov edx,1
int 80h


exit:


mov eax,1
mov ebx,0
int 80h
