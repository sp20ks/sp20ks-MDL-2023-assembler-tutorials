global Convert
section .text ; сегмент кода

Convert:
    push RBP
    mov RBP, RSP

    mov RBX, RDI ; первая переменная - исходная строка
    mov ECX, 0 ;side_p
cycle_usual:
    mov AL, [RDI]
    cmp AL, 0
    je Exit

    cmp AL, 23h           ;сравнить символ
    je prep ;Переход, если есть #

    ; Если нет #, идём дальше
    inc RDI ; увеличиваем основной указтель
    mov RBX, RDI ; обновляем сторонний указатель (для удаления)
    jmp cycle_usual
;совпадают
prep:
    mov RDX, 0
    mov BYTE DL, [RDI + 1] ; первый элемент последовательности
    mov RCX, 1
cycle_find:
    inc RDI
    mov RSI, 0
    cmp BYTE [RDI], DL           ;сравнить
    ; Выход, если не совпал
    jne del

    ; Продолжаем, если совпал
    inc RCX ; увеличиваем счётчик
    jmp cycle_find
del:
    cmp RCX, 2
    je cycle_usual
    jmp clear

clear:
    cmp RCX, 0
    je cycle_usual
    mov BYTE [RBX], 20h
    inc RBX
    dec RCX
    jmp clear

Exit:
    pop RBP
    ret
