section .bss
num:resd 1
dig:resd 1
nod:resd 1
arr:resd 10
res:resd 1

section .text
inp_msg:db 'Enter 10 numbers:',10
inp_len:equ $-inp_msg
out_msg:db 'Sum of squares:',10
out_len:equ $-out_msg
nw:dd 10

section .data
global _start:
_start:

;;call inp_num
;;call out_num

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,arr
call inp_arr

call sum_squares

mov ecx,out_msg
mov edx,out_len
call print_msg

mov eax,[res]
mov [num],eax
call out_num

call print_new_line

mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;;
sum_squares:
pusha
cld

mov dword[res],0
mov esi,arr
mov ecx,10

inner_sum_squares:
lodsd

mov ebx,eax
mul ebx
add [res],eax

loop inner_sum_squares

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

;;;;;;;;;;;;;;;
inp_arr:
pusha
cld
mov ecx,10

inner_inp_arr:
call inp_num
mov eax,[num]

stosd

loop inner_inp_arr

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
