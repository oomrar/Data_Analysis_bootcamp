/**************************************
Window function per somme cumulate,
lead, lag e ntile
**************************************/

/*Cosa succede se inserisco un ORDER BY nella clausola over OVER?*/
SELECT IdFattura,
	DataFattura,
	Importo,
	IdCliente,
    SUM(Importo) OVER(ORDER BY DataFattura) AS ImportoCumulato
FROM dbo.Fatture
ORDER BY DataFattura;


--la query precedente � equivalente a questa
SELECT IdFattura,
	DataFattura,
	Importo,
	IdCliente,
    SUM(Importo) OVER(ORDER BY DataFattura 
					  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ImportoCumulato
FROM dbo.Fatture
ORDER BY DataFattura;


--la prossima query invece non � deterministica
SELECT IdFattura,
	DataFattura,
	Importo,
	IdCliente,
    SUM(Importo) OVER(ORDER BY DataFattura 
					  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ImportoCumulato
FROM dbo.Fatture
ORDER BY DataFattura;


--posso disambiguare i pari merito aggiungendo delle condizioni all'ORDER BY
SELECT IdFattura,
	DataFattura,
	Importo,
	IdCliente,
    SUM(Importo) OVER(ORDER BY DataFattura,IdFattura 
					  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ImportoCumulato
FROM dbo.Fatture
ORDER BY DataFattura;


/*Esempio:
calcolare il cumulato mensile al variare dell'anno */
WITH ImportiMensili AS (
   SELECT YEAR(DataFattura) AS Anno,
       MONTH(DataFattura) AS Mese,
	   SUM(Importo) AS Importo
   FROM dbo.Fatture
   GROUP BY YEAR(DataFattura),
       MONTH(DataFattura) )
SELECT Anno,
       Mese,
	   Importo,
	   SUM(Importo) OVER(PARTITION BY Anno
	                     ORDER BY Mese) AS ImportoCumulato
FROM   ImportiMensili
ORDER BY Anno, Mese;
       


/*Testiamo le funzioni LAG e LEAD*/
SELECT IdFattura,
       IdCliente,
	   DataFattura,
	   Importo,
       LAG(Importo) OVER(PARTITION BY IdCliente 
	                     ORDER BY DataFattura) AS Lag,
       LEAD(Importo) OVER(PARTITION BY IdCliente 
	                     ORDER BY DataFattura) AS Lead
FROM   Fatture
ORDER BY IdCliente,
         DataFattura;


/*Aggiungiamo a LAG e LEAD il secondo argomento*/
SELECT IdFattura,
       IdCliente,
	   DataFattura,
	   Importo,
       LAG(Importo,1) OVER(PARTITION BY IdCliente 
	                     ORDER BY DataFattura) AS Lag,
       LEAD(Importo,1) OVER(PARTITION BY IdCliente 
	                     ORDER BY DataFattura) AS Lead,
		LAG(Importo,2) OVER(PARTITION BY IdCliente 
	                     ORDER BY DataFattura) AS Lag_2,
       LEAD(Importo,2) OVER(PARTITION BY IdCliente 
	                     ORDER BY DataFattura) AS Lead_2
FROM   Fatture
ORDER BY IdCliente,
         DataFattura;



/*Testiamo le funzioni NTILE */
SELECT IdFattura,
       IdCliente,
	   DataFattura,
	   Importo,
	   NTILE(2) OVER(ORDER BY Importo) AS NTILE_2
FROM   Fatture
ORDER BY Importo;  


SELECT IdFattura,
       IdCliente,
	   DataFattura,
	   Importo,
	   NTILE(4) OVER(ORDER BY Importo) AS NTILE_4
FROM   Fatture
ORDER BY Importo; 
	   
	   
SELECT IdFattura,
       IdCliente,
	   DataFattura,
	   Importo,
	   NTILE(100) OVER(ORDER BY Importo) AS NTILE_100
FROM   Fatture
ORDER BY Importo; 


/*Studiamo la distribuzione della colonna importo */
WITH CTE AS(
	SELECT 
		   Importo,
		   NTILE(4) OVER(ORDER BY Importo) AS NTILE_4
	FROM   Fatture) 
SELECT NTILE_4 AS Gruppo,
	MIN(Importo) AS Valore_minimo,
	MAX(Importo) AS Valore_massimo
FROM   CTE
GROUP BY NTILE_4
ORDER BY NTILE_4;
