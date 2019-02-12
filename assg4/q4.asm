section .bss
str:resb 400
noc:resd 1
ele:resb 1

section .data
nw:db 10
nw_len:equ $-nw
inp_msg:db 'Enter string:'
inp_len:equ $-inp_msg
out_msg:db 'Encrypted string:'
out_len:equ $-out_msg

section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str
call inp_str

mov esi,str
mov edi,str
cld
manip:
lodsb
cmp al,0
je end_manip
cmp al,32
je skip_enc                ;;;;;;;prevents the encryption of space

inc al
skip_enc:
stosb 
jmp manip

end_manip:

mov ecx,out_msg
mov edx,out_len
call print_msg


mov esi,str
call out_str

mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;;;
print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret
;;;;;;;;;;;;;;;;
print_new_line:
pusha
mov eax,4
mov ebx,1
mov ecx,nw
mov edx,nw_len
int 80h
popa
ret
;;;;;;;;;;;;;;;
out_str:
pusha
cld
inner_out_str:
lodsb
mov [ele],al

cmp dword[ele],0
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

;;;;;;;;;;;;;;;
inp_str:
pusha
cld
mov dword[noc],0
inner_inp_str:

mov eax,3
mov ebx,0
mov ecx,ele
mov edx,1
int 80h

cmp dword[ele],10
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
