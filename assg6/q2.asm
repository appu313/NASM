section .bss
num:resd 1
dig:resd 1
nod:resd 1
fiboterm1:resd 1
fiboterm2:resd 1
n:resd 1

section .text
inp_msg:db 'Enter value upto which the fibonacci has to be printed:',10
inp_len:equ $-inp_msg
out_msg:db 'Result:',10
out_len:equ $-out_msg
spa:db 32
nw:dd 10

section .data
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

call inp_num
mov eax,[num]
mov [n],eax

mov ecx,out_msg
mov edx,out_len
call print_msg

mov dword[fiboterm1],0
mov dword[fiboterm2],1

call contd

call print_new_line
mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;
contd:
pusha

mov eax,[fiboterm1]
mov [num],eax
call out_num
call print_space

popa
call fibo
;;;;;;;;;;;;;;;
fibo:
pusha

mov eax,[n]
cmp dword[fiboterm2],eax
ja exit_fibo

mov eax,[fiboterm1]
mov ebx,[fiboterm2]
mov [fiboterm1],ebx
add eax,ebx
mov [fiboterm2],eax
popa
jmp contd

exit_fibo:
popa
ret
;;;;;;;;;;;;;;;
print_new_line:
pusha
mov eax,4
mov ebx,1
mov ecx,nw
mov edx,1
int 80h
popa
ret
;;;;;;;;;;;;;;;
print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret

;;;;;;;;;;;;;;
print_space:
pusha
mov eax,4
mov ebx,1
mov ecx,spa
mov edx,1
int 80h
popa
ret

;;;;;;;;;;;;;;;
inp_num:
pusha
mov dword[num],0

inner_inp_num:

mov eax,3
mov ebx,0
mov ecx,dig
mov edx,1
int 80h

cmp dword[dig],10
je exit_inner_inp_num

cmp dword[dig],32
je exit_inner_inp_num

sub dword[dig],30h
mov eax,[num]
mov ebx,10
mul ebx
add eax,[dig]
mov [num],eax

jmp inner_inp_num

exit_inner_inp_num:
popa
ret
;;;;;;;;;;;;;;;
out_num:
pusha
mov dword[nod],0

inner_out_num:

mov eax,[num]
mov edx,0
mov ebx,10
div ebx
push edx
mov [num],eax
inc dword[nod]

cmp eax,0
jne inner_out_num

outer_out_num:
pop edx
add edx,30h

mov [dig],edx
mov eax,4
mov ebx,1
mov ecx,dig
mov edx,1
int 80h

dec dword[nod]
cmp dword[nod],0
jne outer_out_num

popa
ret


