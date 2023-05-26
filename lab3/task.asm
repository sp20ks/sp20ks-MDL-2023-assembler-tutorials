%include "lib64.asm"

 section .data ; сегмент инициализированных переменных
    StartMsg db "Вычисление выражения f = a/c - 2b, если a - четное, иначе f = -8", 10
    lenStartMsg equ $-StartMsg
    
    InputA db "Введите a:", 10
    lenInputA equ $-InputA
    
    InputB db "Введите b:", 10
    lenInputB equ $-InputB
    
    InputC db "Введите c:", 10
    lenInputC equ $-InputC
    
    EndMsg db "Результат:", 10
    lenEndMsg equ $-EndMsg
    
    EvenMsg db "a четное", 10
    lenEvenMsg equ $-EvenMsg
    
    OddMsg db "a нечетное", 10
    lenOddMsg equ $-OddMsg
 section .bss ; сегмент неинициализированных переменных
    A resd 1
    B resd 1
    C resd 1
    F resd 1
    Buffer resd 5
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
    
input_C:
    ; ввод C
    ; вывод запроса на ввод B
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, InputC ; адрес выводимой строки
    mov rdx, lenInputC ; длина строки
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
    mov [C], rax
    
    ; определение четности a
    mov rcx, 2 ; заносим 2, чтоб после делить на это число содержимое регистра rax
    mov rax, [A] ; делить будем переменную a
    idiv rcx ; делим на 2
    cmp rdx, 0 ; сравниваем остаток от деления (хранится в rcx) с 0
    je even ; если rdx == 0, то переход на метку even

    ; вывод сообщения о нечетности числа
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, OddMsg ; адрес выводимой строки
    mov rdx, lenOddMsg ; длина строки
    ; вызов системной функции
    syscall
  
    ; запись результата
    mov DWORD[F], 0 ; обнуляем переменную
    mov rax, 8
    sub [F], rax ; F = 0 - 8 
    jmp exit ; переход в окончание программы
    

even:
    ; вывод сообщения о четности числа
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, EvenMsg ; адрес выводимой строки
    mov rdx, lenEvenMsg ; длина строки
    syscall
    
    ; вычисление
    cmp DWORD[C], 0 ; если C==0 переход к вводу С (предотвращение деления на 0)
    je input_C
    mov rax, [A] ; помещаем в rax a
    cdq ; расширяем двойное слово до учетверенного слова (делимое по размеру должно быть больше делителя)
    idiv DWORD[C] ; делим rax на C
    mov [F], rax ; в переменной F сохраняем первое слагаемое
    mov rax, 2
    imul DWORD[B] ; умножаем содержимое rax на b
    sub [F], rax ; вычитаем
    jmp exit ; переход в окончание программы


exit:   
    ; вывод сообщения о результате
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, EndMsg ; адрес выводимой строки
    mov rdx, lenEndMsg ; длина строки
    ; вызов системной функции
    syscall
    
    ; преобразование int -> str
    mov rsi, Buffer
    mov rax, [F]
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