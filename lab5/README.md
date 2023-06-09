# Лабораторная работа №5 *"Связь разноязыковых модулей"*

## Теоретический материал
### 1. Что такое «конвенции о связи»? В чем заключается конвенция register?
* Конвенции о связи - ряд способов декларировать  передачу параметров при организации связи разных модулей (вызывающей и вызываемой программы). При регистровой конвенции доступно 3 регистра при вызове подпрограммы: EAX, EDX, ECX, все остальные параметры хранятся в стеке.

### 2. Что такое «пролог» и «эпилог»? Где располагается область локальных данных?
* Пролог и эпилог - стандартное оформление входа и выхода программы соответственно. При вызове программы выполняется пролог, в ходе которого в стеке сохраняется значение RBP вызывающей программы, копии параметров и область локальных переменных подпрограммы.
### 3. Как связана структура данных стека в момент передачи управления и текст программы и подпрограмм?

* В момент получения управления подпрограммой в регистрах находятся до 6-ти параметров в виде значений или адресов (например, если передать указатель на начало строки), а в стеке – адрес возврата в вызывающую программу (адрес 64х разрядный для 64х разрядной системы).
  
### 4. С какой целью применяют разноязыковые модули в одном проекте?
* Разноязыковые модули позволяют дополнить функционал языка высокого уровня. Также возможна оптимизация высоконагруженных функций, которые возможно ускорить за счет замещения стандартныой функции или метода ассемблерной программой.

## На что стоит обратить особое внимание при выполнении лабораторной работы
* Стоит изучить конвенции связи C++ - Nasm. Понять, каким образом передаются данные в процедуру (через регистры, стек, таблицу адресов).
* Никто не запрещает вынести предобработку данных из ассемблера в C++, чтоб уменьшить количество кода.
* Внутри модуля nasm разрешено использовать директивы .bss и .data.
* Если нужны локальные переменные, их можно реализовать с помощью стека.