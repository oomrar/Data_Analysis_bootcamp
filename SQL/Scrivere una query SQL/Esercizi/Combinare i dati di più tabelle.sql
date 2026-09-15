USE CorsoSQL

/* 1 */
SELECT f.IdFattura, f.Importo, f.DataFattura, c.Nome, c.Cognome, c.RegioneResidenza
FROM dbo.Fatture AS f
INNER JOIN dbo.Clienti AS c
    ON f.IdCliente = c.IdCliente;


/* 2 */
SELECT fa.IdFattura, fa.Importo, fo.Denominazione
FROM dbo.Fatture AS fa 
LEFT JOIN dbo.Fornitori AS fo
    ON fa.IdFornitore = fo.IdFornitore;


/* 3 */
SELECT fa.IdFattura, fa.DataFattura, fo.Denominazione
FROM dbo.Fatture AS fa 
INNER JOIN dbo.Fornitori AS fo
    ON fa.IdFornitore = fo.IdFornitore
WHERE fo.FornitoreAttivo = 1;


/* 4 */
SELECT fo.Denominazione, fa.IdFattura
FROM dbo.Fornitori AS fo
LEFT JOIN dbo.Fatture AS fa
    ON fo.IdFornitore = fa.IdFornitore;


/* 5 */
SELECT f.IdFattura, f.Importo, c.Nome, c.Cognome
FROM dbo.Fatture AS f
INNER JOIN dbo.Clienti AS c
    ON f.IdCliente = c.IdCliente
WHERE c.RegioneResidenza = 'Campania';


/* 6 */
SELECT fa.IdFattura, fa.Importo
FROM dbo.Fatture AS fa
INNER JOIN dbo.Fornitori AS fo
    ON fa.IdFornitore = fo.IdFornitore
WHERE fa.Tipologia = 'V'
AND fo.RegioneResidenza = 'Lombardia';


/* 7 */
SELECT c.Nome, c.Cognome, c.DataNascita, f.Importo
FROM dbo.Fatture AS f
INNER JOIN dbo.Clienti AS c
    ON f.IdCliente = c.IdCliente
WHERE f.Importo > 50
AND c.DataNascita < '19820101';


/* 8 */
SELECT fa.IdFattura, fa.DataFattura, fo.Denominazione 
FROM dbo.Fatture AS fa
LEFT JOIN dbo.Fornitori AS fo
    ON fa.IdFornitore = fo.IdFornitore
WHERE fo.IdFornitore IS NULL
OR fo.FornitoreAttivo = 0
AND fa.DataFattura >= '20180101';


/* 9 */
SELECT c.IdCliente, c.Nome, c.Cognome, SUM(f.Importo) AS FatturatoComplessivo
FROM dbo.Clienti AS c
INNER JOIN dbo.Fatture AS f
    ON c.IdCliente = f.IdCliente
GROUP BY c.IdCliente, c.Nome, c.Cognome


/* 10 */
SELECT c.RegioneResidenza, COUNT(DISTINCT c.IdCliente) AS ClientiConFattura
FROM dbo.Clienti AS c
INNER JOIN dbo.Fatture AS f
    ON c.IdCliente = f.IdCliente
GROUP BY c.RegioneResidenza 


/* 11 */
SELECT fo.Denominazione, AVG(fa.Importo) AS Importo
FROM dbo.Fatture AS fa
FULL JOIN dbo.Fornitori AS fo
    ON fa.IdFornitore = fo.IdFornitore
GROUP BY fo.Denominazione;


/* 12 */
SELECT YEAR(f.DataFattura) AS Anno, c.RegioneResidenza, SUM(f.Importo) AS SommaImporti
FROM dbo.Fatture AS f   
INNER JOIN dbo.Clienti AS c 
    ON f.IdCliente = c.IdCliente
GROUP BY YEAR(f.DataFattura), c.RegioneResidenza;


/* 13 */
SELECT fo.Denominazione, COUNT(fa.IdFattura) AS NumeroFatture
FROM dbo.Fornitori AS fo
LEFT JOIN dbo.Fatture AS fa
    ON fo.IdFornitore = fa.IdFornitore
GROUP BY fo.Denominazione;


/* 14 */
SELECT c.Nome, c.Cognome, SUM(f.Importo) AS SommaImporti
FROM dbo.Clienti AS c  
INNER JOIN dbo.Fatture AS f  
    ON c.IdCliente = f.IdCliente
GROUP BY c.Nome, c.Cognome
HAVING SUM(f.Importo) > 100;


/* 15 */
SELECT fo.Denominazione, COUNT(fa.IdFattura) AS NumeroFatture
FROM dbo.Fornitori AS fo
INNER JOIN dbo.Fatture AS fa
    ON fo.IdFornitore = fa.IdFornitore
GROUP BY fo.Denominazione
HAVING COUNT(fa.IdFattura) > 2;


/* 16 */
SELECT TOP 3 c.Nome, c.Cognome, SUM(f.Importo) AS TotaleFatturato
FROM dbo.Clienti AS c  
INNER JOIN dbo.Fatture AS f
    ON c.IdCliente = f.IdCliente
WHERE YEAR(f.DataFattura) = 2019
GROUP BY c.Nome, c.Cognome
ORDER BY SUM(f.Importo) DESC


/* 17 */
SELECT Nome, Cognome, 'Clienti' AS TipoAnagrafica
FROM dbo.Clienti
UNION ALL
SELECT Nome, Cognome, 'Prospect' AS TipoAnagrafica
FROM dbo.Prospect;


/* 18 */
SELECT Nome, Cognome
FROM dbo.Clienti
INTERSECT 
SELECT Nome, Cognome
FROM dbo.Prospect;


/* 19 */
SELECT Nome, Cognome
FROM dbo.Clienti
EXCEPT 
SELECT Nome, Cognome
FROM dbo.Prospect;


/* 20 */
SELECT fa.IdFattura, fa.Importo, fo.Denominazione
FROM dbo.Fatture AS fa  
FULL JOIN dbo.Fornitori AS fo
    ON fa.IdFornitore = fo.IdFornitore;
