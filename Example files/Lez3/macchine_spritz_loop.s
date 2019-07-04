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
	.long 152				# numero studenti che aderiscono allo spritz (MAX 255!!!)

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
	addl $2, %esi			# la prima cifra della stringa che verra' modificata sara' la terza (ed ultima), modifico l'indirizzo aggiungendo 2 (mi sposto di 2 byte)

	# utilizzo un ciclo loop per svolgere le tre divisioni
	movl $10, %ebx			# salvo 10 in EBX per fare le divisioni ed estrarre le varie cifre
	movl $3, %ecx			# in ECX viene salvato il contatore per il ciclo
inizioCiclo:
	div %bl					# divido per 10 in byte, il risultato sarà in AL (quoziente) e AH (resto)
	addb $48, %ah			# sommo 48 al resto della divisione (prima cifra del numero)
	movb %ah, (%esi)		# sposto AH nella cifra corrispondente della stringa numAuto (indirizzamento diretto: uso direttamente l'indirizzo caricato in %esi)
	xorb %ah, %ah			# azzero il registro AH
	decl %esi				# vado 1 byte indietro per puntare alla cifra piu' significativa rispetto a quella appena modificata
	loop inizioCiclo		# ripeto la procedura precedente per altre due volte.

	# DOMANDA: a cosa punta l'indirizzo salvato in ESI a fine ciclo?

	# stampa a video titolo e risultati
	# devo stampare 3 cose (titolo, testo introduttivo e risultati)
	# potrei riusare un ciclo per comprimere il codice, ma se lo faccio ho un problema:
	# ECX verrebbe usato sia per il loop che per la syscall... per ora non siamo in grado
	# di risolvere questo problema... lasciamo quindi il codice come era
	
	# stampa a video del titolo

	movl $4, %eax			# syscall WRITE
	movl $1, %ebx			# terminale
	leal titolo, %ecx  		# carico l'indirizzo della stringa "titolo"
	movl titolo_len, %edx	# lunghezza della stringa
	int $0x80				# eseguo la syscall

	# stampa a video del testo introduttivo

	movl $4, %eax			# syscall WRITE (questa movl E' NECESSARIA perche' la syscall precedente cambia i valori dei registri!)
	movl $1, %ebx			# terminale (questa movl E' NECESSARIA perche' la syscall precedente cambia i valori dei registri!)
	leal testo, %ecx  		# carico l'indirizzo della stringa "testo"
	movl testo_len, %edx	# lunghezza della stringa
	int $0x80				# eseguo la syscall

	# stampa a video della variabile numAuto

	movl $4, %eax			# syscall WRITE (questa movl E' NECESSARIA perche' la syscall precedente cambia i valori dei registri!)
	movl $1, %ebx			# terminale (questa movl E' NECESSARIA perche' la syscall precedente cambia i valori dei registri!)
	leal numAuto, %ecx  	# carico l'indirizzo della stringa "numAuto"
	movl $4, %edx			# stringa di 3 caratteri + andata a capo (quindi lunghezza 4)
	int $0x80				# eseguo la syscall

	# termino il programma

	movl $1, %eax			# syscall EXIT
	movl $0, %ebx			# codice di uscita 0
	int $0x80				# eseguo la syscall
