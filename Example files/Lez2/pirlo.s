
# Esercizio dello Spritz (mi rifiuto, si dice Pirlo)

.section .data
    # sezione per i dati

titolo:
    .ascii "Programma per calcolare quante macchine servono per andare a bere il pirlo\n\n"

titolo_len:
    .long . - titolo    # lunghezza del titolo

testo:
    .ascii "Numero di auto richieste\n\n"

testo_len:
    .long . - testo     # lunghezza del testo

numStudenti:
    .long 152           # numero degli studenti (max 255)
                        # long è ridondante ma per brevità...
studPerAuto:
    .long 5             # numero delle macchine

numAuto:
    .ascii "000\n"      # qui salvo il numero di auto in formato testo

.section .text
    # indicazione partenza del programma
.global _start

_start: # Equivalente del main() in C

    # Calcolo quante auto mi servono
    movl numStudenti, %eax
    movl studPerAuto, %ebx
    div %bl                     # divisione in byte
    cmpb $0, %ah                # controllo il resto della divisione per vedere se ho studenti a piedi
    je continuazione            # se h=0, va a continuazione
    

    incb %al                    # aggiungo una macchina in più per gli appiedati
                                # viene eseguito solo se ah!=0

    xorb %ah, %ah               # pulisco i bit del resto

continuazione:

    # Da qui in poi n AL ho il numero di auto necessarie :)

    leal numAuto, %esi          # carico in ESI l'indirizzo della variabile stringa.

    # trasformo il numero in testo con divisioni successive per 10.
    movl $10, %ebx
    div %bl                     # la cifra che estraggo finisce in AX (resto divisione)
    addb $48, %ah               # converto nel carattere corrispondente alla cifra
    movb %ah, 2(%esi)           # metto il carattere nel terzo della stringa
    xorb %ah, %ah               # azzero ah    movl $10, %ebx

    div %bl                     # la cifra che estraggo finisce in AX (resto divisione)
    addb $48, %ah               # converto nel carattere corrispondente alla cifra
    movb %ah, 1(%esi)           # metto il carattere nel terzo della stringa
    xorb %ah, %ah               # azzero ah

    movl $10, %ebx
    div %bl                     # la cifra che estraggo finisce in AX (resto divisione)
    addb $48, %ah               # converto nel carattere corrispondente alla cifra
    movb %ah, (%esi)            # metto il carattere nel terzo della stringa
    xorb %ah, %ah               # azzero ah

    # stampa a video del titolo
    movl $4, %eax               # syscall WRITE
    movl $1, %ebx               # stdout
    leal titolo, %ecx           # indirizzo di memoria della stringa da stampare
    movl titolo_len, %edx       # stampo 4 caratteri (3 cifre + andata a capo)
    int $0x80                   # esecuzione syscall

    # stampa a video del testo
    movl $4, %eax               # syscall WRITE
    movl $1, %ebx               # stdout
    leal testo, %ecx            # indirizzo di memoria della stringa da stampare
    movl testo_len, %edx               # stampo 4 caratteri (3 cifre + andata a capo)
    int $0x80                   # esecuzione syscall


    # stampa a video del risultato
    movl $4, %eax               # syscall WRITE
    movl $1, %ebx               # stdout
    leal numAuto, %ecx          # indirizzo di memoria della stringa da stampare
    movl $4, %edx               # stampo 4 caratteri (3 cifre + andata a capo)
    int $0x80                   # esecuzione syscall



    # termino il programma
    movl $1, %eax               # syscall exit
    movl $0, %ebx               # codice di uscita 0
    int $0x80                   # esecuzione syscall
    