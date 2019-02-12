section .bss
num:resd 1
dig:resd 1
nod:resd 1
n:resd 1
res:resd 1

section .text
inp_msg:db 'Enter value of n:',10
inp_len:equ $-inp_msg
out_msg:db 'Result:',10
out_len:equ $-out_msg
nw:dd 10 
spa :dd 32

section .data
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg


call inp_num
mov eax,[num]
mov [n],eax

call conv_funct

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
conv_funct:
pusha
cmp dword[n],0
je ret_zero

dec dword[n]
popa
call conv_funct
pusha

mov eax,[n]
add eax,[res]
mov [res],eax

jmp skip_ret_zero


ret_zero:
mov dword[res],0
skip_ret_zero:
inc dword[n]
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

;;;;;;;;;;;;;;;
conv_funct1:
pusha
cmp dword[n],0
je ret_zero1

dec dword[n]
popa
mov eax,[n]
inc eax
push eax
call conv_funct1
pop eax
pusha

;;mov eax,[n]
add eax,[res]
mov [res],eax

jmp skip_ret_zero1


ret_zero1:
mov dword[res],0
skip_ret_zero1:
inc dword[n]
popa
ret
;;;;;;;;;;;;;;;
conv_funct2:
cmp dword[n],0
je ret_zero2
mov eax,[n]
push eax
dec dword[n]

call conv_funct2
pop eax

add eax,[res]
mov [res],eax

jmp skip_ret_zero2


ret_zero2:
mov dword[res],0
skip_ret_zero2:

ret

