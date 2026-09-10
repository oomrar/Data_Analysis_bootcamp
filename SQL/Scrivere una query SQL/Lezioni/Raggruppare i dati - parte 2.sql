/*Esempio 5
Visualizzare il numero di righe presenti nella tabella Fatture*/
SELECT COUNT(*) AS NumeroRighe
FROM   dbo.Fatture;

/*Commento:
le funzioni di aggregazione COUNT, MIN, MAX, SUM, AVG possono
essere utilizzate anche senza GROUP BY. Il risultato sar� una sola riga
contenente il valore totale per tutto il contenuto della tabella 
(o per quelle righe che rispettano un'eventuale
condizione scritta nella WHERE).
La query seguente invece restituisce un errore perch� mescola una funzione 
di aggregazione e una colonna non raggruppata

SELECT COUNT(*) AS NumeroRighe, Importo
FROM   dbo.Fatture;
*/


/*Esempio 6:
Riportare il numero di clienti associati ad almeno una fattura
con importo superiore a 50 euro*/

SELECT COUNT(DISTINCT IdCliente) AS NumeroClienti
FROM   dbo.Fatture
WHERE  Importo > 50

/*Commento:
occorre fare molta attenzione perch� in questo caso COUNT(*) 
non restituisce il numero corretto. Il ragionamento � il seguente:
- COUNT(*) conta il numero di righe
- nella tabella fatture c'� una riga per ogni fattura
- quindi in questo caso COUNT(*) � il numero di fatture, 
non il numero di clienti.

Un cliente avrebbe potuto fare pi� fatture con importo superiore a 50�.
Per conteggiarlo una volta sola � necessario scrivere 
SELECT COUNT(DISTINCT IdCliente). */

/*Osservazione
Riscrivere la query senza Distinct non produce il risultato corretto.
Infatti scrivere
SELECT COUNT(IdCliente)
FROM   dbo.Fatture
WHERE  Importo > 50;

� solo una "scorciatoia" equivalente alla query

SELECT COUNT(*)
FROM   dbo.Fatture
WHERE  Importo > 50
	AND IdCliente IS NOT NULL;
*/


/*Esempio 7:
Calcolare la somma degli importi delle fatture del 2018*/

SELECT SUM(Importo) AS Importo
FROM   dbo.Fatture
WHERE  YEAR(DataFattura) = 2018;


/*Esempio 8:
riportare per ogni fornitore il numero di fatture emesse a marzo 2018*/
SELECT IdFornitore, 
	COUNT(*) AS Conteggio
FROM  dbo.Fatture
WHERE YEAR(DataFattura) = 2018 
AND   MONTH(DataFattura) =  3
GROUP BY IdFornitore;


/*Esempio 9
Riportare la somma degli importi raggruppati per anni e mesi,
considerando soltanto le fatture di tipologia A. */

SELECT YEAR(DataFattura) AS Anno, 
	MONTH(DataFattura) AS Mese,
	SUM(Importo) AS Fatturato
FROM  dbo.Fatture
WHERE Tipologia = 'A'
GROUP BY YEAR(DataFattura),
	MONTH(DataFattura);

/*Commento 
La query mostra che non c'� un numero massimo di colonne inseribili 
nella GROUP BY. Raggruppando per anno e mese avremo una riga per ogni
combinazione distinta di valori di YEAR(DataFattura) e MONTH(DataFattura)
presenti nella tabella di partenza e che rispettano il filtro
nella where.

Il filtro richiesto dalla domande riguarda le fatture. Si tratta di 
stabilire il perimetro a cui applicare la nostra analisi. 
Di conseguenza il filtro va inserito nella clausola WHERE. 
Un esempio di filtro che invece dovrei inserire nell'HAVING 
potrebbe essere 

"riportare solo gli anni e i mesi in cui l'importo
medio � maggiore di 10". 

In questo caso il soggetto del filtro sarebbe
"gli anni e i mesi" (cio� le colonne raggruppate) e il valore
da filtrare � una funzione di aggregazione come la media.*/

/*Osservazione
Il risultato della query precedente (come quello di una 
QUALSIASI ALTRA QUERY)
non ha un ordinamento pronosticabile. Per specificare un ordinamento
occorre inserire una clausola ORDER BY. Occorre sempre valutare se �
preferibile eseguire l'ordinamento in un linguaggio di front end, 
e non nel database*/

SELECT YEAR(DataFattura) AS Anno, 
	MONTH(DataFattura) AS Mese,
	SUM(Importo) AS Fatturato
FROM  dbo.Fatture
WHERE Tipologia = 'A'
GROUP BY YEAR(DataFattura),
	MONTH(DataFattura)
ORDER BY Anno, Mese;

/*L'order by � l'unica clausola in cui posso utilizzare
anche le rinomine definite nella select con l'AS */


/*Esempio 10
Riportare il fatturato del 2018 per ogni fornitore 
che ha registrato in quell'anno almeno 3 fatture */

SELECT   IdFornitore, 
	     SUM(Importo) AS Fatturato
FROM     dbo.Fatture 
WHERE    DataFattura >= '20180101' 
AND      DataFattura < '20190101'
GROUP BY IdFornitore
HAVING   COUNT(*)>=3; 


/*Esempio 11
Riportare l'anno con il fatturato maggiore */

SELECT TOP 1 YEAR(DataFattura) AS Anno, 
	     SUM(Importo) AS Fatturato
FROM     dbo.Fatture
GROUP BY YEAR(DataFattura)
ORDER BY Fatturato DESC;

/*Commento:
combinando le clausole ORDER BY e TOP possiamo svolgere 
tutta una classe di analisi come quella appena vista*/


SELECT TOP 1 WITH TIES YEAR(DataFattura) AS Anno, 
	     SUM(Importo) AS Fatturato
FROM     dbo.Fatture
GROUP BY YEAR(DataFattura)
ORDER BY Fatturato DESC;
 



