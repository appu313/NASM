section .data
rc_msg:db 'Enter no of rows and columns',10
rc_len:equ $-rc_msg
err_msg:db 'ERROR',10
err_len:equ $-err_msg
inp_mat_msg:db 'Enter the elements',10
inp_mat_len:equ $-inp_mat_msg
op_mat_msg:db 'OUTPUT',10
op_mat_len:equ $-op_mat_msg
space:db ' '
nw:db 10

section .bss
n:resd 1
num:resd 1
dig:resb 1
nod:resd 1
matrix:resd 50
row:resd 1
col:resd 1
i:resd 1
j:resd 1
flag:resb 1



section .text
global _start:
_start:

mov ecx,rc_msg
mov edx,rc_len
call print_msg

call input_no
mov eax,[num]
mov [row],eax
cmp dword[row],0
je error



call input_no
mov eax,[num]
mov [col],eax
cmp dword[col],0
je error

mov ecx,inp_mat_msg
mov edx,inp_mat_len
call print_msg

call input_matrix


mov ecx,op_mat_msg
mov edx,op_mat_len
call print_msg

mov dword[i],0
mov dword[j],0
mov dword[flag],0
mov ebx,matrix


manip:

inner_manip:
mov eax,[i]
mov ecx,[col]
mul ecx
add eax,[j]

mov ecx,[ebx+4*eax]
mov [num],ecx
call output_no
call print_space

cmp byte[flag],0
je if

else:
dec dword[j]
cmp dword[j],-1
jnz inner_manip

inc dword[j]
mov dword[flag],0
jmp exit_inner_manip

if:
inc dword[j]
mov eax,dword[j]
cmp eax,[col]
jne inner_manip

dec dword[j]
mov dword[flag],1

exit_inner_manip:
inc dword[i]
mov eax,dword[i]
cmp eax,[row]
jne manip



jmp ne

error:

	mov ecx, err_msg
	mov edx, err_len
call print_msg

ne:
mov eax,1
mov ebx,0
int 80h
;;;;;;;;;;;;;;INPUT NUMBER
input_no:
pusha
mov dword[num],0

inner_input_no:
mov eax,3
mov ebx,0 
mov ecx,dig
mov edx,1
int 80h



cmp byte[dig],10
je end_input_no


sub byte[dig],30h
mov eax,[num]
mov ebx,10
mul ebx
add eax,dword[dig]
mov [num],eax

jmp inner_input_no
end_input_no:

popa

ret

;;;;;;;PRINT NUMBER
output_no:
pusha 
mov dword[nod],0
cmp dword[num],0
je printzero

extract_no:
;inc dword[nod]            ;try changing the pos
mov edx,0
mov eax,[num]
mov ebx,10
div ebx
mov [num],eax
push edx
inc dword[nod]            
cmp dword[num],0
ja extract_no

print_no:
pop edx
mov [dig],dl 

add byte[dig],30h
mov eax,4 
mov ebx,1
mov ecx,dig
mov edx,1
int 80h

dec dword[nod]
cmp dword[nod],0
ja print_no

jmp end_output_no

printzero:
mov byte[nod],1
mov edx,[num]
push edx
jmp print_no

end_output_no:
popa
ret

;;;;;;;;;;;;;;;;;READING A MATRIX
input_matrix:
pusha

mov ebx,matrix
mov dword[i],0

outer_input_matrix:
mov dword[j],0

inner_input_matrix:

call input_no
mov eax,[num]
mov [ebx],eax



add ebx,4
inc dword[j]
mov eax,dword[j]
cmp eax,[col]
jb inner_input_matrix

inc dword[i]
mov eax,[i]
cmp eax,[row]
jb outer_input_matrix

popa
ret

;;;;;;;;;;;;;;;;;PRINTING A MATRIX
output_matrix:
pusha

mov ebx,matrix
mov dword[i],0

outer_output_matrix:
mov dword[j],0

inner_output_matrix:

mov eax,[ebx]
mov [num],eax
call output_no

push ebx
call print_space
pop ebx

add ebx,4
inc dword[j]
mov eax,[j]
cmp eax,[col]
jb inner_output_matrix

call print_new_line

inc dword[i]
mov eax,[i]
cmp eax,[row]
jb outer_output_matrix

popa
ret

;;;;;;;;;;;;;;PRINT MESSAGE
print_msg:
mov eax,4
mov ebx,1
int 80h
ret

;;;;;;;;;;;;;;;;;;PRINTING SPACE
print_space:
pusha
mov ecx,space
mov edx,1
call print_msg
popa
ret

;;;;;;;;;;;;;;;;;;PRINTING A NEW LINE
print_new_line:
pusha 
mov ecx,nw
mov edx,1
call print_msg
popa
ret



