%include "lib64.asm"

 section .data ; сегмент инициализированных переменных
    StartMsg db "Вычисление выражения q = (a^2)/2 - (b^3)/(4 - a + b)", 10
    lenStartMsg equ $-StartMsg
    
    InputA db "Введите a:", 10
    lenInputA equ $-InputA
    
    InputB db "Введите b:", 10
    lenInputB equ $-InputB
    
    EndMsg db "Результат:", 10
    lenEndMsg equ $-EndMsg
 section .bss ; сегмент неинициализированных переменных
    A resd 1
    B resd 1
    Q resd 1
    Buffer resd 5
    b1 resd 1
    b2 resd 1
 section .text ; сегмент кода

 global _start
_start:
    ; вывод стартового сообщения   
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, StartMsg ; адрес выводимой строки
    mov rdx, lenStartMsg ; длина строки
    ; вызов системной функции
    syscall
    
    ; ввод A
    ; вывод запроса на ввод A
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, InputA ; адрес выводимой строки
    mov rdx, lenInputA ; длина строки
    ; вызов системной функции
    syscall
    
    ; считывание
    mov rax, 0; системная функция 0 (read)
    mov rdi, 0; дескриптор файла stdin=0
    mov rsi, Buffer; адрес вводимой строки
    mov rdx, 10; длина строки
    ; вызов системной функции
    syscall
    
    ; преобразование str -> int с помощью либы lib64.asm. 
    mov rsi, Buffer
    call StrToInt64
    mov [A], rax
       
    ; ввод B
    ; вывод запроса на ввод B
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, InputB ; адрес выводимой строки
    mov rdx, lenInputB ; длина строки
    ; вызов системной функции
    syscall
    
    ; считывание
    mov rax, 0; системная функция 0 (read)
    mov rdi, 0; дескриптор файла stdin=0
    mov rsi, Buffer; адрес вводимой строки
    mov rdx, 10; длина строки
    ; вызов системной функции
    syscall
    
    ; преобразование str -> int с помощью либы lib64.asm. 
    mov rsi, Buffer
    call StrToInt64
    mov [B], rax
    
    ; вычисление
    
    ;возведение в квадрат a
    mov rax, [A]
    imul DWORD[A] ; результат вычислений помещен в rax
    ; деление a^2 на 2
    mov DWORD[A], 2
    idiv DWORD[A] ; rax - целое от деления, rdx - остаток
    
    ; сохраняем первое слагаемое в q
    mov [Q], rax
    
    ; возведем в куб b
    mov rax, [B]
    imul DWORD[B]
    imul DWORD[B]
    ; сохраним b^3 в регистре rcx, пока будем вычислять знаменатель
    mov rcx, rax   
    
    ; вычисляем 4 - a + b
    mov rax, 4
    sbb rax, [A] ; вычитает из операнда1 операнд2 и помещает результат по адресу операнда1
    add rax, [B] ; аналогично sbb, но сложение
 
    ; меняем местами данные в rcx и rax, чтоб поделить значение из rcx на rax
    xchg rax, rcx
    
    mov [b1], rax
    mov [b2], rcx
    ; деление
    idiv ecx
    
    ; вычитание из первого слагаемого 
    sbb [Q], rax

    ; вывод сообщения о результате
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, EndMsg ; адрес выводимой строки
    mov rdx, lenEndMsg ; длина строки
    ; вызов системной функции
    syscall
    
    ; преобразование int -> str
    mov rsi, Buffer
    mov rax, [Q]
    call IntToStr64
    
    ; вывод результата
    mov rdx, rax ; длина строки
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, Buffer ; адрес выводимой строки
    ; вызов системной функции
    syscall
    
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall