-----------------------------------------------------------------------
--LEZIONE 2: AGGREGARE I DATI DI UNA TABELLA
--PAROLA CHIAVE: GROUP BY
--ALTRI COSTRUTTI: HAVING, COUNT(*), SUM, AVG, MIN, MAX, TOP, ORDER BY
-----------------------------------------------------------------------
USE CorsoSQL

/*Esempio 1 
Riportare per ogni anno il numero di fatture emesse */
SELECT YEAR(DataFattura) as Anno, 
	COUNT(*) AS Conteggio
FROM     dbo.Fatture
GROUP BY YEAR(DataFattura);

/*Commento:
poich� la domanda chiede di riportare delle informazioni 
"per ogni anno", l'output della nostra query dovr� avere
tante righe quanti sono i valori distinti della colonna
YEAR(DataFattura). 
Nella tabella Fatture abbiamo di default una riga per ogni fattura,
per restituire un output che abbia una riga per ogni anno
devo inserire la clausola GROUP BY.
Il processo di scrittura di questa query prevede quindi di 
1) compilare la clausola from
2) compilare la clausola group by
3) fare copia e incolla nella select di ci� che c'� nella group by 
4) aggiungere nella select altre informazioni aggregate utilizzando
SUM, AVG, MIN, MAX, COUNT.

Count(*) conta in generale il numero di righe in cui ogni valore
della colonna raggruppata � presente. Poich� nella tabella delle fatture
c'� una riga per ogni fattura, in questo contesto count(*) conta
il numero di fatture  */

/*Facciamo un'ulteriore considerazione sulla frase
"fare copia e incolla nella select di ci� che c'� nella group by"
Verifichiamo infatti che provando a lanciare la query 
senza GROUP BY otteniamo un errore. 

SELECT YEAR(DataFattura) as Anno, 
	COUNT(*) AS Conteggio
FROM   dbo.Fatture;
*/

/*Invece se non inseriamo le colonne raggruppate nella select, 
l'output della query diventa ininterpretabile.*/

SELECT   COUNT(*) AS Conteggio
FROM     dbo.Fatture
GROUP BY YEAR(DataFattura);


/*Esempio2
Riportare per ogni anno il numero di fatture 
emesse e la somma degli importi */

SELECT YEAR(DataFattura) AS Anno, 
	COUNT(*) AS Conteggio,
	SUM(Importo) AS TotaleImporto
FROM     dbo.Fatture
GROUP BY YEAR(DataFattura);


/*Esempio 3 
Riportare il numero di Clienti italiani per ogni Regione */

SELECT   RegioneResidenza, 
	COUNT(*) AS NumeroClienti
FROM     dbo.Clienti
GROUP BY RegioneResidenza;


/*Esempio 4
Riportare le regioni con almeno tre Clienti*/

SELECT RegioneResidenza, 
	COUNT(*) AS NumeroClienti
FROM   dbo.Clienti
GROUP BY RegioneResidenza
HAVING COUNT(*)>=3;

/*Commento: in questo caso ci viene richiesto il filtro
"riportare solo le regioni che hanno almeno tre clienti"
Osserviamo che questo filtro � diverso da quelli visti
nella sezione precedente, in quanto deve essere applicato 
su un insieme di dati gi� raggruppato. 
Si tratta infatti di un filtro "sui dati divisi per regione", 
e non sui dati originali della tabella clienti dove � presente
una riga per ogni cliente. 
Per questa nuova tipologia di filtri su dati raggruppati occorre 
utilizzare la clausola HAVING. */

