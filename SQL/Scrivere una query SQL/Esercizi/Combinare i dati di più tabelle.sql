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


/* Riprendere da punto 3, numero tre su notebooklm