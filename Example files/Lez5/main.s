# filename: main.s

.section .text

  .global _start

_start:

  movl $100, %eax

  call itoa

  movl $1, %eax
  xorl %ebx, %ebx
  int $0x80
