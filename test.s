.section .data
    prova: .string "test"

.section .text
    .global _start

_start:
    pushl $prova
    call printf
    addl $4, %esp

uscita:
    movl $1, %eax
    movl $0, %ebx
    int $0x80
