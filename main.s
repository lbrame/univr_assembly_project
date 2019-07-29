# printf, scanf modificano EAX, ECX, EDX

.section .data #Variabili in memoria [DATA]
    // asciz = ascii "... \0"
    txtInput:    .asciz "Inserimento dei %i interi che compongono il vettore...\n"
    txtInputFor: .asciz "Inserire l'intero in posizione %i: "
    txtMenu:     .asciz "\nOPERAZIONI DISPONIBILI\n----------------------\n1) stampa a video del vettore inserito\n2) stampa a video del vettore inserito in ordine inverso\n3) stampa il numero di valori pari e dispari inseriti\n4) stampa la posizione di un valore inserito dall'utente\n5) stampa il massimo valore inserito\n6) stampa la posizione del massimo valore inserito\n7) stampa il minimo valore inserito\n8) stampa la posizione del minimo valore inserito\n9) stampa il valore inserito con maggior frequenza\n10) stampa la media intera dei valori inseriti\n"
    txtSelect:   .asciz "\nInserire valore operazione (0 uscita, -1 ristampa menu'): "
    txtOpt0:     .asciz "Uscita dall'applicazione...\n"
    txtOpt3even: .asciz "Numero di valori pari inseriti: %i\n"
    txtOpt3odd:  .asciz "Numero di valori dispari inseriti: %i\n"
    txtOpt4sel:  .asciz "Inserire l'intero da cercare: "
    txtOpt4pos:  .asciz "Posizione del valore %i: %i\n"
    txtOpt404:   .asciz "Valore %i non trovato\n"
    txtOpt5:     .asciz "Massimo valore inserito: %i\n"
    txtOpt6:     .asciz "Posizione del massimo valore inserito: %i\n"
    txtOpt7:     .asciz "Minimo valore inserito: %i\n"
    txtOpt8:     .asciz "Posizione del minimo valore inserito: %i\n"
    txtOpt9:     .asciz "Valore inserito con maggior frequenza: %i\n"
    txtOpt10:    .asciz "Media valori: %i\n"
    txtOptErr:   .asciz "Opzione non supportata dall'applicazione!\n"
    txtNewLine:  .asciz "\n"
    txtFormat:   .asciz "%i"
    vettore:           .fill 10, 4, 0   # [4bytes = 0]*10
    LUNGHEZZA_VETTORE: .long 10
    opzione:           .long 0   #scanf imposta i valori solo in memoria
 
    # 0000 | 01 F2 3A 4D
    # 0004 | 42 21 D0 2E
    # 0008 | 06 F2 88 05
    # 0012 | 7F E5 41 99

.section .text
    .global _start

_start: #Punto di partenza

    # lettura valori
    pushl LUNGHEZZA_VETTORE
    pushl $txtInput
    call printf
    addl $8, %esp

    # registri fissi
    movl $vettore, %ebx
    movl LUNGHEZZA_VETTORE, %edi # max

    # for
    xorl %esi, %esi # contatore
    mainForInput:
        cmpl %edi, %esi
        jge mainForInputEnd

        incl %esi
        pushl %esi
        pushl $txtInputFor
        call printf
        addl $8, %esp
        decl %esi
        
        # 2^2  ->  %esi<<2 = %esi*4  ->  vettore+(%esi*4)
        leal (%ebx,%esi,4), %eax
        pushl %eax
        pushl $txtFormat
        call scanf
        addl $8, %esp

        incl %esi
        jmp mainForInput
    mainForInputEnd:

    call stampaOpzioni

    # do
    mainDoSelect:
        pushl $txtSelect
        call printf
        addl $4, %esp

        pushl $opzione
        pushl $txtFormat
        call scanf
        addl $8, %esp
        
        call eseguiOpzione

        # while
        cmpl $0, opzione
        jne mainDoSelect

    end:
    movl $1, %eax #SYS_EXIT
    movl $0, %ebx #codice di errore (0 = successo)
    int $0x80    #esegui chiamata di sistema


stampaOpzioni:
    pushl $txtMenu
    call printf
    addl $4, %esp
    ret


eseguiOpzione:
    pushl $txtNewLine
    call printf
    addl $4, %esp

    # ri-applico registri fissi
    movl $vettore, %ebx
    movl LUNGHEZZA_VETTORE, %edi # max

    # switch
    movl $-1, %eax
    eseguiStampa:
        cmpl %eax, opzione
        jne esegui0
        eseguiError2:
            call stampaOpzioni
        jmp eseguiEnd

    esegui0:
        incl %eax
        cmpl %eax, opzione
        jne esegui1
            pushl $txtOpt0
            call printf
            addl $4, %esp
        jmp eseguiEnd

    esegui1:
        incl %eax
        cmpl %eax, opzione
        jne esegui2
            xorl %edx, %edx
            call stampaVettore
        jmp eseguiEnd

    esegui2:
        incl %eax
        cmpl %eax, opzione
        jne esegui3
            movl $1, %edx
            call stampaVettore
        jmp eseguiEnd

    esegui3:
        incl %eax
        cmpl %eax, opzione
        jne esegui4
            call numeroPari

            pushl %eax
            pushl $txtOpt3even
            call printf
            addl $4, %esp
            popl %eax
            
            subl %edi, %eax #eax -= edi
            neg %eax

            pushl %eax
            pushl $txtOpt3odd
            call printf
            addl $8, %esp
        jmp eseguiEnd

    esegui4:
        incl %eax
        cmpl %eax, opzione
        jne esegui5
        jmp eseguiEnd

    esegui5:
        incl %eax
        cmpl %eax, opzione
        jne esegui6
        jmp eseguiEnd

    esegui6:
        incl %eax
        cmpl %eax, opzione
        jne esegui7
        jmp eseguiEnd

    esegui7:
        incl %eax
        cmpl %eax, opzione
        jne esegui8
        jmp eseguiEnd

    esegui8:
        incl %eax
        cmpl %eax, opzione
        jne esegui9
        jmp eseguiEnd

    esegui9:
        incl %eax
        cmpl %eax, opzione
        jne esegui10
            pushl $txtOpt9
            call printf
            addl $4, %esp
        jmp eseguiEnd

    esegui10:
        incl %eax
        cmpl %eax, opzione
        jne eseguiError
            pushl $txtOpt10
            call printf
            addl $4, %esp
        jmp eseguiEnd
    
    eseguiError:
        pushl $txtOptErr
        call printf
        addl $4, %esp
        jmp eseguiError2

    eseguiEnd:
    ret
