.section .data

n:
	.byte 12				# valore su cui calcolare il fattoriale (n<=12, vedi sotto!) 

titolo:
	.ascii "PROGRAMMA PER IL CALCOLO DEL FATTORIALE\n\n"

titolo_len:
	.long . - titolo		# lunghezza del titolo

testo:
	.ascii "Valore Richiesto: "

testo_len:
	.long . - testo			# lunghezza della stringa testo

stringaFatt:
	.ascii "0000000000\n"	# variabile di tipo ascii che conterra' il numero da stampare
							# uso 10 cifre, cosi' ci sta un numero inferiore a 2^32

.section .text
	.global _start

_start:

	xorl %eax, %eax
	movb n, %al				# carico n in al

	# inizio calcolo fattoriale
	cmp $0, %eax
	jne n_diverso_zero
	movl $1, %eax
	jmp fine

n_diverso_zero:
	movl %eax, %ecx
	movl $1, %eax

inizio:
	mull  %ecx          # eax = eax * ecx      
	# NB: sto trascurando i 32 bit piu' significativi del risultato 
	#     della moltiplicazione che sono in edx 
	#     quindi il numero n deve essere tale che
	#     n! sia minore di 2^32 (cioe' n<=12)
  loop inizio

fine:
	
	# fine del codice per il calcolo del fattoriale, il risultato si trova in EAX
	
	leal stringaFatt, %esi	# assegno al registro ESI l'indirizzo di memoria di "stringaFatt"
	addl $9, %esi			# la prima cifra della stringa che verra' modificata sara' la decima (ed ultima), modifico l'indirizzo aggiungendo 9 (mi sposto di 9 byte)

	# utilizzo un ciclo loop per svolgere le divisioni
	movl $10, %ebx			# salvo 10 in EBX per fare le divisioni ed estrarre le varie cifre
	movl $10, %ecx			# in ECX viene salvato il contatore per il ciclo (questa volta ciclo 10 volte)
	xorl %edx, %edx			# azzero EDX perche' viene usato dalla divisione in long
inizioCiclo:
	divl %ebx				# divido per 10 in long, il risultato sarà in EAX (quoziente) e EDX (resto)
	addl $48, %edx			# sommo 48 al resto della divisione (prima cifra del numero)
	movb %dl, (%esi)		# sposto DL nella cifra corrispondente della stringa (indirizzamento diretto: uso direttamente l'indirizzo caricato in %esi)
	xorl %edx, %edx			# azzero il registro AH
	decl %esi				# vado 1 byte indietro per puntare alla cifra piu' significativa rispetto a quella appena modificata
	loop inizioCiclo		# ripeto la procedura precedente per altre due volte.

	# stampa a video del titolo
	movl $4, %eax			# syscall WRITE
	movl $1, %ebx			# terminale
	leal titolo, %ecx  		# carico l'indirizzo della stringa "titolo"
	movl titolo_len, %edx	# lunghezza della stringa
	int $0x80				# eseguo la syscall

	# stampa a video del testo introduttivo
	movl $4, %eax			# syscall WRITE
	movl $1, %ebx			# terminale
	leal testo, %ecx  		# carico l'indirizzo della stringa "testo"
	movl testo_len, %edx	# lunghezza della stringa
	int $0x80				# eseguo la syscall

	# stampa a video della variabile stringaFatt
	movl $4, %eax			# syscall WRITE
	movl $1, %ebx			# terminale
	leal stringaFatt, %ecx  # carico l'indirizzo della stringa "stringaFatt"
	movl $11, %edx			# stringa di 10 caratteri + andata a capo (quindi lunghezza 11)
	int $0x80				# eseguo la syscall

	# termino il programma
	movl $1, %eax			# syscall EXIT
	movl $0, %ebx			# codice di uscita 0
	int $0x80				# eseguo la syscall
