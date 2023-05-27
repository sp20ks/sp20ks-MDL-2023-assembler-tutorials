%include "lib64.asm"

 section .data ; сегмент инициализированных переменных
    StartMsg db "Определение минимальных элементов в столбцах матрицы 4 на 5", 10
    lenStartMsg equ $-StartMsg

    EnterMsg db "Введите матрицу 4 на 5 (элементы через enter):", 10
    lenEnterMsg equ $-EnterMsg
    
    ResMsg db "Минимальный элемент каждого столбца:", 10
    lenResMsg equ $-ResMsg
 section .bss ; сегмент неинициализированных переменных
    Matrix resd 20
    Buf resd 1
 section .text ; сегмент кода

 global _start
_start:    
    ; вывод стартового сообщения
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, StartMsg ; адрес выводимой строки
    mov rdx, lenStartMsg ; длина строки
    syscall ; вызов системной функции
    
    ; вывод сообщения с просьбой о вводе
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, EnterMsg ; адрес выводимой строки
    mov rdx, lenEnterMsg ; длина строки
    syscall ; вызов системной функции

    ;ввод
    mov rbx, 0  ; смещение внутри массива
    mov rcx, 20 ; счетчик элементов
INPUT:
    push rcx ; сохраняем значения
    push rbx
    
    mov rax, 0 ; системная функция 0 (read)
    mov rdi, 0 ; дескриптор файла stdin=0
    mov rsi, Buf ; адрес вводимой строки
    mov rdx, 4 ; длина строки
    syscall ; вызов системной функции
    
    ; преобразовываем str -> int
    mov rsi, Buf
    call StrToInt64
    
    pop rbx ; восстанавливаем смещение
    
    mov [rbx*4 + Matrix], rax ; заносим введенное значение в массив (умножение на 4 из-за размера элемента)
    inc rbx ; увеличиваем смещение
    pop rcx ; восстанивливаем счетчик элементов
    loop INPUT
    
         
    ;вывод сообщения о результате
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    mov rsi, ResMsg ; адрес выводимой строки
    mov rdx, lenResMsg ; длина строки
    syscall ; вызов системной функции
    
    
    ; цикл по столбцам
    mov rcx, 5 ; счетчик столбцов
LOOP_COLUMN:
    mov r8, 5
    sub r8, rcx
    mov r10d, DWORD[Matrix + r8*4] ; сохраняем величину базового элемента
    mov rbx, r8 ; смещение внутри массива
    push rcx ; сохраняем значение стобца
    mov rcx, 4 ; счетчик элементов
SEARCH_MIN:
    mov eax, DWORD[Matrix + rbx*4] ; заносим величину элемента
    add rbx, 5; увеличиваем смещение внутри столбца
    cmp eax, r10d ; сравниваем текущее значение с записанным минимальным
    jg continue ; если уже найденное значение меньше текущего, переходим к следующему
    mov r10d, eax ; запоминаем новое значение 
continue:
    loop SEARCH_MIN

    ; преобразование int -> str
    mov rsi, Buf
    mov eax, r10d
    call IntToStr64
    ; вывод результата
    mov rdx, rax ; длина строки
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, Buf ; адрес выводимой строки
    syscall ; вызов системной функции
    
    pop rcx

    loop LOOP_COLUMN
    
exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall