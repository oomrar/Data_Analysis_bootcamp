---------------------------------------------------
--LEZIONE 5: PROGETTARE E CREARE UN NUOVO DATABASE
--CREATE, ALTER, DROP, TRUNCATE
--INT, DATE, DECIMAL(18,2), VARCHAR(50)
--PRIMARY KEY, FOREIGN KEY, NULL/NOT NULL,CHECK
---------------------------------------------------

/*Finora abbiamo studiato come scrivere codice SQL per interrogare
le tabelle di un database già esistente. Vediamo ora come scrivere
codice SQL per creare dall'inizio un nuovo database e le relative tabelle.

Le istruzioni principali sono
CREATE --> creare tabella/oggetti 
DROP   --> eliminare tabella/oggetti
ALTER  --> modifica tabella/oggetti
TRUNCATE --> svuotare il contenuti una tabella, 
			 senza eliminarne il contenuto 
*/

/*Primo step: creare il database*/
CREATE DATABASE Cinematografia;
GO

/*Dopo aver creato il database è fondamentale lanciare questa
istruzione, in modo che le prossime query creino le tabelle
sul nuovo database Cinematografia appena creato */
USE Cinematografia;


/*Secondo step: creare le tabelle che rappresentano le entità
del database*/

CREATE TABLE dbo.Attori (
	IdAttore int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL,
	DataNascita date NULL);

/* TIPI DI UNA COLONNA
Dopo ogni colonna è indicato il tipo. I tipi utilizzati più
frequentemente sono

int           -> interi
varchar(50)   -> stringhe lunghe al più 50 caratteri
date          -> date senza orario (su Oracle sarebbe diverso)
decimal(18,2) -> numeri decimali con 18 cifre totali di cui
                 al più 2 decimali
datetime      -> date con indicazione dell'orario

Il tipo di una colonna è in ultima analisi un VINCOLO: 
vincoliamo le colonne ad ammettere solo alcune tipologie di dati. 
Ad esempio in una colonna di tipo int non possiamo inserire un valore 
che non sia un numero intero. La scelta del tipo di una colonna
è dunque un aspetto cruciale per garantire che i dati del database
abbiano una qualità minima necessaria per poter svolgere attività di analisi 
dei dati*/

/*NOT NULL / NULL 
Indicare di fianco ad una colonna l'opzione NOT NULL significa 
garantire che la colonna non potrà mai contenenere NULL. Viceversa,
specificando NULL teniamo aperta questa possibilità. Non specificare
nessuna delle due opzioni equivale a specificare NULL. */

/*CHIAVE PRIMARIA
Inserire un vincolo di chiave primaria su una colonna significa
garantire che in quella colonna non potrà mai essere presente lo
stesso valore in più di una riga della tabella. 
Inoltre in una colonna chiave primaria non può essere presente NULL.

La chiave primaria può essere definita anche su un insieme di colonne,
in questo caso non potrà ripetersi la combinazione di valori presenti
in quelle colonne. */

/*IDENTITY(1,1)
Se in una colonna indichiamo l'opzione IDENTITY(1,1) stiamo chiedendo
al database di valorizzare automaticamente quella colonna tramite un 
numero progressivo che parte da 1 e si incrementa di 1 ad ogni tentativo
di inserimento*/

/*Creiamo altre due tabelle */
CREATE TABLE dbo.Registi(
	IdRegista INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL, 
	DataNascita DATE NULL);

CREATE TABLE dbo.Film (
    IdFilm INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Titolo VARCHAR(100) NOT NULL,
	AnnoProduzione INT NULL,
	DataUscita DATE NULL,
	DurataMinuti DECIMAL(18,2) NULL);

/*ATTENZIONE
Per le colonne contenenti importi monetari in euro,
in molti casi può essere una buona scelta usare il tipo
DECIMAL(18,4). Le quattro cifre decimali disponibili
ci danno anche un'ulteriore flessibilità nel caso debba
implementare approssimazioni particolari.
*/
