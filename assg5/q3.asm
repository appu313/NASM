section .bss
str1:resb 300
noc:resd 1
ele:resd 1
num:resd 1
nod:resd 1
dig:resd 1
end_sub:resd 1
sta_sub:resd 1
i:resd 1

section .data
str2:times 300 db 0
size:dd 20
spa:dd 32
nw:db 0Ah
inp_msg:db 'Enter input string: '
inp_len:equ $-inp_msg
out_msg:db 'Enter output string: '
out_len:equ $-out_msg

section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str1
call inp_str

mov esi,str1
add esi,[noc]
dec esi
std
mov ecx,[noc]
mov dword[end_sub],esi

manip:
lodsb
cmp al,32
jne proceed
mov ebx,esi
inc ebx
inc ebx
mov dword[sta_sub],ebx
push esi
call ins_str
pop esi
std
dec ebx
dec ebx
mov dword[end_sub],ebx
proceed:
loop manip

mov dword[sta_sub],str1
call ins_str

mov ecx,out_msg
mov edx,out_len
call print_msg

mov esi,str2
call out_str

mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;;;;;;;;;;
print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
print_new_line:
pusha
mov eax,4
mov ebx,1
mov ecx,nw
mov edx,1
int 80h
popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
print_space:
pusha
mov eax,4
mov ebx,1
mov ecx,spa
mov edx,1
int 80h
popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
out_arr:
pusha
mov esi,str2
cld
mov dword[i],0

inner_out_arr:
lodsb

mov [num],al
call out_num

call print_space

inc dword[i]
mov eax,dword[i]
cmp eax,[size]
jb inner_out_arr

popa
ret



;;;;;;;;;;;;;;;;;;
ins_str:
pusha


mov esi,str2
cld
inner_ins_str:
lodsb
cmp al,0
je exit_inner_ins_str
jmp inner_ins_str

exit_inner_ins_str:
dec esi



mov edi,esi

outer_ins_str:
mov ebx,[sta_sub]
mov al,[ebx]
stosb

inc dword[sta_sub]
mov eax,[sta_sub]
cmp eax,[end_sub]
jbe outer_ins_str

mov al,32
stosb
popa
ret
;;;;;;;;;;;;;;;;;;;
out_str:
pusha
cld
inner_out_str:
lodsb

cmp al,0
je exit_inner_out_str

mov [ele],al

mov eax,4
mov ebx,1
mov ecx,ele
mov edx,1
int 80h

jmp inner_out_str

exit_inner_out_str:

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
mov [num],eax
inc dword[nod]
push edx

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
;;;;;;;;;;;;;;;;
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
je exit_inner_inp_str

mov al,[ele]
stosb
inc dword[noc]

jmp inner_inp_str

exit_inner_inp_str:
mov al,0
stosb
popa
ret
