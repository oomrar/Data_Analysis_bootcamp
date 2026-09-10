
USE CorsoSQL;

/* 1 */
SELECT SUM(Importo) AS ImportoComplessivo
FROM dbo.Fatture;

/* 2 */
SELECT AVG(Importo) AS ImportoMedio, MAX(Importo) AS ImportoMax
FROM dbo.Fatture
WHERE Tipologia = 'V';

/* 3 */
SELECT COUNT(*) AS FornitoriAttivi
FROM dbo.Fornitori
WHERE FornitoreAttivo = 1;

/* 4 */
SELECT COUNT(DISTINCT IdCliente) AS ClientiConFatture
FROM dbo.Fatture;

/* 5 */
SELECT RegioneResidenza, COUNT(*) AS NumeroClienti
FROM dbo.Clienti
GROUP BY RegioneResidenza;

/* 6 */
SELECT RegioneProduzione, COUNT(*) AS ProdottiRegistrati
FROM dbo.Prodotti
GROUP BY RegioneProduzione;

/* 7 */
SELECT IdFornitore, SUM(Importo) AS TotaleFatturato
FROM dbo.Fatture
GROUP BY IdFornitore;

/* 8 */
SELECT CentralitaBusiness, AVG(Costo) AS CostoMedio
FROM dbo.Prodotti
GROUP BY CentralitaBusiness;

/* 9 */
SELECT Nazione, COUNT(*) AS NumeroProspect
FROM dbo.Prospect
GROUP BY Nazione;

/* 10 */
SELECT IdFornitore, COUNT(*) AS NumeroFatture
FROM dbo.Fatture
WHERE Tipologia = 'A'
GROUP BY IdFornitore;

/* 11 */
SELECT IdCliente, SUM(Importo) AS FatturatoTotale 
FROM dbo.Fatture
WHERE YEAR(DataFattura) = 2017
GROUP BY IdCliente;

/* 12 */
SELECT RegioneProduzione, MAX(Costo) AS CostoMassimo
FROM dbo.Prodotti
WHERE InCommercio = 1
GROUP BY RegioneProduzione;

/* 13 */
SELECT RegioneResidenza, COUNT(*) AS ClientiNati
FROM dbo.Clienti
---WHERE DataNascita >= '19800101'
GROUP BY RegioneResidenza;

/* 14 */
SELECT Tipologia, Iva, COUNT(*) AS NumeroTotaleFatture, SUM(Importo) AS SommaImporti
FROM dbo.Fatture
GROUP BY Tipologia, Iva;

/* 15 */
SELECT YEAR(DataFattura) AS Anno, MONTH(DataFattura) AS Mese, SUM(Importo) AS SommaImporti
FROM dbo.Fatture
GROUP BY YEAR(DataFattura), MONTH(DataFattura);

/* 16 */
SELECT IdFornitore, YEAR(DataFattura) AS Anno, COUNT(*) AS FattureEmesse
FROM dbo.Fatture
GROUP BY IdFornitore,YEAR(DataFattura);

/* 17 */
SELECT RegioneResidenza
FROM dbo.Clienti
GROUP BY RegioneResidenza
HAVING COUNT(*) >2;

/* 18 */
SELECT YEAR(DataFattura) AS Anno
FROM dbo.Fatture
GROUP BY YEAR(DataFattura)
HAVING AVG(Importo) > 30;

/* 19 */
SELECT IdCliente
FROM dbo.Fatture
GROUP BY IdCliente
HAVING COUNT(*) >= 3;

/* 20 */
SELECT TOP 1 WITH TIES RegioneResidenza, COUNT(*) AS Clienti
FROM dbo.Clienti
GROUP BY RegioneResidenza
ORDER BY COUNT(*) DESC;