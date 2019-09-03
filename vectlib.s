/*
VECTLIB.S
Questa libreria contiene le funzioni che servono ad interagire con il vettore.
*/

.section .data
    txtStvt1:   	.asciz "Valori inseriti:\n"
    txtStvt2:   	.asciz "Valori inseriti (ordine di inserimento invertito):\n"
    txtStvt3:   	.asciz "Valore %i: %i\n"
    txtFormat:  	.asciz " %i"
    txtTest:    	.asciz "test riuscito!\n"
    txtNewLn:   	.asciz "\n"
    valFreq:            .long 0
    lunghezza_vettore: 	.word 10	# usato solo se strettamente necessario.
    coso:		.asciz " X "

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
    movl (%ebx,%esi,4), %eax

    maxFor:
        cmpl %edi, %esi
        jge maxEnd

        cmpl (%ebx,%esi,4), %eax
        jl maxUpdate

        incl %esi        
        jmp maxFor
    
    #in caso in cui (%ebx,%esi,4) sia maggiore di %eax, il valore verrà spostato il valore in %eax.
    
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
    movl (%ebx,%esi,4), %eax

    minFor:
        cmpl %edi, %esi
        jge minEnd

        cmpl (%ebx,%esi,4), %eax
        jg minUpdate

        incl %esi        
        jmp minFor
    
    #in caso in cui (%ebx,%esi,4) sia maggiore di %eax, il valore verrà spostato il valore in %eax.
    
    minUpdate:
        movl (%ebx,%esi,4), %eax
        incl %esi
        movl %esi, %edx
        jmp minFor

    minEnd:
        ret

# EAX: Massima frequenza / Valore frequenza (return)
# EBX: Vettore
# ECX: Contatore ciclo interno (i2)
# EDX: Contatore della frequenza
# ESI: Contatore ciclo esterno (i1)
# EDI: Lunghezza vettore
maxFreq:
    xorl %esi, %esi
    xorl %eax, %eax
    xorl %edx, %edx

    //movl (%ebx,%esi,4), %eax

    #for
    maxFreqForExt:
        cmpl %edi, %esi
        jge maxFreqForExtEnd

        xorl %ecx, %ecx

        # confronto per frequenza massima
        cmpl %eax, %edx
        jg maxFreqUpdate

        jmp maxFreqForInt

        incl %esi
        xorl %edx, %edx
        jmp maxFreqForExt
        
        maxFreqUpdate:
            movl %edx, %eax
            // movl (%ebx,%esi,4), $valFreq


        maxFreqForInt:
            cmpl %edi, %ecx
            jge maxFreqForIntEnd
            
            //if...
            // cmpl (%ebx,%esi,4), (%ebx,%ecx,4)
            je cmpSuccess # incrementa in caso di uguaglianza
    
            incl %ecx
            jmp maxFreqForInt # incrementa SOLO in caso di non uguaglianza

        maxFreqForIntEnd:
            jmp maxFreqForExt

        cmpSuccess:
            incl %edx
            incl %ecx
            jmp maxFreqForInt

    maxFreqForExtEnd:
        movl $valFreq, %eax
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
