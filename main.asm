section .data
    string db '123', 0 
section .text
    global _start
_start:
  push string
  call atoi

Endprocess:
    mov eax , 1
    xor ebx , ebx
    int 0x80

atoi:
    push ebp 
    mov ebp , esp
    sub esp , 16

    mov DWORD [ebp-8] , 0 ; result
    mov DWORD [ebp-12] , 1 ; sign
    mov esi , [ebp+8] ; pointer to the string
atoi.L1:
    cmp BYTE [esi] , ' ' ; check for whitespace
    jne atoi.L2 ; jump for check sign if not whitespace
    inc esi ; *str++ | next char for check
    jmp atoi.L1 ; loop for check again
atoi.L2:
    cmp BYTE [esi] , '-' ; check nagative sign
    jne atoi.L3 ; jump for convert if not nagative
    mov DWORD [ebp-12] , -1 ; change sign to -1 and multiply when convert finish
    inc esi ;next char for convert 
atoi.L3:
    movzx eax , byte [esi] ; load *str into eax
    test al , al ; check null terminator | check end of strings
    jz atoi.return ; jump to return if end of strings

    cmp al , '0' ; compare char with 0 if it small than 0
    jl atoi.return ;jump to return because no unsigned integer small than 0
    cmp al , '9' ; compare char with 9 if it big than 9
    jg atoi.return ;jump to return because no unsigned integer big than 9

    sub eax , '0' ;convert number using (*str - '0') 
    mov edx , [ebp-8] ; load result into edx
    imul edx , 10 ; result*10
    add edx , eax ; result*10+(*str - '0') 
    mov [ebp-8] , edx ; result = result*10+(*str - '0') 
    inc esi ; next char for convert 
    jmp atoi.L3 ; loop for convert next char

atoi.return:
    mov eax, [ebp-8] ; load reuslt into eax
    imul eax , DWORD [ebp-12] ; result*sign for apply sign
    add esp , 16
    pop ebp
    ret
