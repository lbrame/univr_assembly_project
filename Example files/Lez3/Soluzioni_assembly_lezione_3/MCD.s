.section .data

titolo:
	.ascii "PROGRAMMA PER IL CALCOLO DEL MCD\n\n"

titolo_len:
	.long . - titolo		# lunghezza del titolo

testo:
	.ascii "Valore Richiesto: "

testo_len:
	.long . - testo			# lunghezza della stringa testo

stringaMCD:
	.ascii "000\n"			# variabile di tipo ascii che conterra' il numero da stampare

.section .text
	.global _start

_start:

	movl	$25, %eax
	movl	$30, %ebx

	# inizio codice per il MCD
	
	cmpl $0, %eax
	jne a_non_zero_b_forse
	cmpl $0, %ebx
	jne b_non_zero_a_zero
	movl $1, %ecx				# a e b sono entrambi zero --> MCD=1
	jmp fine
b_non_zero_a_zero:
	movl %ebx, %ecx				# a==0, b!=0 --> MCD=b
	jmp fine
a_non_zero_b_forse:
	cmpl $0, %ebx		
	jne a_non_zero_b_non_zero
	movl %eax, %ecx				# a!=0, b==0 --> MCD=a
	jmp fine
a_non_zero_b_non_zero:
	cmpl %eax, %ebx
	jne a_diverso_da_b
	movl %ebx, %ecx				# a==b, --> MCD=a=b
	jmp fine
a_diverso_da_b:
	jg a_minore_di_b			# se ebx e' maggiore di eax (notaz. AT&T) 
	subl %ebx, %eax				# a>b --> a=a-b
	jmp a_non_zero_b_non_zero
a_minore_di_b:
	subl %eax, %ebx				# a<b --> b=b-a		
	jmp a_non_zero_b_non_zero

fine:
	# fine codice per il MCD

	# converto in ascii il risultato che ora e' caricato in ECX
	# Uso il trucco di successive divisioni per 10 per estrarre le cifre da stampare 
	# e convertirle in ASCII
	
	movl %ecx, %eax			# per comodita' spoto il numero in EAX
	leal stringaMCD, %esi	# assegno al registro ESI l'indirizzo di memoria di "stringaMCD"
	addl $2, %esi			# la prima cifra della stringa che verra' modificata sara' la terza (ed ultima), modifico l'indirizzo aggiungendo 2 (mi sposto di 2 byte)

	# utilizzo un ciclo loop per svolgere le tre divisioni
	movl $10, %ebx			# salvo 10 in EBX per fare le divisioni ed estrarre le varie cifre
	movl $3, %ecx			# in ECX viene salvato il contatore per il ciclo
inizioCiclo:
	div %bl					# divido per 10 in byte, il risultato sarà in AL (quoziente) e AH (resto)
	addb $48, %ah			# sommo 48 al resto della divisione (prima cifra del numero)
	movb %ah, (%esi)		# sposto AH nella cifra corrispondente della stringa stringaMCD (indirizzamento diretto: uso direttamente l'indirizzo caricato in %esi)
	xorb %ah, %ah			# azzero il registro AH
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

	# stampa a video della variabile stringaMCD
	movl $4, %eax			# syscall WRITE
	movl $1, %ebx			# terminale
	leal stringaMCD, %ecx  	# carico l'indirizzo della stringa "stringaMCD"
	movl $4, %edx			# stringa di 3 caratteri + andata a capo (quindi lunghezza 4)
	int $0x80				# eseguo la syscall

	# termino il programma
	movl $1, %eax			# syscall EXIT
	movl $0, %ebx			# codice di uscita 0
	int $0x80				# eseguo la syscall
