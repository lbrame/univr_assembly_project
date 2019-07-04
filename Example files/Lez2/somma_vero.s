.section .data      # sezione per i dati

addendo_1:
    .long 100

addendo_2:
    .long 33

addendo_3:
    .long 68

sum:
    .ascii "000\n"

.section .text          # selezione istruzioni
    .global _start      # punto di inizio del programma

_start:
    # Sum
    # 100 + 33
    movl addendo_1, %eax
    movl addendo_2, %ebx
    addl %ebx, %eax
    # 133 + 68
    movl addendo_3, %ebx
    addl %ebx, %eax
    leal sum, %esi   # Aggiungo al registro ESI l'indirizzo di memoria di "sum"
    
    

    # Stampa della somma (se esiste una deità ora la prego)
    movl $10, %ebx      # metto 10 in ebx per divedere
    div %bl             # eax / ebx = al(eax), resto = ah
    addb $48, %ah       # 58 = 0 in ascii
    movb %ah, 2(%esi)
    xorb %ah, %ah

    div %bl             # eax / ebx = al(eax), resto = ah
    addb $48, %ah       # 58 = 0 in ascii
    movb %ah, 1(%esi)
    xorb %ah, %ah

    div %bl             # eax / ebx = al(eax), resto = ah
    addb $48, %ah       # 58 = 0 in ascii
    movb %ah, (%esi)
    xorb %ah, %ah


    # stampa a video
    movl $4, %eax       # syscall WRITE
                        # vero che non sovvrascrivi niente
    movl $1, %ebx       # non so che cazzo sto facendo
                        # perché ho scelto informatica
                        # potevo fare scienze della comunicazione e basta
    leal sum, %ecx      # assegna il valore nella variable "sum" in ECX
    movl $4, %edx
    int $0x80           # Invoca la syscall


    # Finisci il programma
    movl $1, %eax       # syscall EXIT
    movl $0, %ebx       # Exit program with status code 0
    int $0x80           # Exec
     
