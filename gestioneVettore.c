// ****************************
// filename: gestioneVettore.c
// ****************************
// Per compilare:
// gcc gestioneVettore.c -o gestioneVettore
// ****************************
// Per eseguire:
// ./gestioneVettore
// ****************************

/* Questo programma fornisce una semplice interfaccia utente per operare su un vettore 
   di interi. L'utente inserisce il vettore di interi all'avvio dell'applicazione e poi 
   opera su di esso per mezzo di un menu' testuale. */

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

#define LUNGHEZZA_VETTORE 10
int vettore[LUNGHEZZA_VETTORE];
	
void stampaOpzioni(void);
void eseguiOpzione(int opzione);
void stampaVettore(bool ordineInv);
int numeroPari(void); 
int cercaValore(int val);
int calcolaMax(void);
int posizioneMax(void);
int calcolaMin(void);
int posizioneMin(void);
int valoreFrequente(void);
int calcolaMediaIntera(void);

int main(void) {
    int opzione, i;
    
    // lettura valori
    printf("Inserimento dei %i interi che compongono il vettore...\n",LUNGHEZZA_VETTORE);
    for (i = 0; i < LUNGHEZZA_VETTORE; i++) {
        printf("Inserire l'intero in posizione %i: ", (i+1));
        scanf("%i", &vettore[i]);
    }

    /*i = 0;
    while (condizione) {
        {blocco di codice}
        i++;
    }*/

    
    
    // stampa menu' testuale con le varie opzioni
    stampaOpzioni();

    // selezione opzione
    do {
        printf("\nInserire valore operazione (0 uscita, -1 ristampa menu'): ");
        scanf("%i",&opzione);
        // esecuzione dell'opzione richiesta
        eseguiOpzione(opzione);
    } while (opzione != 0);
    
    return 0; // uscita senza errore
}

void stampaOpzioni(void) {

    // funzione che stampa le varie opzioni del programma sotto forma di un menu' testuale

    printf("\nOPERAZIONI DISPONIBILI\n");
    printf("----------------------\n");
    printf("1) stampa a video del vettore inserito\n");
    printf("2) stampa a video del vettore inserito in ordine inverso\n");
    printf("3) stampa il numero di valori pari e dispari inseriti\n");
    printf("4) stampa la posizione di un valore inserito dall'utente\n");
    printf("5) stampa il massimo valore inserito\n");
    printf("6) stampa la posizione del massimo valore inserito\n");
    printf("7) stampa il minimo valore inserito\n");
    printf("8) stampa la posizione del minimo valore inserito\n");
    printf("9) stampa il valore inserito con maggior frequenza\n");
    printf("10) stampa la media intera dei valori inseriti\n");
}

void eseguiOpzione(int opzione) {

    // funzione che esegue le varie opzioni del programma a seconda del valore contenuto in opzione

    bool stampaInOrdineInverso = true;
    int nPari,nDispari,valore,posizione,max,posMax,min,posMin,valFreq,valMedia,posValMedia;
    int media;

    printf("\n"); // per separare con una riga l'esecuzione di ogni comando
    switch (opzione) {
        case 0:
            printf("Uscita dall'applicazione...\n");
            break; // causa l'uscita dallo switch...
        case 1:
            stampaInOrdineInverso = false;
        case 2:
            stampaVettore(stampaInOrdineInverso);
            break;
        case 3:
            nPari = numeroPari();
            nDispari = LUNGHEZZA_VETTORE - nPari; // NB: non serve implementare una funzione per avere il numero dei dispari!
            printf("Numero di valori pari inseriti: %i\n", nPari);
            printf("Numero di valori dispari inseriti: %i\n", nDispari);
            break;
        case 4:
            printf("Inserire l'intero da cercare: "); 
            scanf("%i",&valore);
            posizione = cercaValore(valore);
            if (posizione >= 0)
                printf("Posizione del valore %i: %i\n",valore,(posizione+1));
            else
                printf("Valore %i non trovato\n",valore);
            break;
        case 5:
            max = calcolaMax();
            printf("Massimo valore inserito: %i\n", max);
            break;
        case 6:
            posMax = posizioneMax()+1;
            printf("Posizione del massimo valore inserito: %i\n", posMax);
            break;
        case 7:
            min = calcolaMin();
            printf("Minimo valore inserito: %i\n", min);
            break;
        case 8:
            posMin = posizioneMin()+1;
            printf("Posizione del minimo valore inserito: %i\n", posMin);
            break;
        case 9:
            valFreq = valoreFrequente();
            printf("lu\n", valFreq);
            break;
        case 10:
            media = calcolaMediaIntera();
            printf("Media valori: %i\n", media);
            break;
        default:
            // situazione di errore che si verifica quando l'utente inserisce un numero di opzione non supportato...
            printf("Opzione non supportata dall'applicazione!\n");
        case -1:
            stampaOpzioni();
            break;
    }
}

void stampaVettore(bool ordineInv) {
    /* Questa funzione stampa gli elementi del vettore.
       Quando ordineInv == true, gli elementi sono stampati in ordine inverso.*/
    int i;
    
    
    if (!ordineInv) {
        printf("Valori inseriti:\n");
        for (i = 0; i < LUNGHEZZA_VETTORE; i++)
            printf("Valore %i: %i\n", (i+1), vettore[i]);
    } else {
        printf("Valori inseriti (ordine di inserimento invertito):\n");
        for (i = LUNGHEZZA_VETTORE-1; i >= 0; i--)
            printf("Valore %i: %i\n", (i+1), vettore[i]);
    }
}

int numeroPari(void) {

    // Questa funzione restituisce il numero di elementi pari del vettore.

    int i,nPari = 0;

    for (i = 0; i < LUNGHEZZA_VETTORE; i++) {
        if (vettore[i] % 2 == 0)
            nPari++;
    }
    
    return nPari;
}

int cercaValore(int val) {

    /* Questa funzione restituisce la posizione dell'intero val nel vettore.
       Se l'intero non viene trovato, la posizione restituita è pari a -1.*/

    int i,pos = -1;

    for (i = 0; i < LUNGHEZZA_VETTORE; i++) {
        if (vettore[i] == val) {
            pos = i;
            break;
        }
    }
    
    return pos;
}

int calcolaMax(void) {

    // Questa funzione restituisce il valore massimo contenuto nel vettore.

    int i,max = vettore[0];

    for (i = 1; i < LUNGHEZZA_VETTORE; i++) {
        if (max < vettore[i])
            max = vettore[i];
    }
    
    return max;
}

int posizioneMax(void) {

    // Questa funzione restituisce la posizione del valore massimo contenuto nel vettore.
    
    return cercaValore(calcolaMax());
}

int calcolaMin(void) {

    // Questa funzione restituisce il valore minimo contenuto nel vettore.

    int i,min = vettore[0];

    for (i = 1; i < LUNGHEZZA_VETTORE; i++) {
        if (min > vettore[i])
            min = vettore[i];
    }
    
    return min;
}

int posizioneMin(void) {

    // Questa funzione restituisce la posizione del valore minimo contenuto nel vettore.
    
    return cercaValore(calcolaMin());
}

int valoreFrequente(void) {

    /* Questa funzione restituisce il valore inserito con maggior frequenza nel vettore.
       In caso di piu' valori che compaiono con la stessa frequenza, il programma ne ritorna uno soltanto.*/

    int i1, i2;
    int maxFreq = -1, freq = 0;
    int valFreq = 0;

    for (i1 = 0; i1 < LUNGHEZZA_VETTORE; i1++) {
        for (i2 = 0; i2 < LUNGHEZZA_VETTORE; i2++) {
            if (vettore[i1] == vettore[i2])
                freq++;
        }
        if (freq > maxFreq) {
            maxFreq = freq;
            valFreq = vettore[i1];
        }
        freq = 0;
    }
    
    return valFreq;
}

int calcolaMediaIntera(void) {

    // Questa funzione restituisce la media intera degli elementi del vettore.

    int somma = 0;
    int media;
    int i;

    for (i = 0; i < LUNGHEZZA_VETTORE; i++)
        somma += vettore[i];

    media = somma/LUNGHEZZA_VETTORE;
    
    return media;
}
