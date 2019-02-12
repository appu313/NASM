section .bss
str:resb 300
str_len:resb 1
ele:resb 1
noc:resd 1
nod:resd 1
dig:resd 1
num:resd 1


section .data
inp_msg:db 'Enter string :',10
inp_len:equ $-inp_msg
is_msg:db 'It is a pallindrome',10
is_len:equ $-is_msg
not_msg:db 'It is NOT a pallindrome',10
not_len:equ $-not_msg
section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

call inp_str

mov esi,str
mov edi,str
add edi,[noc]
dec edi
cld 

manip:

cmpsb
jne not_pall

sub edi,2
dec dword[noc]
cmp dword[noc],0
jne manip

mov ecx,is_msg
mov edx,is_len
call print_msg

jmp skip_not_pall

not_pall:
mov ecx,not_msg
mov edx,not_len
call print_msg

skip_not_pall:

mov eax,1
mov ebx,0
int 80h

;;;;;;;;;;;;;;;;;;;
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
mov esi,str
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
mov edi,str
mov dword[noc],0
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
