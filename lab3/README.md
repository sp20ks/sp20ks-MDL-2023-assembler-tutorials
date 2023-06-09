# Лабораторная работа №3 *"Программирование ветвлений и итерационных циклов"*

## Теоретический материал
### 1. Какие машинные команды используют при программировании ветвлений и циклов?
* Ветвления на языке ассемблера программируют с использованием команд условной и безусловной передачи управления. Поскольку команды условного перехода предполагают анализ результата выполнения предыдущих команд, сначала выполняют сравнение – проверку заданного условия. В результате выполнения операции сравнения будут установлены флаги, по которым будет осуществляться переходы. 
Командами условной передачи управления являются jle, jge, je, jz и т.д. Командой безусловной передачи управления является команда jmp.

  * **Механизм работы условного перехода:**
Сначала производится сравнение с помощью команды **cmp**. Эта команда изменяет регистр *flags*. Условный переход как раз основывается на анализе регистра *flags*.

  * Регистр flags включает следующие флаги:
    * **ОF** – флаг переполнения разрядной сетки: 1 – результат операции не умещается в отведенное под него место;
    * **DF** – направление обработки строк: 0 – от младших адресов к старшим, 1 – от старших к младшим;
    * **IF** – разрешение прерывания;
    * **SF** – признак знака: 1 – результат больше нуля, 0 – результат меньше нуля;
    * **ZF** – признак нуля: 1 – результат равен нулю;
    * **АF** – признак наличия переноса из тетрады (в настоящее время не используется);
    * **СF** – признак переноса: 1 – при выполнении операции формируется перенос (для операции сложения) или заем (для операции вычитания).


    Соответсвенно команда jz выполнит переход к метке, если **ZF** = 1.

### 2. Выделите в своей программе фрагмент, реализующий ветвление. Каково назначение каждой машинной команды фрагмента?
    ; определение четности a
    mov rcx, 2 ; заносим 2, чтоб после делить на это число содержимое регистра rax
    mov rax, [A] ; делить будем переменную a
    idiv rcx ; делим на 2
    cmp rdx, 0 ; сравниваем остаток от деления (хранится в rcx) с 0
    je even ; если rdx == 0, то переход на метку even

* Код выше осуществляет проверку четности переменной A. Остаток от деления помещается в регистр **RDX**. Остаток от деления сравнивается с нулем с помощью команды **cmp**, эта же команда после сравнения выставляет (или не выставляет) флаг.

### 3.  Чем вызвана необходимость использования команд безусловной передачи управления?
* Необходимость безусловной передачи управления объясняется потребностью выполнять разные блоки программы при разных исходных данных.

  
### 4. Поясните последовательность команд, выполняющих операции ввода-вывода в вашей программе. Чем вызвана сложность преобразований данных при выполнении операций ввода-вывода?
* Сперва осуществляется вывод сообщения в терминал в виде, имеющее следующее содержание “Введите Х”. Затем пользователь вводит число, однако, программа воспринимает это число как строковое значение. Для преобразования строки в число используется функция StrToInt. После этого число записывается в переменную и может использоваться для операций над целочисленными значениями. При завершении работы с переменным в виде числа и для вывода в терминал, необходимо снова преобразовать число. В этот раз из целочисленного значения в строковое посредством функции IntToStr.

## На что стоит обратить особое внимание при выполнении лабораторной работы
* Часто при делении нужно следить за размером операндов. Может появиться ошибка при выполнении *"Floating point exception (core dumped)"*. ~~Отвечаю~~ Скорее всего, ошибка именно в делении.
  
* Стоит почитать другие операторы условного перехода. Много мнемоник, запрогать можно любую логику.
  
**!Грабля, на которую некоторые наступают!**
* Имеем код:

        mov rax, 5
        metka:
        mov rdx, 6
  Программа выполняется **сверху вниз**. Даже если встречается метка, программа идет дальше выполнять инструкции. При прыжке в метку не осуществляется возврат в точку, откуда был сделан прыжок (исключение - процедуры, реализумые с помощью **call** и **ret**, но это в следующих лабах).
* В nasm нет непосредсвенного указания знака для значений, т.е. нельзя просто взять и написать так:
        
        mov rax, -5
  Программа будет работать, но число, лежащее в **RAX**, будет интерпретироваться как беззнаковое (бит знака будет установлен). 

  Чтобы решить эту проблему, можно воспользоваться командой **movsx** или из 0 вычесть модуль числа, которое нужно, т.е.

        xor rax, rax ; занулили
        mov rcx, 5
        sub rax, rcx

   В итоге в **RAX** будет лежать -5. Ураа.

* И стоит обратить внимание на команды расширения чисел:
        
        CBW; байт в слово AL -> AX
        CWD; слово в двойное слово AX -> DX:AX
        CDQ; двойное слово в учетверенное EAX -> EDX:EAX
        CWDE; слово в двойное слово AX -> EAX