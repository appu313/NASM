section .bss
str:resb 300
noc:resd 1
ele:resd 1
num:resd 1
nod:resd 1
dig:resd 1
end_sub:resd 1
sta_sub:resd 1
i:resd 1

section .data
max_str:times 300 db 0
max_size:dd 20
size:dd 20
min_str:times 300 db 0
min_size:dd 20
spa:dd 32
nw:db 0Ah
inp_msg:db 'Enter input string: '
inp_len:equ $-inp_msg
min_msg:db 'Smallest length words: '
min_len:equ $-min_msg
max_msg:db 'Largest length words: '
max_len:equ $-max_msg
min:dd 300
max:dd 0

section .text
global _start:
_start:

mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str
call inp_str

mov esi,str
mov dword[sta_sub],esi
cld
mov ecx,[noc]

manip:
lodsb

cmp al,32
jne proceed

mov ebx,esi
dec ebx
dec ebx
mov dword[end_sub],ebx
push esi
mov eax,[sta_sub]
call is_min
mov [sta_sub],eax
call is_max
pop esi
mov dword[sta_sub],esi
proceed:
loop manip

dec esi
mov eax,[sta_sub]
mov dword[end_sub],esi
call is_min
mov [sta_sub],eax
call is_max

mov ecx,min_msg
mov edx,min_len
call print_msg

mov esi,min_str
call out_str

call print_new_line
mov ecx,max_msg
mov edx,max_len
call print_msg

mov esi,max_str
call out_str


mov eax,1
mov ebx,0
int 80h






;;;;;;;;;;;;;;;;;;;;;;;
is_max:
pusha
mov eax,dword[end_sub]
sub eax,dword[sta_sub]
add eax,1



cmp eax,[max]
jb exit_is_max

cmp eax,[max]
je add_max

mov [max],eax



mov edi,max_str
call reset_arr

push esi
mov esi,max_str
call ins_str
pop esi



jmp exit_is_max

add_max:

push esi
mov esi,max_str
call ins_str
pop esi

exit_is_max:



popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
out_arr:
pusha

cld
mov dword[i],0

inner_out_arr:
lodsb

mov [num],al
call out_num

call print_space

inc dword[i]
mov eax,dword[i]
cmp eax,[min_size]
jb inner_out_arr

popa
ret



;;;;;;;;;;;;;;;;;;
ins_str:
pusha


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
;;;;;;;;;;;;;;;;;;;;;;;;
is_min:
pusha

mov eax,dword[end_sub]
sub eax,dword[sta_sub]
add eax,1


cmp eax,[min]
ja exit_is_min

cmp eax,[min]
je add_min

mov [min],eax



mov edi,min_str
call reset_arr

push esi
mov esi,min_str
call ins_str
pop esi



jmp exit_is_min

add_min:

push esi
mov esi,min_str
call ins_str
pop esi

exit_is_min:



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
;;;;;;;;;;;;;;;;;;;;;;;
reset_arr:
pusha 
mov al,0
mov ecx,[size]
rep stosb
popa
ret
