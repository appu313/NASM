section .data
rc1_msg:db 'Enter no of rows and columns of matrix 1',10
rc1_len:equ $-rc1_msg
rc2_msg:db 'Enter no of rows and columns of matrix 2',10
rc2_len:equ $-rc2_msg
err_msg:db 'ERROR',10
err_len:equ $-err_msg
inp_mat_msg:db 'Enter the elements',10
inp_mat_len:equ $-inp_mat_msg
op_mat_msg:db 'OUTPUT',10
op_mat_len:equ $-op_mat_msg
space:db ' '
nw:db 10
inv_msg:db 'Invalid rows and columns for multiplication',10
inv_len:equ $-inv_msg
mat1_disp:db 'MATRIX 1',10
mat1_len:equ $-mat1_disp
mat2_disp:db 'MATRIX 2',10
mat2_len:equ $-mat2_disp

section .bss
n:resd 1
num:resd 1
dig:resb 1
nod:resd 1
matrix1:resd 50
matrix2:resd 50
row1:resd 1
col1:resd 1
row2:resd 1
col2:resd 1
i:resd 1
j:resd 1
k:resd 1
flag:resb 1
val1:resd 1
val2:resd 1
index:resd 1
res:resd 1


section .text
global _start:
_start:

mov ecx,rc1_msg
mov edx,rc1_len
call print_msg

call input_no
mov eax,[num]
mov [row1],eax
cmp dword[row1],0
je error

call input_no
mov eax,[num]
mov [col1],eax
cmp dword[col1],0
je error


mov ecx,inp_mat_msg
mov edx,inp_mat_len
call print_msg

call input_matrix1

mov ecx,mat1_disp
mov edx,mat1_len
call print_msg


call output_matrix1

mov ecx,rc2_msg
mov edx,rc2_len
call print_msg

call input_no
mov eax,[num]
mov [row2],eax
cmp dword[row2],0
je error

call input_no
mov eax,[num]
mov [col2],eax
cmp dword[col2],0
je error


mov ecx,inp_mat_msg
mov edx,inp_mat_len
call print_msg

call input_matrix2

mov ecx,mat2_disp
mov edx,mat2_len
call print_msg


call output_matrix2

mov eax,[col1]
cmp eax,[row2]
jne print_invalid

call print_new_line

mov ecx,op_mat_msg
mov edx,op_mat_len
call print_msg

mov ebx,matrix1
mov ecx,matrix2

mov dword[i],0

multiplication:

mov dword[j],0

outer_multi:

mov dword[k],0

mov dword[res],0
inner_multi:

;push ebx
;mov eax,[index]
;mov ebx,[edx+4*eax]
;mov [res],ebx
;pop ebx

;push edx

mov eax,[i]
mov edx,[col1]
mul edx
add eax,[k]
mov edx,[ebx+4*eax]
mov [val1],edx

mov eax,[k]
mov edx,[col2]
mul edx
add eax,[j]
mov edx,[ecx+4*eax]
mov [val2],edx

mov eax,[val1]
mul edx
add eax,[res]
mov [res],eax

;pop edx
;push ebx

;mov ebx,[index]
;mov [edx+4*ebx],eax

inc dword[k]
mov eax,[k]
cmp eax,[col1]
jb inner_multi

mov eax,[res]
mov [num],eax
call output_no

call print_space

inc dword[j]
mov eax,[j]
cmp eax,[col2]
jb outer_multi

call print_new_line

inc dword[i]
mov eax,[i]
cmp eax,[row1]
jb multiplication



jmp ne

print_invalid:
	mov ecx, inv_msg
	mov edx, inv_len
call print_msg
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

;;;;;;;;;;;;;;;;;READING MATRIX1
input_matrix1:
pusha

mov ebx,matrix1

mov dword[i],0

outer_input_matrix1:
mov dword[j],0

inner_input_matrix1:

call input_no
mov eax,[num]
mov [ebx],eax



add ebx,4
inc dword[j]
mov eax,dword[j]
cmp eax,[col1]
jb inner_input_matrix1

inc dword[i]
mov eax,[i]
cmp eax,[row1]
jb outer_input_matrix1

popa
ret

;;;;;;;;;;;;;;;;;PRINTING A matrix1
output_matrix1:
pusha

mov ebx,matrix1
mov dword[i],0

outer_output_matrix1:
mov dword[j],0

inner_output_matrix1:

mov eax,[ebx]
mov [num],eax
call output_no

push ebx
call print_space
pop ebx

add ebx,4
inc dword[j]
mov eax,[j]
cmp eax,[col1]
jb inner_output_matrix1

call print_new_line

inc dword[i]
mov eax,[i]
cmp eax,[row1]
jb outer_output_matrix1

popa
ret

;;;;;;;;;;;;;;;;;READING MATRIX2
input_matrix2:
pusha

mov ebx,matrix2

mov dword[i],0

outer_input_matrix2:
mov dword[j],0

inner_input_matrix2:

call input_no
mov eax,[num]
mov [ebx],eax



add ebx,4
inc dword[j]
mov eax,dword[j]
cmp eax,[col2]
jb inner_input_matrix2

inc dword[i]
mov eax,[i]
cmp eax,[row2]
jb outer_input_matrix2

popa
ret

;;;;;;;;;;;;;;;;;PRINTING A matrix2
output_matrix2:
pusha

mov ebx,matrix2
mov dword[i],0

outer_output_matrix2:
mov dword[j],0

inner_output_matrix2:

mov eax,[ebx]
mov [num],eax
call output_no

push ebx
call print_space
pop ebx

add ebx,4
inc dword[j]
mov eax,[j]
cmp eax,[col2]
jb inner_output_matrix2

call print_new_line

inc dword[i]
mov eax,[i]
cmp eax,[row2]
jb outer_output_matrix2

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

