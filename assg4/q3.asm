section .bss
str1:resb 300
str_len:resb 1
ele:resb 1
noc:resd 1
str2:resb 30

section .data
inp_msg:db 'Enter string :',10
inp_len:equ $-inp_msg
out_msg:db 'Output string :'
out_len:equ $-out_msg
nw:db 10
nw_len:equ $-nw

section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str1
call inp_str

;mov esi,str1
;call out_str

mov edi,str2
mov esi,str1
cld

manip:
lodsb

mov [ele],al

cmp al,'a'  
je skip_copy
cmp al,'A'
je skip_copy
cmp al,'i'
je skip_copy
cmp al,'I'
je skip_copy


dec esi
movsb 

skip_copy:
cmp al,0
jne manip


mov ecx,out_msg
mov edx,out_len
call print_msg

mov esi,str2
call out_str

call print_new_line

mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;;;;;;
print_new_line:
pusha
mov eax,4
mov ebx,1
mov ecx,nw
mov edx,nw_len
int 80h
popa
ret
;;;;;;;;;;;;;;;;;;;
print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret
;;;;;;;;;;;;;;;;;;;
out_str:
pusha
cld

inner_out_str:
lodsb
mov [ele],al

cmp byte[ele],0
je end_inner_out_str

mov eax,4
mov ebx,1
mov ecx,ele
mov edx,1
int 80h

jmp inner_out_str

end_inner_out_str:

popa
ret

;;;;;;;;;;;;;;;;;;;
inp_str:
pusha

cld

inner_inp_str:

mov eax,3
mov ebx,0
mov ecx,ele
mov edx,1
int 80h

cmp byte[ele],10
je end_inner_inp_str

mov al,[ele]
stosb
inc dword[noc]
jmp inner_inp_str

end_inner_inp_str:

mov al,0
stosb

popa
ret
