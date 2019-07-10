.section .data
  array_len:   .long 10
  array:       .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  main_print_1:       .string "\n\nInserimento dei %d valori interi che compongono il vettore.\n\n"
  print_lettura_main: .string "Inserire l'intero in posizione %d: \n"

.section .text
  .global .start

_start:

  #1' printf del main.
  pushl array_len                       # Push lunghezza vettore
  pushl $main_print_1                   # Inserimento...vettore
  call printf
  addl $8, %esp


  # Ciclo for del main con lettura valori array.
  # for (i = 0; i < LUNGHEZZA_VETTORE; i++) 
  
  # Inizializzazione registri e variabili utili al ciclo
  xorl %ecx, %ecx                       # Azzero eax == i
  movl $10, %eax

  xorl %ebx, %ebx                       # A cosa cazzo mi serve lo sa solo dio

iniziociclo:
  # printf("Inserire l'intero in posizione %i: ", (i+1));
  pushl %eax
  pushl $print_lettura_main
  call printf
  addl $4, %esp

  
  loopl iniziociclo
# Fineciclo


_microdrop:
  movl $1, %eax
  movl $0, %ebx
  int $0x80
  