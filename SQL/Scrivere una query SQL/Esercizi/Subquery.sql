USE CorsoSQL

/* 1 */

WITH Step1 AS
    (
        SELECT YEAR(DataFattura) AS AnniRedditizi,
                SUM(Importo) AS Fatturato
        FROM dbo.Fatture
        GROUP BY YEAR(DataFattura)
    )

SELECT AnniRedditizi
FROM Step1
WHERE Fatturato > 100


/* 2 */

SELECT IdCliente, Nome, Cognome
FROM dbo.Clienti AS C
WHERE NOT EXISTS (
                 SELECT *
                 FROM dbo.Fatture AS F  
                 WHERE C.IdCliente = F.IdCliente
                )


/* 3 */

SELECT *
FROM dbo.Prodotti AS P  
WHERE P.Costo > (SELECT AVG(Costo)
                 FROM dbo.Prodotti
                )


/* 4 */

SELECT AVG(Somme) AS ValoreMedio
FROM (
    SELECT IdCliente, SUM(Importo) AS Somme 
    FROM dbo.Fatture
    GROUP BY IdCliente
) AS Step1


/* 6 */

SELECT IdFornitore, SUM(Importo) AS TotaleFatturato
INTO #TotaliFornitori
FROM dbo.Fatture
GROUP BY IdFornitore

SELECT IdFornitore
FROM #TotaliFornitori
WHERE TotaleFatturato > 50;


/* 7 */

SELECT Denominazione
FROM dbo.Fornitori AS Fo  
WHERE EXISTS (SELECT *
              FROM dbo.Fatture AS Fa  
              WHERE Fo.IdFornitore = Fa.IdFornitore
              AND Fa.Importo > 30
            )


/* 8 */

SELECT IdCliente
FROM dbo.Fatture AS F
GROUP BY IdCliente
HAVING AVG(F.Importo) > (SELECT AVG(Importo)
                 FROM dbo.Fatture
                )


/* 9 */

WITH Step1 AS
    (
        SELECT RegioneProduzione, COUNT(IdProdotto) AS Conteggio
        FROM dbo.Prodotti
        GROUP BY RegioneProduzione
    )

SELECT RegioneProduzione
FROM Step1
WHERE Conteggio > 3


/* 10 */

SELECT *
FROM dbo.Fatture 
WHERE IdCliente IN ( SELECT IdCliente
                     FROM dbo.Clienti
                     WHERE RegioneResidenza IN (SELECT RegioneResidenza
                                                FROM dbo.Fornitori
                                                WHERE FornitoreAttivo = 1
                                                 ))
                            

/* 11 */

SELECT IdCliente, Nome, Cognome
FROM dbo.Clienti AS C
WHERE EXISTS (SELECT *
              FROM dbo.Fatture AS F
              WHERE C.IdCliente = F.IdCliente
              AND YEAR(DataFattura) = 2018
              )


/* 12 */

SELECT *
INTO #ProdottiAttivii
FROM dbo.Prodotti
WHERE InCommercio = 1

SELECT RegioneProduzione, AVG(Costo) AS CostoMedio
FROM #ProdottiAttivii
GROUP BY RegioneProduzione 


/* 13 */

SELECT MAX(Transazioni) AS MAX
FROM (
      SELECT IdCliente, COUNT(IdFattura) AS Transazioni
      FROM dbo.Fatture
      GROUP BY IdCliente
      ) AS Tab1


/* 14 */

SELECT Denominazione
FROM dbo.Fornitori AS Fo
WHERE NOT EXISTS (SELECT * 
                  FROM dbo.Fatture AS Fa  
                  WHERE Fa.IdFornitore = Fo.IdFornitore
                 )


/* 15 */

SELECT *
FROM dbo.Fatture
WHERE Importo > (SELECT AVG(Importo)
                 FROM dbo.Fatture
                 WHERE Tipologia = 'V'
                )


SELECT * FROM #ProdottiAttivii;
