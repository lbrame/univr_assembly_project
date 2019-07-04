.section .data

numero_a:
    .long 320

numero_b:
    .long 420

a_greater_b:
    .ascii "a è maggiore di b\n"

a_greater_b_length:
    .long . - a_greater_b

a_smaller_b:
    .ascii "a è minore di b\n"
 
a_smaller_b_length:
    .long . - a_smaller_b

a_equal_b:
    .ascii "a e b sono uguali\n"

a_equal_b_length:
    .long . - a_equal_b                 # please compile

.section .text
    .global _start

_start:
    # Sposta i due numeri nei due registri
    movl numero_a, %eax 
    movl numero_b, %ebx
    
    # Compare
    cmp %eax, %ebx                      # if(eax < ebx)
    jl isless
    je isequal
        # block 2 (blocco else)
        movl $4, %eax
        movl $1, %ebx
        leal a_smaller_b, %ecx
        movl a_smaller_b_length, %edx
        int $0x80
        jmp after
        jmp micdrop
    isless:
        # block 1 (blocco then. if - then)
        # stampa a video isless
        movl $4, %eax
        movl $1, %ebx
        leal a_greater_b, %ecx
        movl a_greater_b_length, %edx
        int $0x80
        jmp micdrop
    after:
        # Dopo if
        jmp micdrop
    isequal:
        movl $4, %eax
        movl $1, %ebx
        leal a_equal_b, %ecx
        movl a_equal_b_length, %edx
        int $0x80

    micdrop:
        movl $1, %eax
        movl $0, %ebx
        int $0x80
