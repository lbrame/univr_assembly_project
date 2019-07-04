.section .data
new_line_char:
    .byte 10
.section .text
.align 4
.global _start
_start:
    movl %esp, %ebp         # Salva una copia di ESP in EBP per poter
                            # modificare ESP senza problemi.
                            # In questo punto dell'esecuzione ESP contiene
                            # l'indirizzo di memoria della locazione in cui
                            # si trova il numero di argomenti passati alla
                            # riga di comando del programma.
ancora:
    addl $4, %esp           # Somma 4 al valore di ESP. In tal modo ESP
                            # stack, che contiene l'indirizzo di memoria
                            # punta al prossimo elemento sulla cima dello
                            # del prossimo parametro della riga di comando.
                            # Alla prima iterazione, dopo questa
                            # istruzione, ESP punta all'elemento dello
                            # stack che contiene l'indirizzo della
                            # locazione di memoria che contiene il nome del
                            # programma.
    
    movl (%esp), %eax       # Copia in EAX il contenuto della locazione
                            # di memoria puntata da ESP, cioè copia in EAX
                            # il puntatore al prossimo parametro della riga
                            # di comando (oppure NULL se non ci sono altri
                            # parametri).

    testl %eax, %eax        # Controlla se EAX contiene NULL (cioè 0). In
                            # tal caso significa che ho già recuperato
                            # tutti i parametri.

    jz fine_ancora          # Esce dal ciclo se non ci sono altri parametri
                            # da recuperare.

    call stampa_parametro   # Richiama la funzione per stampare il
                            # parametro. ESP punta alla locazione di memoria
                            # che contiene l'indirizzo del parametro da
                            # considerare. Al posto di tale funzione si
                            # potrebbe inserire il codice che elabora il
                            # dato, invece di stamparlo.

    jmp ancora              # Ricomincia il ciclo per recuperare gli altri
                            # parametri.

fine_ancora:

    movl $1, %eax
    movl $0, %ebx
    int $0x80

    .type stampa_parametro, @function   # definizione della funzione
                                        # stampa_parametro per la stampa del
                                        # parametro
stampa_parametro:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %ecx