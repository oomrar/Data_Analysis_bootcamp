
USE CorsoSQL;

/* 1 */
SELECT  Denominazione, RegioneResidenza
FROM dbo.Fornitori;

/* 2 */
SELECT Descrizione, Costo AS PrezzoUnitario
FROM dbo.Prodotti;

/* 3 */
SELECT TOP 3 *
FROM dbo.Fatture
ORDER BY Importo DESC;

/* 4 */
SELECT *
FROM dbo.Fornitori
ORDER BY DataPrimaAcquisto DESC;

/* 5 */
SELECT *
FROM dbo.Clienti
WHERE RegioneResidenza = 'Campania';

/* 6 */
SELECT *
FROM dbo.Prodotti
WHERE Costo = 20000;

/* 7 */
SELECT *
FROM dbo.Fatture
WHERE Importo <= 30;

/* 8 */
SELECT *
FROM dbo.Fornitori
WHERE FornitoreAttivo = 0 OR FornitoreAttivo IS NULL;


/* 9 */
SELECT *
FROM dbo.Fatture
WHERE Tipologia = 'A' AND Importo > 40;

/* 10 */
SELECT Nome, RegioneResidenza
FROM dbo.Clienti
WHERE RegioneResidenza = 'Piemonte' OR RegioneResidenza = 'Puglia';

/* 11 */
SELECT *
FROM dbo.Fatture
WHERE IdCliente IN(2,4,8);

/* 12 */
SELECT *
FROM dbo.Prodotti
WHERE InProduzione = 1 and RegioneProduzione = 'Puglia';

/* 13 */
SELECT * 
FROM dbo.Fornitori
WHERE DataPrimaAcquisto < '20160101';

/* 14 */
SELECT * 
FROM dbo.Prodotti
WHERE YEAR(DataAttivazione) = 2011;

/* 15 */
SELECT * 
FROM dbo.Fatture
WHERE DataFattura >= '20170101' AND DataFattura < '20180101';


/* 16 */
SELECT * 
FROM dbo.Prodotti
WHERE DataDisattivazione IS NOT NULL;

/* 17 */
SELECT * 
FROM dbo.Fatture
WHERE IdFornitore IS NULL;

/* 18 */
SELECT * 
FROM dbo.Prospect
WHERE Nazione IS NULL;

/* 19 */
SELECT *
FROM dbo.Clienti
WHERE Cognome LIKE '%i';

/* 20 */
SELECT * 
FROM dbo.Prospect
WHERE Nome LIKE '__a%';