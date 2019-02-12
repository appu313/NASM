section .bss
k:resd 1
n:resd 1
i:resd 1
j:resd 1
b:resd 1
a:resd 1
temp:resd 1
arr:resd 20

section .text
global main
extern printf
extern scanf

print_op_bracket:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp-8]
push fmt3
call printf
mov esp, ebp
pop ebp
ret

print_cl_bracket:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp-8]
push fmt4
call printf
mov esp, ebp
pop ebp
ret


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

;;;;;;;;;;;;;;;
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

mov ecx,msg_k
mov edx,k_len
call print_msg

call scan
fstp dword[k]
ffree st0
ffree st1
ffree

mov ecx,msg_n
mov edx,n_len
call print_msg

call scan
fist dword[n]
ffree st0
ffree st1
ffree

mov ecx,msg_inp
mov edx,inp_len
call print_msg
;;;;;;;;;;;;;;;;;;
mov ecx,[n]

ffree st0
ffree st1
ffree
mov esi,arr

inp_arr:

ffree st0
ffree st1
ffree
pusha
call scan
popa
fstp dword[temp]
mov eax,[temp]
mov [esi],eax
add esi,4
loop inp_arr

;;;;;;;;;;;;;;;;;;
mov ecx,msg_res
mov edx,res_len
call print_msg

mov dword[i],0
mov esi,arr

manip:
ffree
ffree st0
ffree st1
mov eax,[i]
mov [j],eax
inc dword[j]

inner_manip:
ffree
ffree st0
ffree st1

mov eax,[i]
mov ebx,[esi+4*eax]
mov [a],ebx
fld dword[a]

mov eax,[j]
mov ebx,[esi+4*eax]   ;;st0,st1,st2,st3,st4
mov [b],ebx
fld dword[b]

fadd st1
fld dword[k]
fcomi st1
jne do_not_print

fld dword[a]
call print_op_bracket
fld dword[b]
call print_cl_bracket

do_not_print:


ffree
ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7


inc dword[j]
mov eax,[j]
cmp eax,[n]
jb inner_manip


ffree
ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7
inc dword[i]
mov eax,[i]
mov ebx,[n]
dec ebx
cmp eax,ebx
jb manip
;;;;;;;;;;;;;;;;;;

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
nw:dd 10
msg_k:db "Enter value of k :",0
k_len:equ $-msg_k
msg_n:db "Enter the number of elements :",0
n_len:equ $-msg_n
msg_inp:db "Enter the elements:",10
inp_len:equ $-msg_inp
msg_res:db "Result :",10
res_len:equ $-msg_res
err_msg:db "Error",10
err_len:equ $-err_msg
fmt1:db "%lf",0
format2: db "%lf",10
fmt3:db "(%lf ",0
fmt4:db "%lf)",10
