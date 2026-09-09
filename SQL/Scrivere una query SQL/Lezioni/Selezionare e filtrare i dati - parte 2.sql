/*Esempio 3
Estrarre nome e cognome dei clienti numero 1 e 5*/
SELECT Nome, Cognome
FROM   dbo.Clienti
WHERE  IdCliente = 1 
OR     IdCliente = 5;

/*Commento: 
quando eseguiamo filtri con valori numerici
NON dobbiamo utilizzare gli apici. Scriviamo dunque
semplicemente IdCliente = 1, invece di
IdCliente = '1' */

/*Scorciatoia:
possiamo riscrivere il codice precedente in modo
pi� veloce con il costrutto IN */
SELECT Nome, Cognome
FROM   dbo.Clienti
WHERE  IdCliente IN (1,5);


/*Esempio 4
Visualizzare tutte le colonne delle fatture emesse dal giorno
1 gennaio 2018 in poi */

SELECT *
FROM   dbo.Fatture
WHERE  DataFattura >= '20180101';

/*Commento
Quando scriviamo filtri su colonne di tipo "date", 
ricordiamoci di scrivere le date nel formato internazionale 
e standard AAAAMMDD.

Osserviamo che nei filtri possiamo utilizzare i seguenti simboli
=, >, <, >=, <=, <>, !=   */


/*Esempio 5
Visualizzare tutte le colonne delle fatture emesse nel 2018 */

SELECT *
FROM   dbo.Fatture
WHERE  YEAR(DataFattura) = 2018;

/*Commento
La colonna DataFatture contiene l'intera data, non solo l'anno. Sarebbe 
sbagliato dunque scrivere la query in questo modo
SELECT *
FROM   dbo.Fatture
WHERE  DataFattura = 2018;

Nella query corretta invece abbiamo applicato 
a DataFattura la funzione YEAR. Tale funzione ha lo scopo 
di convertire una data nel numero intero 
corrispondente al relativo anno*/

/*Osservazione
La query precedente pu� essere riscritta in questo modo,
evitando l'uso della funzione YEAR. */
SELECT *
FROM   dbo.Fatture
WHERE  DataFattura >= '20180101' 
AND    DataFattura < '20190101';  

/*Osservazione
In alcuni casi scrivere codice che NON utilizzi funzioni
potrebbe portare a dei miglioramenti delle performance 

Evitiamo invece di scrivere la query precedente in questo modo

SELECT *
FROM   dbo.Fatture
WHERE  DataFattura >= '20180101' 
and DataFattura <= '20181231';

perch� potenzialmente potrebbe portare a dei risultati errati se la 
colonna DataFattura contiene informazioni anche su ore minuti 
e secondi di registrazione
*/


/*Esempio 6.
Mail dal capo:
"L'ufficio fiscale mi ha confermato che le fatture devono 
avere tutte l'iva al 20 per cento. 
Per piacere mi controlli se c'� qualcuna errata?" */

SELECT *
FROM   dbo.Fatture
WHERE  IVA <> 20 OR IVA IS NULL;

/*Commento:
limitando il filtro a IVA <> 20, non avremmo estratto la riga
contenente NULL. 
In generale occorre fare molta attenzione nella gestione dei NULL.
Ad esempio le due query seguenti sono "errate" perch� restituiranno 
in tutti i casi zero righe */

SELECT *
FROM   dbo.Fatture
WHERE  IVA = NULL;

SELECT *
FROM   dbo.Fatture
WHERE  IVA <> NULL;

/*Per filtrare le righe con o senza NULL
bisogna utilizzare IS NULL oppure IS NOT NULL */
SELECT *
FROM   dbo.Fatture
WHERE  IVA IS NOT NULL;

SELECT *
FROM   dbo.Fatture
WHERE  IVA IS NULL;


/*Esempio 7
Estrarre nome e cognome dei clienti
il cui nome contiene la lettera "n" */

SELECT Nome, Cognome
FROM   dbo.Clienti
WHERE  Nome LIKE '%n%';

/*Commento
Abbiamo utilizzato un nuovo operatore di confronto: LIKE.
Per cercare i nomi che INIZIANO con "n" avrei dovuto scrivere
WHERE Nome LIKE 'n%'

Per cercare i nomi che TERMINANO con "n" avrei dovuto scrivere
WHERE Nome LIKE '%n'

Invece con il filtro usato nella query 
WHERE Nome LIKE '%n%'
estraiamo i record con la n in qualsiasi posizione
(iniziale, finale e al centro) */


/*Jolly
Con questa query estraiamo i clienti il cui nome
inizia con UN carattere , seguito da "i" e poi 
eventuali altri caratteri
*/

select *
from   dbo.Clienti
where  Nome like '_i%';






