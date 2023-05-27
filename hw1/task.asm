%include "lib64.asm"

 section .data ; сегмент инициализированных переменных
    StartMsg db "Определение количества слов с буквой a", 10
    lenStartMsg equ $-StartMsg

    EnterMsg db "Введите строку:", 10
    lenEnterMsg equ $-EnterMsg
    
    ResMsg db "Количество слов с буквой a:", 10
    lenResMsg equ $-ResMsg
 section .bss ; сегмент неинициализированных переменных
    String resb 50
    lenString equ $-String
    
    Buf resb 4
 section .text ; сегмент кода

 global _start
_start:    
    ; вывод старотового сообщения
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, StartMsg ; адрес выводимой строки
    mov rdx, lenStartMsg ; длина строки
    ; вызов системной функции
    syscall
    
    ; вывод сообщения с запросом на ввод
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, EnterMsg ; адрес выводимой строки
    mov rdx, lenEnterMsg ; длина строки
    ; вызов системной функции
    syscall
    
    ; ввод строки
    mov rax, 0; системная функция 0 (read)
    mov rdi, 0; дескриптор файла stdin=0
    mov rsi, String; адрес вводимой строки
    mov rdx, 50; длина строки
    ; вызов системной функции
    syscall
    
    ;подсчет длины введенной строки до кода Enter
    lea rdi,[String] ; загружаем адрес строки в rdi
    mov rcx,lenString     ; загружаем размер буфера ввода
    mov al,0Ah; загружаем 0Ah для поиска в буфере ввода
    repne scasb; ищем код Enter в строке
    mov rax,50
    sub rax,rcx; вычитаем из размера буфера остаток cx
    mov rcx,rax; полученная разница – длина строки +1
    ;добавление пробела в конец строки
    mov BYTE[rcx + String - 1],' '
    
    
    ; цикл по всей строке
    lea rsi, [String] ; адрес источника
    ;dec rcx
    xor rbx, rbx ; зануляем счетчик слов
    xor rdx, rdx ; будет служить маркером наличия буквы в слове(0 - нет, 1 - есть)
SEARCH_A:
    lodsb
    cmp al, 'a' ; если считали не a
    jne NOT_A ; переход по метке
    inc rdx ; установили метку встречи a
NOT_A:
    cmp al,' ' ; если считали не пробел
    jne continue ; переход по метке
    ; так как это окончание слова, начинаем проверку на наличие встреченных букв a
    mov r10, rdx
    xor rdx, rdx ; обновляем метку под следующее слово
    cmp r10, 3 ; если не встретили
    jng continue
    inc rbx ; увеличиваем количество слов
continue:
    loop SEARCH_A
    
    ; вывод сообщения результата
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ResMsg ; адрес выводимой строки
    mov rdx, lenResMsg ; длина строки
    ; вызов системной функции
    syscall
    
    ; вывод количества
    mov rax, rbx
    mov rsi, Buf
    call IntToStr64
    
    mov rdx, rax ; длина строки
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, Buf ; адрес выводимой строки
    ; вызов системной функции
    syscall
    
exit:
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall