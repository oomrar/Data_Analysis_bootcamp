----------------------------------------------------------------------
--LEZIONE 3: COMBINARE DATI DI PIÙ TABELLE
--PAROLA CHIAVE: JOIN
--ALTRI COSTRUTTI: INNER JOIN, LEFT JOIN, RIGHT JOIN, ON, UNION ALL
---------------------------------------------------------------------

USE CorsoSql

/*Per riportare in una sola query le informazioni contenute 
in più colonne, le abbiamo scritte separate con una virgola 
all'interno della SELECT.

Analogamente, per riportare informazioni contenute in più tabelle,
potremmo pensare di scriverle nella FROM e separarle anche in questo
caso da una virgola.

Lanciamo le tre query in basso e analizziamo il risultato*/

SELECT *
FROM   dbo.Fatture

SELECT *
FROM   dbo.Clienti

SELECT *
FROM   dbo.Fatture, dbo.Clienti

/*L'ultima query combina i dati delle due tabelle. Tuttavia
molti record non hanno ragione di esistere. Ad esempio a lato dei
dati della fattura 1, vorremmo vedere solo i dati del cliente 1
perché è quello l'unico cliente a cui è stata emessa la fattura 
(questa informazione è presente nella colonna IdCliente della 
tabella Fatture). 
A tal fine, potrei pensare di filtrare i dati così ottenuti 
con una WHERE. Lanciamo questa query*/

SELECT *
FROM   dbo.Fatture, dbo.Clienti
WHERE  dbo.Fatture.IdCliente = dbo.Clienti.IdCliente

/*Il risultato è quello desiderato. Scriviamo ora 
un'altra sintassi completamente equivalente per raggiungere
lo stesso obiettivo*/

SELECT *
FROM   dbo.Fatture 
INNER JOIN dbo.Clienti
	ON  dbo.Fatture.IdCliente = dbo.Clienti.IdCliente

/* Sostanzialmente ho sostituito la virgola con "INNER JOIN"
e inserito il filtro all'interno di una clausola ON presente nella FROM.
Questa sintassi ha innumerevoli vantaggi che vedremo durante il corso*/

/*Esempio 1
Visualizzare tutte le colonne della tabella fatture
aggiungendo il nome e il cognome dei clienti */

SELECT dbo.Fatture.*, dbo.Clienti.Nome, dbo.Clienti.Cognome 
FROM dbo.Fatture
INNER JOIN dbo.Clienti
	ON dbo.Fatture.IdCliente = dbo.Clienti.IdCliente;


/*Esempio 2
Visualizzare tutte le colonne della tabella fatture
aggiungendo il nome del fornitore */

/*Sembrerebbe un caso analogo al precedente, ma analizzando
l'output della query seguente possiamo osservare 
che c'è qualcosa che non va*/

SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
INNER JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;

/*Le fatture 12 e 13 sono sparite. Analizzando i record
sulla sola tabella fattura, vediamo che non hanno un 
fornitore associato */

SELECT * 
FROM   dbo.Fatture
WHERE  IdFattura IN (12, 13)

/*
Utilizzando una inner join queste due fatture NON SARANNO VISIBILI.
Prima abbiamo detto che la query con la INNER JOIN è equivalente a

SELECT Fatture.*, Fornitori.Denominazione 
FROM Fatture, Fornitori
WHERE Fatture.IdFornitore=Fornitori.IdFornitore;

e abbiamo già visto che un filtro del tipo "colonna = null" 
non restituisce mai risultati. 

Per preservare le due fatture senza fornitori associati devo 
cambiare la tipologia di JOIN: da INNER JOIN devo passare a LEFT JOIN.

Ecco un primo grande vantaggio della sintassi che utilizza le 
tipologie di JOIN invece della virgola e del WHERE*/

SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
LEFT JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;

/*Utilizzando LEFT join  SARANNO VISIBILI ANCHE 
le fatture per le quali la colonna IdFornitore:
1) è null 
2) contiene valori non presenti nella colonna IdFornitore
della tabella Fornitori  */

/*Ricorda:
Se non specifico la tipologia di JOIN, sarà eseguita una INNER JOIN
Ad esempio la query seguente esegue una INNER JOIN

SELECT dbo.Fatture.*, dbo.Clienti.Nome, dbo.Clienti.Cognome 
FROM dbo.Fatture
JOIN dbo.Clienti
	ON dbo.Fatture.IdCliente = dbo.Clienti.IdCliente;

Per ragioni di chiarezza, leggibilità e manutenibilità del codice, 
consiglio di specificare sempre la tipologia di JOIN
*/

