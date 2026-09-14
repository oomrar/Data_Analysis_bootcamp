/*Esempio 3
Estrarre tutte le fatture emesse a clienti nati a febbraio.
Visualizzare tutte le colonne della tabella Fatture
aggiungendo il nome e il cognome dei clienti*/

SELECT dbo.Fatture.*, dbo.Clienti.Nome, dbo.Clienti.Cognome 
FROM   dbo.Fatture
INNER JOIN dbo.Clienti
	ON dbo.Fatture.IdCliente = dbo.Clienti.IdCliente
WHERE  MONTH(dbo.Clienti.DataNascita) = 2;

/*Osservazione:
in questo caso non ha senso utilizzare la LEFT JOIN perché, anche
se ci fosse una fattura senza cliente associato (il che sarebbe
indice di un database con gravi problemi di qualità dei dati)
quest'ultima non potrebbe rispettare il filtro richiesto 
(cliente associato nato a febbraio)*/


/*Osservazione
Possiamo alleggerire notevolmente il codice delle query contenenti
JOIN utilizzando l'AS anche nella FROM. La query precedente
può essere ad esempio riscritta così */

SELECT Fa.*, Cl.Nome, Cl.Cognome 
FROM   dbo.Fatture AS Fa
INNER JOIN dbo.Clienti AS Cl
	ON Fa.IdCliente = Cl.IdCliente
WHERE  MONTH(Cl.DataNascita) = 2;


/*Esempio 4
Riportare per ogni anno il numero di clienti nati nel 1980 
che hanno associate almeno una fattura con importo superiore 
a 10 euro*/

SELECT YEAR(f.DataFattura) AS Anno,
	COUNT(DISTINCT f.IdCliente) AS NumeroClienti
FROM   dbo.Fatture AS f
INNER JOIN dbo.Clienti AS c
	on F.IdCliente = c.IdCliente
WHERE YEAR(C.DataNascita) = 1980
AND   f.importo > 10
GROUP BY YEAR(f.DataFattura);


/*Commento
il procedimento logico per scrivere la query può essere:

1) compilare la clausola FROM inserendo
le tabelle nelle quali sono presenti i dati oggetto di analisi. 
Se abbiamo più di una tabella, combinarle con
un opportuna join. Nel nostro caso
FROM   dbo.Fatture as f
INNER JOIN dbo.Clienti as c
	on F.IdCliente = C.IdCliente

2) inserire nella clausola WHERE i filtri pre-raggruppamento che
individuano il perimetro di analisi. Nel nostro caso

WHERE YEAR(C.DataNascita) = 1980
AND   F.importo > 10

3) la combinazione delle due tabelle inserite nella FROM porta ad avere
una fonte dati con una riga per ogni fattura. Poiché l'estrazione
richiesta vuole i dati divisi per anno, dovrò raggruppare per anno.
Nel nostro caso

GROUP BY YEAR(f.DataFattura)

4) Copiare e incollare quanto scritto nella GROUP BY nella SELECT. 
A questo punto aggiungere eventuali altre informazioni aggregate richieste 
tramite SUM, MIN, AVG, COUNT.
Nel nostro caso devo riportare il numero di clienti.
Dovrò scrivere quindi

SELECT YEAR(DataFattura), COUNT(DISTINCT F.IdCliente). 

Osserviamo che in questo caso COUNT(*) riporta un risultato 
errato perché avendo una riga per ogni fattura, COUNT(*) 
riporterà il numero di fatture, non quello dei clienti

5) Inserire rinomine nella select con AS per rendere l'output
più chiaro. Nel nostro caso

SELECT YEAR(f.DataFattura) as Anno,
	COUNT(Distinct IdCliente) as NumeroClienti

*/


/*ALTRE TIPOLOGIE DI JOIN
Le due query seguenti sono equivalenti: */

SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
LEFT JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;

SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fornitori
RIGHT JOIN dbo.Fatture
	ON dbo.Fornitori.IdFornitore = dbo.Fatture.IdFornitore;

/*La right join infatti restituisce:
- le combinazioni che rispettano la condizione di join
- le righe della tabella di destra che non hanno righe associate
nella tabella sinistra secondo la condizione di join.

Se voglio preservare le righe di entrambe le tabelle che non
hanno combinazioni disponibili devo usare una FULL JOIN.

Mettiamo a confronto queste quattro query:*/

--Solo combinazioni valide
SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
INNER JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;

--Combinazioni valide 
--più fatture senza fornitori associati
SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
LEFT JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;

--Combinazioni valide 
--più fornitori senza fatture associate
SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
RIGHT JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;

--Combinazioni valide 
--più fatture senza fornitori associati
--più fornitori senza fatture associate
SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
FULL JOIN dbo.Fornitori
	ON dbo.Fatture.IdFornitore = dbo.Fornitori.IdFornitore;


/*L'ultima tipologia di JOIN è la CROSS JOIN, equivalente
a separare le tabelle con una virgola. */

SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture, 
	   dbo.Fornitori

SELECT dbo.Fatture.*, dbo.Fornitori.Denominazione 
FROM   dbo.Fatture
CROSS JOIN dbo.Fornitori



/*Esempio 5
Riportare nome e cognome dei soggetti presenti nella tabella
clienti e nella tabella prospect */

SELECT Nome, Cognome
FROM   dbo.Clienti
	UNION ALL
SELECT Nome, Cognome
FROM   dbo.Prospect;

/*Commento
Spesso dobbiamo combinare le tabelle accodando semplicemente i dati 
"gli uni sotto gli altri". Per far questo basta inserire tra le due 
query la parola chiave UNION ALL. L'unico vincolo consiste nel fatto
che le due query devono avere entrambe lo stesso numero di colonne 
indicate nella SELECT. */ 


/*Esempio 6
Riportare nome e cognome dei soggetti presenti nella tabella
clienti e nella tabella prospect, indicando la provenienza 
in una terza colonna*/

SELECT Nome, Cognome, 'Clienti' AS TabellaProvenienza
FROM   dbo.Clienti
	UNION ALL
SELECT Nome, Cognome, 'Prospect' AS TabellaProvenienza
FROM   dbo.Prospect;

/*Commento
Questo esempio ci mostra come sia possibile inserire un valore costante
all'interno di una query, semplicemente racchiudendolo tra apici e 
assegnandogli un nome con l'AS*/

/*Osservazione
Le colonne di output seguono il nome della prima query.
Attenzione quindi ad "errori di distrazione". La query
seguente infatti viene eseguita senza errori, produce 
un output con le colonne Nome e Cognome ma contiene informazioni
sicuramente errate.*/
SELECT Nome, Cognome
FROM   dbo.Clienti
	UNION ALL
SELECT Cognome, Nome
FROM   dbo.Prospect;

/*Jolly
Occorre fare attenzione a non confondere UNION ALL con UNION.
La query seguente che utilizza UNION ha l'effetto aggiuntivo
di eliminare tutti i duplicati dal risultato finale, 
sia quelli generati dopo l'unione, sia quelli eventualmente
presenti già nelle tabelle di partenza*/

SELECT Nome, Cognome
FROM   dbo.Clienti
	UNION 
SELECT Cognome, Nome
FROM   dbo.Prospect;

/*Jolly
Analogamente ad UNION, possiamo utilizzare anche INTERSECT
ed EXCEPT. INTERSECT riporta i valori comuni alle due query, 
mentre EXCEPT riporta i valori presenti nella prima query e
non presenti nella seconda. 
Entrambe INTERSECT ed EXCEPT, come UNION, hanno l'effetto aggiuntivo
di eliminare i duplicati dall'output finale. */

SELECT Nome, Cognome
FROM   dbo.Clienti
	INTERSECT 
SELECT Nome, Cognome
FROM   dbo.Prospect;

SELECT Nome, Cognome
FROM   dbo.Clienti
	EXCEPT 
SELECT Nome, Cognome
FROM   dbo.Prospect;
