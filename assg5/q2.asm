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
j:resd 1
yes_pall:resb 1

section .data
str2:times 300 db 0
size:dd 20
spa:dd 32
nw:db 0Ah
inp_msg:db 'Enter input string: '
inp_len:equ $-inp_msg
out_msg:db 'Output: '
out_len:equ $-out_msg
no_msg:db 'No'
no_len:equ $-no_msg
yes_msg:db 'Yes'
yes_len:equ $-yes_msg
yes:dd 0

section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str1
call inp_str


mov ecx,out_msg
mov edx,out_len
call print_msg

call print_new_line

mov dword[i],0
mov ebx,str1
cld

manip:
mov ebx,str1
mov eax,[i]
mov [j],eax
inc dword[j]
mov ecx,ebx
add ecx,[i]
mov [sta_sub],ecx
inner_manip:
mov ebx,str1
mov eax,[j]
mov ecx,ebx
add ecx,eax
mov [end_sub],ecx


call is_pall

pusha
cmp dword[yes_pall],1
je print_yes
popa
return:


inc dword[j]
mov eax,[j]
cmp eax,[noc]
jb inner_manip

inc dword[i]
mov eax,[i]
cmp eax,[noc]
jb manip


cmp dword[yes],0
jne skip_print_yes

mov ecx,no_msg
mov edx,no_len
call print_msg

call print_new_line
jmp skip_print_yes

print_yes:
cmp dword[yes],0
jne skip_msg
mov ecx,yes_msg
mov edx,yes_len
call print_msg
call print_new_line
skip_msg:
mov esi,[sta_sub]
cld

print_req:
lodsb

mov [ele],al
mov eax,4
mov ebx,1
mov ecx,ele
mov edx,1
int 80h

cmp esi,[end_sub]
jbe print_req
call print_new_line
inc dword[yes]
jmp return

skip_print_yes:

mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;;;;;;;;;
is_pall:
pusha
mov esi,[sta_sub]
mov edi,[end_sub]
cld
inner_is_pall:
cmpsb
jne not_pall

sub edi,2
cmp esi,[end_sub]
jbe inner_is_pall

mov dword[yes_pall],1

jmp skip_not_pall

not_pall:
mov dword[yes_pall],0

skip_not_pall:
popa
ret
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
