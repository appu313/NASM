;;the correct one

section .bss
n:resd 1
fact_res:resd 1
num:resd 1
nod:resd 1
dig:resd 1
x:resd 1
x_pow:resd 1
is_neg:resd 1
den:resd 1
res:resd 1

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
;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;
fact:
pusha

mov ecx,[n]
mov dword[fact_res],1

inner_fact:
mov eax,[n]
mul dword[fact_res]
mov [fact_res],eax
dec dword[n]
mov eax,[n]
cmp dword[n],0
jne inner_fact

popa
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:

mov ecx,msg_x
mov edx,x_len
call print_msg

call scan
;;call print
fst dword[x]

mov ecx,msg_in
mov edx,in_len
call print_msg
fsin
call print

mov dword[is_neg],1
mov dword[den],1
mov eax,dword[x]
mov dword[res],eax
mov eax,[x]
mov dword[x_pow],eax
mov ecx,25

manip:

pusha
ffree 
ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7

fld dword[x_pow]
fld dword[x]
fmul st1           ;;x_pow*x

fld dword[x]
fmul st1           ;;x_pow*x*x

inc dword[den]      ;;den+1

fidiv dword[den]    ;;x_pow*x*x/den+1

inc dword[den]

fidiv dword[den]
fst dword[x_pow]

cmp dword[is_neg],0
jne sub
fld dword[res]
fadd st1
fst dword[res]

mov dword[is_neg],1
jmp skip_sub
sub:
fld dword[res]
fsub st1
fst dword[res]
mov dword[is_neg],0

skip_sub:


popa
dec ecx
cmp ecx,0
jne manip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ffree 
ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7

fld dword[res]
call print

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
msg_x:db "Enter value of x :",0
x_len:equ $-msg_x
msg_in:db "The value returned by inbuilt function:",10
in_len:equ $-msg_in
msg_inp:db "Enter the elements:",10
inp_len:equ $-msg_inp
msg_res:db "Result :",10
res_len:equ $-msg_res
err_msg:db "Error",10
err_len:equ $-err_msg
fmt1:db "%lf",0
format2: db "%lf",10

