section .bss
a:resd 1
c:resd 1
b:resd 1
sq_root:resd 1

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

print_msg:
pusha
mov eax,4
mov ebx,1
int 80h
popa
ret

main:

mov ecx,msg_a
mov edx,a_len
call print_msg
call scan
fst dword[a]

fldz
fcomi st1
je exit

ffree
mov ecx,msg_b
mov edx,b_len
call print_msg
call scan
fstp dword[b]

mov ecx,msg_c
mov edx,c_len
call print_msg
call scan
fstp dword[c]

mov ecx,msg_res
mov edx,res_len
call print_msg

;ffree

fld dword[a]
fld dword[c]
fmul st1

fimul dword[const_4]   ;;4ac

fld dword[b] 

fmul st0               ;;b*b

fsub st1

fsqrt                  ;;b*b-4ac

fst dword[sq_root]


fld dword[b]

fchs                   ;;-b

fadd st1               ;;-b+sqrt(b*b-4ac)

fidiv dword[const_2]   ;;-b+sqrt(b*b-4ac)/2

fdiv dword[a]

call print

ffree

fld dword[sq_root]
fld dword[b]
fchs
fsub st1               
fidiv dword[const_2]   ;;-b-sqrt(b*b-4ac)/2

fdiv dword[a]
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
const_4:dd 4
const_2:dd 2
msg_a:db "Enter value of a :",0
a_len:equ $-msg_a
msg_b:db "Enter value of b :",0
b_len:equ $-msg_b
msg_c:db "Enter value of c :",0
c_len:equ $-msg_c
msg_res:db "The roots are :",10
res_len:equ $-msg_res
err_msg:db "Error",10
err_len:equ $-err_msg
fmt1:db "%lf",0
format2: db "%lf",10

