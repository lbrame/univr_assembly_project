.section .data

titolo:
	.ascii "PROGRAMMA PER CALCOLARE QUANTE MACCHINE SERVONO PER ANDARE A BERE LO SPRITZ\n\n"

titolo_len:
	.long . - titolo		# lunghezza del titolo

testo:
	.ascii "Totale auto richieste: "

testo_len:
	.long . - testo			# lunghezza della stringa testo

numStudenti:
	.long 150				# numero studenti che aderiscono allo spritz (MAX 255!!!)

studPerAuto:
	.long 5					# numero max studenti in ogni auto (mettere a 4 se vogliamo stare larghi!)

numAuto:
	.ascii "000\n"			# variabile di tipo ascii che conterra' il numero di auto da stampare

.section .text
	.global _start

_start:

	movl numStudenti, %eax	# metto in EAX il numero degli studenti

	# calcolo quante macchine servono, assumo che numStudenti sia esprimibile con 8 bit (minore di 256)

	movl studPerAuto, %ebx	# carico in EBX il numero max di persone che stanno in una auto
	div %bl					# divido per 5 in byte, il risultato sarà in AL (quoziente) e AH (resto)
	cmpb $0, %ah			# verifico se restano fuori delle persone (resto != 0)
	je continuazione

	incb %al				# se sono qui vuol dire che il resto e' diverso da zero e mi serve una macchina in piu'
	xorb %ah, %ah			# azzero il registro AH (cosa succede se mi dimentico di questa istruzione?)

continuazione:

	# Da qui in poi dovrei avere in AL il numero di macchine necessarie
	# Uso il trucco di successive divisioni per 10 per estrarre le cifre da stampare 
	# e convertirle in ASCII

	leal numAuto, %esi		# assegno al registro ESI l'indirizzo di memoria di "numAuto"

	movl $10, %ebx
	div %bl					# divido per 10 in byte, il risultato sarà in AL (quoziente) e AH (resto)
	addb $48, %ah			# sommo 48 al resto della divisione (prima cifra del numero)
	movb %ah, 2(%esi)		# sposto AH nel terzo byte della stringa numAuto (indirizzamento indicizzato: aggiungo 2 all'indirizzo caricato in %esi)
							# PS: cosa succede se invece scriviamo "movb %ah, 3(%esi)"? Sovrascriveremmo il carattere '\n' di numAuto!
	xorb %ah, %ah			# azzero il registro AH

	# ripeto la procedura precedente per altre due volte.

	div %bl					# divido per 10 in byte, il risultato sarà in AL (quoziente) e AH (resto)
	addb $48, %ah			# sommo 48 al resto della divisione
	movb %ah, 1(%esi)		# sposto AH nel secondo byte della stringa numAuto (indirizzamento indicizzato: aggiungo 1 all'indirizzo caricato in %esi)
	xorb %ah, %ah			# azzero il registro AH

	div %bl					# divido per 10 in byte, il risultato sarà in AL (quoziente) e AH (resto)
	addb $48, %ah			# sommo 48 al resto della divisione
	movb %ah, (%esi)		# sposto AH nel primo byte della stringa numAuto (indirizzamento diretto: uso direttamente l'indirizzo caricato in %esi)

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

	# stampa a video della variabile numAuto

	movl $4, %eax			# syscall WRITE
	movl $1, %ebx			# terminale
	leal numAuto, %ecx  	# carico l'indirizzo della stringa "numAuto"
	movl $4, %edx			# stringa di 3 caratteri + andata a capo (quindi lunghezza 4)
	int $0x80				# eseguo la syscall

	# termino il programma

	movl $1, %eax			# syscall EXIT
	movl $0, %ebx			# codice di uscita 0
	int $0x80				# eseguo la syscall
