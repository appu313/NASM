section .bss
a:resd 1
b:resd 1
array:resd 50
n:resd 1
temp:resd 1
ele:resb 10
num:resd 1
dig:resb 1
nod:resd 1

section .data
msg1:db ' '
s1:equ $-msg1
msg2:db 'Error',10
s2:equ $-msg2

section .text
global _start:
_start:

call input_number

mov eax,[num]
mov [n],eax
cmp dword[n],0
jz error
	
call input_number

mov eax,[num]
mov [a],eax
cmp byte[a],0
jz error

call input_number

mov eax,[num]
mov [b],eax
cmp byte[b],0
jz error

mov ebx,array
mov eax,dword[n]
mov dword[temp],eax

reading:
push ebx

call input_number

mov eax,[num]
mov [ele],eax

pop ebx

mov dword[ebx],eax
add ebx,4
dec byte[temp]
cmp byte[temp],0
ja reading


mov ebx,array
mov eax,dword[n]
mov dword[temp],eax

check:
mov eax,dword[ebx]
mov dword[ele],eax
push ebx

mov eax,[ele]
mov edx,0
mov ebx,[a]
div ebx

cmp edx,0
jnz end

mov eax,[ele]
mov ebx,[b]
div ebx

cmp edx,0
jnz end

mov eax,[ele]
mov [num],eax

call print_number

	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, s1
	int 80h

end:
pop ebx
add ebx,4
dec dword[temp]
cmp dword[temp],0
ja check

jmp ne

error:
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, s2
	int 80h

ne:
mov eax,1
mov ebx,0
int 80h

;;;SUB PROGRAMS
input_number:
pusha
mov dword[num],0

inner_loop:
mov eax,3
mov ebx,0 
mov ecx,dig
mov edx,1
int 80h



cmp byte[dig],10
je end_input


sub byte[dig],30h
mov eax,[num]
mov ebx,10
mul ebx
add eax,dword[dig]
mov [num],eax

jmp inner_loop
end_input:

popa

ret


print_number:
pusha 
mov dword[nod],0
cmp dword[num],0
je printzero

extract_no:
;inc dword[nod]            ;try changing the pos
mov edx,0
mov eax,[num]
mov ebx,10
div ebx
mov [num],eax
push edx
inc dword[nod]            
cmp dword[num],0
ja extract_no

print_no:
pop edx
mov [dig],dl 

add byte[dig],30h
mov eax,4 
mov ebx,1
mov ecx,dig
mov edx,1
int 80h

dec dword[nod]
cmp dword[nod],0
ja print_no

jmp end_print

printzero:
mov byte[nod],1
mov edx,[num]
push edx
jmp print_no

end_print:
popa
ret
