--*********************
--WINDOW FUNCTIONS 
--*********************

USE CorsoSQL

/*Esempio 1: 
Estrarre l'IdFattura, la data, l'importo,
l'IdCliente e il totale degli importi delle 
fatture associate al relativo cliente */

--Primo metodo: subquery + left join
SELECT F.IdFattura,
	F.DataFattura,
	F.Importo,
	F.IdCliente,
	C.TotaleImportoCliente
FROM Fatture as F
LEFT JOIN (
		   SELECT IdCliente,
			      SUM(Importo) AS TotaleImportoCliente
		   FROM   dbo.Fatture
		   GROUP BY IdCliente) AS C
	ON F.IdCliente = C.IdCliente;

--Secondo metodo: window function
SELECT IdFattura,
	DataFattura,
	Importo,
	IdCliente,
	SUM(Importo) OVER(PARTITION BY IdCliente) AS TotaleImportoCliente
FROM dbo.Fatture;



/*Esempio 2:
calcolare la fattura con importo massimo */
SELECT TOP 1 * 
FROM     dbo.Fatture
ORDER BY Importo DESC;


/*Esempio 3:
Calcolare per ogni cliente la fattura con importo massimo */

WITH CTE AS 
   (SELECT 
		*,
		RANK() OVER(PARTITION BY IdCliente
					ORDER BY Importo DESC) AS Ordinamento
	FROM dbo.Fatture)
SELECT * 
FROM   CTE 
WHERE  Ordinamento = 1;

/*ATTENZIONE:
cosa cambia sostituendo rank con rownumber o dense_rank? */

WITH CTE AS 
   (SELECT 
		*,
		DENSE_RANK() OVER(PARTITION BY IdCliente 
						  ORDER BY Importo DESC) as Ordinamento
	FROM dbo.Fatture)
SELECT * 
FROM   CTE 
WHERE  Ordinamento = 1;

WITH CTE AS 
   (SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY IdCliente 
						  ORDER BY Importo DESC) as Ordinamento
	FROM dbo.Fatture)
SELECT * 
FROM   CTE 
WHERE  Ordinamento = 1;

/*Con RANK() due righe con lo stesso ordine 
avranno lo stesso valore, mentre il valore delle
righe successive NON sarà quello successivo, 
ma effettuerà "un salto" (ad esempio 1,1,3).

Con DENSE_RANK() due righe con lo stesso 
ordine avranno lo stesso valore, il valore 
delle righe successive sarà quello successivo  
(ad esempio 1,1,2).

Con ROW_NUMBER() due righe con lo stesso 
ordine avranno sempre valori diversi, 
calcolati non deterministicamente (ad esempio 1,2,3
in un'esecuzione e 2,1,3 in un'altra)*/


/*Esempio 4:
Calcolare per ogni cliente la fattura con data
più recente? */

WITH CTE AS 
   (SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY IdCliente 
						  ORDER BY  DataFattura DESC,
									IdFattura) AS Ordinamento
	FROM dbo.Fatture)
SELECT * 
FROM   CTE 
WHERE  Ordinamento = 1;


/*Esempio 5;
Riportare per ogni fattura il suo peso percentuale 
su tutte le fatture e sulle fatture in quello specifico anno */

SELECT IdFattura, IdCliente, Importo, YEAR(DataFattura) AS anno,
  Importo / SUM(Importo) OVER() AS PercentualeSuTotale,
  Importo / SUM(Importo) OVER(PARTITION BY YEAR(DataFattura)) AS PercentualeSuAnno
FROM   dbo.Fatture; 


--convertiamo i risultati in DECIMAL(18,2)
SELECT IdFattura, IdCliente, Importo, YEAR(DataFattura) AS anno,
  CONVERT(DECIMAL(18,2),
		  Importo / SUM(Importo) OVER()  ) AS PercentualeSuTotale,
  CONVERT(DECIMAL(18,2), 
		  Importo / SUM(Importo) OVER(PARTITION BY YEAR(DataFattura))  ) AS PercentualeSuAnno
FROM   dbo.Fatture; 