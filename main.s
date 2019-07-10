.section .bss
  posizione: .byte 
  ecxval: .long

.section .data
  array_len:          .long 10
  # array:              .fill 10,1,0
  array:              .long 0,0,0,0,0,0,0,0,0,0
  main_print_1:       .string "Inserimento dei %d valori interi che compongono il vettore.\n\n"
  print_lettura_main: .string "Inserire l'intero in posizione %d: \n"
  print_ecx:          .string "ecx = %d \n"
  formato:            .ascii "000\n"

.section .text
  .global _start

_start:
  ##################
  # int main(void) #
  ##################
    
  #1. printf("Inserimento...\n")
  pushl array_len
  pushl $main_print_1              
  call printf                       # Chiama funzione C `printf`
  addl $8, %esp                     # 2 push --> aggiungo 8 bit ad esp per ripristinarlo

  
  # Ciclo - inizializzazione
  # xorl %ebx, %ebx                 # Inizializzzo ebx che uso come contatore
  # xorb %cl, %cl                   # Azzero %cl (contatore)
  xorw %bx, %bx                     # Azzero %bx (accumulatore)
  
  xorl %ecx, %ecx                   # Azzero %ecx
  movl $10, %ecx                    # Assegno a %ecx il valore 10
  
  movl $0, %esi                     # thonk

# Inizio un ciclo per leggere 10 valori
# for (i = 0; i < LUNGHEZZA_VETTORE; i++) {
iniziociclo:
  
  # Printf Inserimento dei 10 interi che compongono il vettore...
  pushl posizione                   # Formato, %i, lunghezza dell'array
  pushl $print_lettura_main         # printf("Inserimento...\n")
  call printf                       # Chiama funzione C `printf`
  addl $8, %esp                     # 2 push --> aggiungo 8 bit ad esp per ripristinarlo
    
  # Debugging: stampo ecx
   /*movl %ecx, ecxval
   pushl ecxval
   pushl print_ecx
   call printf
   addl $8, %esp*/
  

  # scanf("%i", &vettore[i]);
  pushl array(%esi)
  pushl $formato
  call scanf
  addl $8, %esp

  
  # Cicla fino a quando la somma non è zero (non è bello ma funziona)

  #subl %ecx                 # Incremento ecx, che uso come contatore
  incl posizione
  addl $4, %esi

  loop iniziociclo



#loopl iniziociclo


# no lmao sti cosi qua li metto nei file separati dopo
stampaOpzioni:
eseguiOpzione:
stampaVettore:
numeroPari:
cercaValore:
calcoloMax:
posizioneMax:
calcoloMin:
valoreFrequente:
calcoloMediaInntera:



_microdrop:
  movl $1, %eax
  movl $0, %ebx
  int $0x80
  