/*
VECTLIB.S
Questa libreria contiene le funzioni che servono ad interagire con il vettore.
*/

.section .data
    txtStvt1:  .asciz "Valori inseriti:\n"
    txtStvt2:  .asciz "Valori inseriti (ordine di inserimento invertito):\n"
    txtStvt3:  .asciz "Valore %i: %i\n"

.section .text
    .global stampaVettore
    .global numeroPari
    .global stampaPos

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

# TODO
stampaPos:
    # registri permamenti
    
    
    xorl %eax, %eax         # posizione
    xorl %esi, %esi         # indice
    # for
    