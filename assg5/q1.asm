section .bss
ele:resd 10
cha:resd 10
str:resd 300
len:resd 1
nod:resd 1
dig:resd 1
num:resd 1
i:resd 1
;spa:resd 1


section .data
yes_upper:dd 1
yes_lower:dd 1
yes_alpha:dd 1
noc:dd 0
low_arr:dd 0,0,0,0,0,0,0,0,0,0
size:dd 10
nou:dd 0
yes_present:dd 0
max:dd 0
spa:dd 32
inp_msg:db 'Enter input:',10
inp_len:equ $-inp_msg
out_msg:db 'Number of distinct lowercase letters:'
out_len:equ $-out_msg
nw:db 0Ah

section .text
global _start:
_start:


mov ecx,inp_msg
mov edx,inp_len
call print_msg

mov edi,str
call inp_str

mov esi,str
cld
manip:
lodsb
cmp al,0
je exit_manip
mov [cha],al
call is_alpha
cmp dword[yes_alpha],0
je manip

call is_upper
cmp dword[yes_upper],0
je lower_case

cmp dword[nou],0
je begin
push esi

mov esi,low_arr
call find_len_of_arr

mov edi,low_arr
call reset_arr
pop esi

mov eax,[len]
cmp eax,[max]
jb same_max
mov [max],eax

same_max:
mov dword[nou],1
jmp manip

begin:
inc dword[nou]

jmp manip

lower_case:

mov eax,[cha]
mov [ele],eax
push esi
mov esi,low_arr
mov dword[yes_present],0
call is_present
pop esi


cmp dword[yes_present],1
je skip_insert



push esi
mov esi,low_arr
call ins_arr
pop esi

skip_insert:


jmp manip

exit_manip:

mov ecx,out_msg
mov edx,out_len
call print_msg

mov eax,[max]
mov [num],eax
call out_num

call print_new_line

mov eax,1
mov ebx,0
int 80h
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
print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
is_present:
pusha
 
cld
mov ecx,[size]

inner_is_present:          ;;;;;;;here the assumption is that yes_present is already 0 before entering the function
lodsb 
cmp [ele],al
je change_yes_present

dec ecx
cmp ecx,0
jne inner_is_present
jmp skip_change_yes_present

change_yes_present:
mov dword[yes_present],1
skip_change_yes_present:

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
;;;;;;;;;;;;;;;;;;;;;;;
ins_arr:
pusha
cld
inner_ins_arr:
lodsb 
cmp al,0
jne inner_ins_arr

dec esi
mov al,[ele]
mov [esi],al 

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
mov esi,low_arr
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


;;;;;;;;;;;;;;;;;;;;;;;
find_len_of_arr:
pusha 
mov dword[len],0
cld

inner_find_len_of_arr:
lodsb
cmp al,0                ;DONT'T FORGET TO KEEP 0 LAST
je exit_inner_find_len_of_arr

inc dword[len]
jmp inner_find_len_of_arr

exit_inner_find_len_of_arr:

popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
out_num:
pusha
mov dword[nod],0

inner_out_num:
mov eax,[num]
mov edx,0
mov ebx,10
div ebx
mov [num],eax
push edx
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
;;;;;;;;;;;;;;;;;;;;;;;
out_str:
pusha
cld

inner_out_str:
lodsb
mov [ele],al
cmp al,0
je exit_inner_out_str

mov eax,4
mov ebx,1
mov ecx,ele
mov edx,1
int 80h

jmp inner_out_str

exit_inner_out_str:
popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
inp_str:
pusha
cld
 
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
is_alpha:
pusha
call is_lower
cmp dword[yes_lower],1
je assert_yes_alpha
                                  
call is_upper
cmp dword[yes_upper],1
je assert_yes_alpha

mov dword[yes_alpha],0

jmp skip_assert_yes_alpha
assert_yes_alpha:
mov dword[yes_alpha],1
skip_assert_yes_alpha:
popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
is_lower:
pusha
cmp dword[cha],'a'
jb deassert_yes_lower
cmp dword[cha],'z'
ja deassert_yes_lower    

mov dword[yes_lower],1
jmp skip_deassert_yes_lower
deassert_yes_lower:
mov dword[yes_lower],0
skip_deassert_yes_lower:
popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
is_upper:
pusha
cmp dword[cha],'A'
jb deassert_yes_upper
cmp dword[cha],'Z'
ja deassert_yes_upper

mov dword[yes_upper],1
jmp skip_deassert_yes_upper
deassert_yes_upper:
mov dword[yes_upper],0
skip_deassert_yes_upper:
popa
ret
