# Funzione che converte una stringa di caratteri proveniente da
# tastiera in un numero che viene restituito nel registro eax

.section .data

stringa:
    .string "         " # stringa lunga 10 (9 spazi + '\0')

.section .text
.global atoi

.type atoi, @function 	# dichiarazione della funzione atoi
                      
atoi:   

pushl %ebx          	# salvo il valore corrente di ebx sullo stack
pushl %ecx          	# salvo il valore corrente di ecx sullo stack
pushl %edx          	# salvo il valore corrente di edx sullo stack
pushl %esi          	# salvo il valore corrente di esi sullo stack

# lettura stringa da tastiera
movl $3, %eax 			# chiamata read
movl $0, %ebx 			# leggo dallo standard input
movl $stringa, %ecx 	# metto i caratteri in stringa
movl $10, %edx 			# leggere al massimo 10 caratteri
int $0x80

# conversione in numero della stringa
movl %eax, %ecx 		# salvo in ecx quanti caratteri sono stati effettivamente immessi
decl %ecx 				# decremento per non contare anche l'invio (questo registro 
						# fungera' da contatore per il ciclo)
movl $0, %esi 			# contatore per scorrere le cifre della stringa
xorl %eax, %eax  		# azzero eax (il numero verra' salvato qui)
movl $10, %ebx 			# base 10 per le moltiplicazioni

ciclo:
mull %ebx 				# esegue %eax = %eax * %ebx ( = 10), mi serve per shiftare a sx 
						# le varie cifre aggiunte in eax
movb stringa(%esi), %dl	# carico un carattere dalla stringa
subl $48, %edx 			# converto da codice ASCII a cifra
addl %edx, %eax 		# aggiungo la cifra ad eax
inc %esi 				# incremento l'indice per andare avanti a scorrere la stringa
loopl ciclo

fine:
# ripristino dei registri salvati sullo stack, l'ordine delle pop deve essere inverso delle push
popl %esi           	# ripristino il valore di esi all'inizio della chiamata  
popl %edx           	# ripristino il valore di edx all'inizio della chiamata  
popl %ecx           	# ripristino il valore di ecx all'inizio della chiamata  
popl %ebx           	# ripristino il valore di ebx all'inizio della chiamata  

ret               		# fine della funzione atoi
                  		# l'esecuzione riprende dall'istruzione sucessiva
                  		# alla call che ha invocato atoi

