section .text
global main
extern scanf
extern printf

print:
push ebp
mov ebp,esp
sub esp,8
fst qword[ebp-8]   ;;the val at ST0 is now stored at ebp-8
push format2
call printf
mov esp,ebp
pop ebp
ret

read:
push ebp
mov ebp,esp
sub esp,8
lea eax,[esp]
push eax
push format1
call scanf
fld qword[ebp-8]  ;;ST0 now has the value read
mov esp,ebp
pop ebp
ret

main:

;;fldz
fld1
fld1
fadd st1
fst qword[const_two]
ffree st0
ffree st1
call read
fldpi
fmul st1
fmul qword[const_two]
call print

mov eax,1
mov ebx,0
int 80h


section .data
format1:db "%lf",0
format2:db "Result :%lf",10


section .bss
const_two:resb 1

