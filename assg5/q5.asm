section .bss
str1:resb 300
str2:resb 300
str3:resb 300
noc:resd 1
noc1:resd 1
noc2:resd 1
noc3:resd 1
ele:resd 1
num:resd 1
nod:resd 1
dig:resd 1
end_sub:resd 1
sta_sub:resd 1
found:resd 1

section .data
spa:dd 32
nw:db 0Ah
inp_msg:db 'Enter string:'
inp_len:equ $-inp_msg
rep_msg:db 'Enter the string to be replaced:'
rep_len:equ $-rep_msg
sub_msg:db 'Enter the string to be substituted:'
sub_len:equ $-sub_msg
out_msg:db 'Modified string is:'
out_len:equ $-out_msg

section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str1
call inp_str
mov eax,[noc]
mov [noc1],eax

mov ecx,rep_msg
mov edx,rep_len
call print_msg

mov edi,str2
call inp_str
mov eax,[noc]
mov [noc2],eax



mov ecx,sub_msg
mov edx,sub_len
call print_msg

mov edi,str3
call inp_str
mov eax,[noc]
mov [noc3],eax

mov ecx,out_msg
mov edx,out_len
call print_msg

mov esi,str1
mov edi,str2
mov dword[sta_sub],str1
mov ecx,[noc1]

cld

manip:
lodsb
cmp al,32
jne proceed

mov ebx,esi
dec ebx
dec ebx
mov [end_sub],ebx
call check

call print_req
mov [sta_sub],esi
call print_space

proceed:
loop manip

dec esi
mov [end_sub],esi
call check
;;mov eax,[found]
;mov [num],eax
;call out_num

call print_req

call print_new_line

mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;;;;;;
print_req:
pusha
cmp dword[found],0
jne sub

pusha
mov esi,[sta_sub]
print:
lodsb

mov [ele],al
mov eax,4
mov ebx,1
mov ecx,ele
mov edx,1
int 80h



cmp esi,[end_sub]
jbe print
popa



jmp exit_print_req
sub:
push esi
mov esi,str3
call out_str
pop esi

exit_print_req:
popa
ret
;;;;;;;;;;;;;;;;;;;;;;
check:

pusha


mov edi,[sta_sub]
mov esi,str2

mov ecx,[end_sub]
sub ecx,[sta_sub]
add ecx,1

inner_check:
cmpsb
jne deassert_found

loop inner_check

lodsb
cmp al,0
jne deassert_found

mov dword[found],1

jmp skip_deassert_found

deassert_found:
mov dword[found],0
skip_deassert_found:
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

