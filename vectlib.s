/*
VECTLIB.S
uesta libreria contiene le funzioni che servono ad interagire con il vettore.
*/

.section .data
    txtStvt1:   	    .asciz "Valori inseriti:\n"
    txtStvt2:   	    .asciz "Valori inseriti (ordine di inserimento invertito):\n"
    txtStvt3:   	    .asciz "Valore %i: %i\n"
    lunghezza_vettore: 	    .word 10
    maxFreqStore:           .long 0

.section .text
    .global stampaVettore
    .global numeroPari
    .global cercaValore
    .global maxValue
    .global minValue
    .global maxFreq
    .global calcolaMediaIntera


# EDX: argomento funzione
# EAX: return funzione
# in ebx c'è già $vettore
# in edi c'è già LUNGHEZZA_VETTORE
stampaVettore:
    test %edx, %edx
    jne stvtInverso
        pushl $txtStvt1
            call printf
        addl $4, %esp

        # for
        xorl %esi, %esi
        stvtFor:
            cmpl %edi, %esi
            jge stvtEnd

            pushl (%ebx,%esi,4)
            incl %esi
            pushl %esi
            pushl $txtStvt3
            call printf
            addl $12, %esp
            decl %esi
            
            incl %esi
            jmp stvtFor
    stvtInverso:
        pushl $txtStvt2
        call printf
        addl $4, %esp

        # for
        movl %edi, %esi
        decl %esi
        stvtForInv:
            test %esi, %esi
            jl stvtEnd

            pushl (%ebx,%esi,4)
            incl %esi
            pushl %esi
            pushl $txtStvt3
            call printf
            addl $12, %esp
            decl %esi
            
            decl %esi
            jmp stvtForInv
    stvtEnd:
    ret 


numeroPari:
    xorl %eax, %eax
    xorl %esi, %esi
    # for
    npFor:
        cmpl %edi, %esi
        jz npEnd
        movl (%ebx,%esi,4), %edx
        test %edx, %edx
        jge npPos
            neg %edx
        npPos:
        # 000101011001011111[1] AND 1 = 000000000000000001
        and $1, %edx
        test %edx, %edx
        jg npOdd
            incl %eax
        npOdd:
        incl %esi
        jmp npFor
    npEnd:
    ret

# %eax: return funzione
# %ecx: input funzione ("Numero da cercare")
# %edx: argomento funzione
# %ebx: vettore
# %edi: lunghezza del vettore
cercaValore:
    xorl %esi, %esi
    xorl %eax, %eax
    xorl %edx, %edx
    # for
    cercaFor:
        cmpl %edi, %esi
        jge cercaEndSuccess

        cmpl (%ebx,%esi,4), %ecx
        jz cercaEndSuccess

        incl %esi
        jmp cercaFor

    cercaEndSuccess:
        incl %esi 
        ret

# %eax: numero massimo trovato
# %edx: argomento funzione
# %ebx: vettore
# %edi: lunghezza del vettore
# %esi: contatore array
maxValue:
    xorl %esi, %esi
    xorl %eax, %eax
    xorl %edx, %edx
    movl (%ebx,%esi,4), %eax
    incl %esi
    incl %edx

    maxFor:
        cmpl %edi, %esi
        jge maxEnd

        cmpl (%ebx,%esi,4), %eax
        jl maxUpdate

        incl %esi        
        jmp maxFor
    
    # nel caso in cui (%ebx,%esi,4) sia maggiore di %eax, il valore verrà spostato il valore in %eax.
    
    maxUpdate:
        movl (%ebx,%esi,4), %eax
        incl %esi
        movl %esi, %edx
        jmp maxFor

    maxEnd:
        ret


# %eax: numero minimo trovato
# %edx: argomento funzione
# %ebx: vettore
# %edi: lunghezza del vettore
# %esi: contatore array
minValue:
    xorl %esi, %esi
    xorl %eax, %eax
    xorl %edx, %edx
    movl (%ebx,%esi,4), %eax
    incl %esi
    incl %edx

    minFor:
        cmpl %edi, %esi
        jge minEnd

        cmpl (%ebx,%esi,4), %eax
        jg minUpdate

        incl %esi        
        jmp minFor
    
    # nel caso in cui (%ebx,%esi,4) sia maggiore di %eax, il valore verrà spostato il valore in %eax.
    
    minUpdate:
        movl (%ebx,%esi,4), %eax
        incl %esi
        movl %esi, %edx
        jmp minFor

    minEnd:
        ret
    
    # commentati sono pushl e popl: funzionano, ma sono ridondanti. Sono stati lasciati commentati
    # per leggibilità, per lasciare ad intendere che la mansione principale di eax è comunque di essere
    # un return ma, dato che in questo punto del ciclo eax non viene toccato, verrà sovrascritto e serve
    # solo per una comparazione, è completamente sicuro utilizzarlo ora.
    # Ad ogni modo, questo è un caso particolare: in qualsiasi altro caso, sarebbe stato
    # fondamentale pushare e poppare eax.
maxFreq:
    xorl %esi, %esi                     # i1
    xorl %ecx, %ecx                     # i2
    xorl %edx, %edx                     # freq
    xorl %eax, %eax                     # frequenza massima registrata fino ad ora
    movl $-1, maxFreqStore              # maxFreq = -1

    maxFreqForExt:                      # ciclo for esterno
        cmpl %edi, %esi                 # logica del ciclo
        jge maxFreqForExtEnd
        xorl %ecx, %ecx                 # i2 = 0

    maxFreqForInt:                      # ciclo for interno
        cmpl %edi, %ecx                 # logica del ciclo
        jge maxFreqForIntEnd

        # confronto
        # pushl %eax                    # ho finito i registri liberi: "prendo in prestito" edx
        movl (%ebx,%esi,4), %eax        # sposto il vettore in un registro per paragonarlo
        cmpl (%ebx,%ecx,4), %eax        # if (vettore[i1] == vettore[i2])
        jne maxFreqNewEcx               # cicla senza aumentare la frequenza
        # popl %eax                     # fatto - "rendo" edx

    maxFreqIncFreq:                     # incrementa la frequenza e cicla
        incl %edx                       # se è arrivato qui, i due vettori sono uguali. freq++
        incl %ecx                       # i2++
        jmp maxFreqForInt               # cicla
    
    maxFreqNewEcx:
        # popl %eax                     # "restituisco" eax, anche se la cosa è andata a buon fine
        incl %ecx                       # i2++
        jmp maxFreqForInt               # cicla

    maxFreqForIntEnd:
        cmpl maxFreqStore, %edx         # if freq > maxfreq
        jg maxFreqUpdate                # aggiorna la massima frequenza con i contenuti di edx
        jmp maxFreqiplusplus            # else, inizializza la frequenza e cicla tutto

    maxFreqUpdate:
        # maxFreq = freq
        movl (%ebx,%esi,4), %eax        # registro volatile, viene azzerato a ogni giro
        movl %edx, maxFreqStore         # variabile, dove viene tenuto per ora il valore

    maxFreqiplusplus:
        incl %esi                       # i1++
        xorl %edx, %edx                 # freq = 0
        jmp maxFreqForExt               # cicla

    maxFreqForExtEnd:
        ret


# EAX: return
# EBX: vettore
# ECX: somma
# EDX: 
# ESI: contatore
# EDI: lunghezza vettore
calcolaMediaIntera:
    xorl %esi, %esi
    xorl %eax, %eax
    xorl %ecx, %ecx
    xorl %edx, %edx
    
    calcolaMediaInteraFor:
        cmpl %edi, %esi
	    jge calcolaMediaInteraForEnd
    
	movl (%ebx,%esi,4), %edx	    
        addl %edx, %ecx

        incl %esi
        jmp calcolaMediaInteraFor

    calcolaMediaInteraForEnd:
        nop

    // media = somma/LUNGHEZZA_VETTORE;
    movl %ecx, %eax
    cdq
    idivw lunghezza_vettore
    
    ret
