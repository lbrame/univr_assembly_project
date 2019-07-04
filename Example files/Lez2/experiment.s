.section .data

n1:
    .long 12

n2:
    .long 13

n_maggiore:
    .ascii "000\n"

n_minore:
    .ascii "000\n"

testo_uguali:
    .ascii "Sono uguali!!\n"

testo_uguali_len:
    .long .-testo_uguali

testo_maggiore:
    .ascii "Maggiore: "

testo_maggiore_len:
    .long .-testo_maggiore

testo_minore:
    .ascii "Minore: "

testo_minore_len:
    .long .-testo_minore

.section .text
    .global _start

_start:
    movl n1, %eax
    movl n2, %ebx
    cmp %eax, %ebx


    jg n2_maggiore
    jl n1_maggiore
    je uguale

n1_maggiore:
    movl n1, %ebp
    movl n2, %esp
    jmp stampa

n2_maggiore:
    movl n2, %ebp
    movl n1, %esp
    jmp stampa

uguale:
    movl $4, %eax
    movl $1, %ebx
    leal testo_uguali, %ecx
    movl testo_uguali_len, %edx
    int $0x80
    jmp fine

stampa:

    leal n_maggiore, %esi # overwrites
    leal n_minore, %edi

    # conversione in ascii numero maggiore
    movb n1, %al
    movl $10, %ebx
	div %bl
	addb $48, %ah			
	movb %ah, 2(%esi)
	xorb %ah, %ah

	div %bl
	addb $48, %ah
	movb %ah, 1(%esi)
	xorb %ah, %ah

	div %bl
	addb $48, %ah
	movb %ah, (%esi)
    xorb %ah, %ah

    # conversione in ascii numero minore
    movb n2, %al
    movl $10, %ebx
	div %bl					
	addb $48, %ah			
	movb %ah, 2(%edi)
	xorb %ah, %ah

	div %bl
	addb $48, %ah
	movb %ah, 1(%edi)
	xorb %ah, %ah

	div %bl
	addb $48, %ah
	movb %ah, (%edi)
    xorb %ah, %ah

    # stampa testo maggiore
    movl $4, %eax
	movl $1, %ebx
	leal testo_maggiore, %ecx
	movl testo_maggiore_len, %edx
	int $0x80

    # stampo il numero maggiore
    movl $4, %eax
	movl $1, %ebx
	leal n_maggiore, %ecx
	movl $4, %edx
	int $0x80

    #stampa testo minore
    movl $4, %eax
	movl $1, %ebx
	leal testo_minore, %ecx
	movl testo_minore_len, %edx
	int $0x80

    # stampo il numero minore
    movl $4, %eax
	movl $1, %ebx
	leal n_minore, %ecx
	movl $4, %edx
	int $0x80

    jmp fine

fine: 
    # termino il programma
    movl $1, %eax
	movl $0, %ebx
	int $0x80
