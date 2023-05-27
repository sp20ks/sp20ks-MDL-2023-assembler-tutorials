nasm -f elf64 task.asm -task.lst
ld -o task task.o
./task
