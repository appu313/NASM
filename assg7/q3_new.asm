section .bss
n:resd 1
i:resd 1
j:resd 1
b:resd 1
a:resd 1
c:resd 1
min:resd 1
temp:resd 1
arr:resd 20

section .text
global main
extern printf
extern scanf

print:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp-8]
push format2
call printf
mov esp, ebp
pop ebp
ret

scan:
push ebp
mov ebp,esp
sub esp,8
lea eax,[esp]
push eax
push fmt1
call scanf
fld qword[ebp-8]     ;;if we give esp instead of ebp -8 gives junk val:::only ebp-8 is valid
mov esp,ebp
pop ebp
ret
;;;;;;;;;;;;;;;;;;;
print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret
;;;;;;;;;;;;;;;
print_new_line:
pusha
mov eax,4
mov ebx,1
mov ecx,nw
mov edx,1
int 80h
popa
ret

main:

mov ecx,msg_n
mov edx,n_len
call print_msg

pusha
call scan
popa

mov ecx,msg_inp
mov edx,inp_len
call print_msg

fist dword[n]
mov ecx,[n]

ffree
mov esi,arr

inp_arr:
ffree
pusha
call scan
popa
fstp dword[temp]
mov eax,[temp]
mov [esi],eax
add esi,4
loop inp_arr

;;;;;;;;;;;;;;;;;;;;;;;;
call print_new_line

mov dword[i],0
mov esi,arr

sort:

ffree st0
ffree st1
ffree
mov eax,[i]
mov [min],eax
mov dword[j],eax
inc dword[j]

mov eax,[min]
mov ecx,[esi+4*eax]
mov [c],ecx

inner_sort:

ffree st0
ffree st1
ffree

mov eax,[min]
mov ecx,[esi+4*eax]
mov [b],ecx
fld dword[b]

mov eax,[j]
mov ebx,[esi+4*eax]
mov [a],ebx
fld dword[a]

pusha
;;call print
popa

pusha
fcomi st1
popa

jae do_not_update_min

pusha
mov eax,[j]
mov [min],eax
fst dword[c]
popa

do_not_update_min:

ffree st0
ffree st1
ffree
inc dword[j]
mov eax,[j]
cmp eax,[n]
jb inner_sort

;;ffree


mov eax,[i]
mov ebx,[esi+4*eax]
mov [a],ebx
pusha
fld dword[a]
popa

mov eax,[min]
pusha
fstp dword[esi+4*eax]
popa

pusha
fld dword[c]
popa

mov eax,[i]
pusha
fstp dword[esi+4*eax]
popa

ffree st0
ffree st1
ffree
inc dword[i]
mov eax,[n]
dec eax
cmp [i],eax
jb sort


;;;;;;;;;;;;;;;;;;;;;;;;

call print_new_line

mov ecx,msg_res
mov edx,res_len
call print_msg

mov ecx,[n]

ffree

mov esi,arr
out_arr1:
mov eax,[esi]
mov [temp],eax
fld dword[temp]
pusha
call print
popa
add esi,4
ffree
loop out_arr1


jmp skip_exit

exit:

mov ecx,err_msg
mov edx,err_len
call print_msg

skip_exit:
mov eax,1
mov ebx,0
int 80h

section .data
const_4:dd 4
const_2:dd 2
nw:dd 10
pat:dd '*'
msg_n:db "Enter the number of elements :",10
n_len:equ $-msg_n
msg_inp:db "Enter the elements:",10
inp_len:equ $-msg_inp
msg_res:db "Sorted array :",10
res_len:equ $-msg_res
err_msg:db "Error",10
err_len:equ $-err_msg
fmt1:db "%lf",0
format2: db "%lf",10
