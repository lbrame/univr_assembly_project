.section .bss
  posizione: .long 0
  ecxval: .long 0

.section .data
  array_len:          .long 10
  #array:              .fill 10,1,0
  array:              .long 0,0,0,0,0,0,0,0,0,0
  main_print_1:       .string "Inserimento dei %d valori interi che compongono il vettore.\n\n"
  print_lettura_main: .string "Inserire l'intero in posizione %d: \n"
  print_ecx:          .string "ecx = %d \n"
  formato:            .string "%d"

.section .text
  .global _start

_start:
  ##################
  #          int main(void)          #
  ##################
    
  #1. printf("Inserimento...\n")
  pushl array_len
  pushl $main_print_1              
  call printf                               # Chiama funzione C `printf`
  addl $8, %esp                     # 2 push --> aggiungo 8 bit ad esp per ripristinarlo

  
  # Ciclo - inizializzazione
  xorl %ecx, %ecx                   # Azzero %ecx
  xorl %esi, %esi                   # Inizializzo esi

  # Inizio un ciclo per leggere 10 valori
  # for (i = 0; i < LUNGHEZZA_VETTORE; i++) {
iniziociclo:
  cmpl $9, %ecx
  je fineciclo

  # Printf Inserimento dei 10 interi che compongono il vettore...
  pushl posizione                   # Formato, %i, lunghezza dell'array
  pushl $print_lettura_main         # printf("Inserimento...\n")
  call printf                       # Chiama funzione C `printf`
  addl $8, %esp                     # 2 push --> aggiungo 8 bit ad esp per ripristinarlo  

  # scanf("%i", &vettore[i]);
  leal array(%esi), %edx            # Carico l'indirizzo effettivo del registro esi in edx
  pushl %edx                        # Pusho edx sullo stack
  pushl $formato                    # %d
  call scanf                        # Chiamo la scanf
  addl $4, %esp                     # 1 push = 4


  incl posizione
  addl $4, %esi
  incl %ecx

  jmp iniziociclo



fineciclo:









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
  