/*************************
**PRIMA ESERCITAZIONE 
**************************/

USE CorsoSQL;

/*Struttura del database 
dbo.Clienti (IdCliente PK, Nome, Cognome, 
		 DataNascita, RegioneResidenza);
dbo.Prospect (IdProspect PK, Nome, Cognome, 
		  DataNascita, Nazione, FlagUE);
dbo.Fatture (IdFattura PK, Tipologia, Importo, 
		 Iva, IdCliente, DataFattura, NumeroFornitore);
dbo.Fornitori (IdFornitore PK, Denominazione, RegioneResidenza,
		   DataPrimaAcquisto, FornitoreAttivo, DataFineContratto)
dbo.Prodotti (IdProdotto PK, Descrizione, InProduzione, InCommercio, 
		  RegioneProduzione, DataAttivazione, DataDisattivazione, 
		  Costo, CentralitaBusiness)
*/

/*Esercizio 1
Estrarre il nome e il cognome dei clienti 
italiani nati nel 1982  */

SELECT Nome, Cognome
FROM dbo.Clienti
WHERE YEAR(DataNascita) = 1982;

/*Esercizio 2
Estrarre una colonna di nome "Denominazione" 
contenente il nome, seguito da un carattere "-", 
seguito dal cognome, per i soli clienti residenti 
nella regione Lombardia  */

SELECT (Nome + '-' + Cognome) AS Denominazione
FROM dbo.Clienti
WHERE RegioneResidenza = 'Lombardia';

/*Esercizio 3
Qual � il numero di fatture con iva al 20%  */

SELECT COUNT(*) AS NumeroFatture
FROM dbo.Fatture
WHERE Iva = 20;


/*Esercizio 4
Riportare il numero di fatture e la somma dei 
relativi importi divisi per anno di fatturazione.  */

SELECT YEAR(DataFattura) AS Anno, SUM(Importo) AS SommaImporti
FROM dbo.Fatture
GROUP BY YEAR(DataFattura);


/*Esercizio 5 
Estrarre i prodotti attivati nel 2017 e che sono 
in produzione oppure in commercio  */

SELECT *
FROM dbo.Prodotti
WHERE YEAR(DataAttivazione) = 2017
AND (InProduzione = 1 OR InCommercio = 1);


/*Esercizio 6
Estrarre il totale degli importi 
delle fatture divisi 
per residenza dei clienti  */

SELECT c.RegioneResidenza, SUM(f.Importo) AS TotaleImporto
FROM dbo.Clienti AS c  
INNER JOIN dbo.Fatture AS f
ON c.IdCliente = f.IdCliente
GROUP BY c.RegioneResidenza;


/*Esercizio 7
Estrarre il totale, la media e la deviazione
standard degli importi divisi per tipologia di fattura */

SELECT Tipologia, SUM(Importo) AS Totale, ROUND(AVG(Importo), 2) AS Media, ROUND(STDEV(Importo),2) AS DeviazioneStandard
FROM dbo.Fatture
GROUP BY Tipologia;


/*Esercizio 8 
Considerando soltanto le fatture con iva 
al 20 per cento, qual � il numero di fatture per ogni anno?*/

SELECT YEAR(DataFattura) AS Anno, COUNT(*) AS Conteggio
FROM dbo.Fatture
WHERE Iva = 20
GROUP BY YEAR(DataFattura);
 
 
/*Esercizio 9
In quali anni sono state registrate pi� di 
2 fatture con tipologia 'A'?  */

SELECT YEAR(DataFattura) AS Anno
FROM dbo.Fatture
WHERE Tipologia = 'A'
GROUP BY YEAR(DataFattura)
HAVING COUNT(*) > 2;


/*Esercizio 10
In quali regioni sono stati registrate 
fatture per pi� di 100 euro?   */

SELECT c.RegioneResidenza
FROM dbo.Fatture AS f
INNER JOIN dbo.Clienti AS c
ON f.IdCliente = c.IdCliente
GROUP BY c.RegioneResidenza
HAVING  SUM(Importo) > 100;

/*Esercizio 11 
Riportare l�elenco delle fatture (Id, importo, iva e data) 
con in aggiunta il nome del fornitore    */

SELECT f.IdFattura AS Id, 
	f.Importo AS importo,
	f.Iva AS iva,
	f.DataFattura AS data, 
	COALESCE(Fo.Denominazione,'Non disponibile') as NomeFornitore
FROM dbo.Fatture AS f  
LEFT JOIN dbo.Fornitori AS fo  
ON f.IdFornitore = fo.IdFornitore;

/*Esercizio 12
Riportare per ogni fornitore, il relativo nome, 
regione di residenza e numero di fatture associate.
Non mostrare i fornitori con meno di tre fatture   */

SELECT fo.Denominazione, fo.RegioneResidenza, COUNT(f.IdFattura) AS Conteggio
FROM dbo.Fornitori AS fo  
INNER JOIN dbo.Fatture AS f  
ON fo.IdFornitore = f.IdFornitore
GROUP BY fo.Denominazione, fo.RegioneResidenza
HAVING COUNT(f.IdFattura) > 2;

