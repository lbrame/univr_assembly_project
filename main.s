.section .data

array_len:
  .long 10

array:
  .long 1,2,3,4,5,6,7,8,9,10

main_print_1:
  .string "Inserimento dei %d interi che compongono il vettore...\n"

print_lettura_main:
  .string "Inaserire l'intero in posizione %d: "

count:
  .long 0

posizione:


formato:

  .ascii "000\n"

.section .text
  .global _start

_start:

                                    # main()
  # Printf Inserimento dei 10 interi che compongono il vettore...
  pushl array_len                   # Formato, %1, lunghezza dell'array
  pushl $main_print_1               # printf("Inserimento...\n")
  call printf                       # Chiama funzione C `printf`
  addl $8, %esp                     # 2 push --> aggiungo 8 bit ad esp per ripristinarlo

  # Ciclo - inizializzazione
  xorb %cl, %cl                     # Azzero %cl (contatore)
  xorw %bx, %bx                     # Azzero %bx (accumulatore)

  # Lettura valori
iniziociclo:

  addl $array_len, %ecx  # for fino al numero di elementi nel vettore

  cmpb array_len, %cl
  je fineciclo             # Condizione di controllo
    
    # printf("Inserire l'intero in posizione %i: ", (i+1));
    incb count 
    # printf 
    pushl $print_lettura_main
    call printf
    addl $8, %esp

    # scanf
    pushl $array
    pushl $formato
    call scanf
    addl $8, %esp



    incb %cl                          # Contatore++
    loop iniziociclo                  # ecx--, if(ecx==0), jmp lbl

fineciclo:



stampaOpzioni:
eseguiOpzione:
stampaVettore:
numeroPari:
cercaValore:
calcoloMax:
posizioneMax:
calcoloMin:
valoreFrequente:
calcoloMediaIntera:



_micdrop:
  movl $1, %eax
  movl $0, %ebx
  int $0x80
  
