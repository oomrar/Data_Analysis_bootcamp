/******************************
Analisi esplorativa con SQL
*******************************/

USE CorsoSQL;

--Diamo un'occhiata alla tabella
SELECT TOP 1000 *
FROM   dbo.Clienti;


--Approfondiamo il contenuto della colonna Regione (variabile qualitativa)
SELECT   RegioneResidenza, 
	     COUNT(*) AS FrequenzaAssoluta
FROM     dbo.Clienti
GROUP BY RegioneResidenza
ORDER BY FrequenzaAssoluta DESC; --se non ci sono troppi dati dopo la GROUP BY


--Ripetiamo l'analisi sulla colonna Iva della tabella Fatture.
--Osserviamo che questa tipologia di query mostra anche i NULL
SELECT   Iva, 
	     COUNT(*) AS FrequenzaAssoluta
FROM     dbo.Fatture
GROUP BY Iva
ORDER BY FrequenzaAssoluta DESC; --se non ci sono troppi dati dopo la GROUP BY


--calcoliamo anche le frequenze relative
SELECT   C.RegioneResidenza,
         R.RigheTotali,
		 COUNT(*) AS FrequenzaAssoluta,
		 CAST(COUNT(*) AS decimal(18,2)) / R.RigheTotali AS FrequenzaRelativa
FROM     dbo.Clienti AS C
CROSS JOIN (SELECT COUNT(*) AS RigheTotali
            FROM dbo.Clienti) AS R
GROUP BY C.RegioneResidenza, 
	     R.RigheTotali;
--ORDER BY FrequenzaAssoluta DESC; --se non ci sono troppi dati dopo la GROUP BY
   
   
--Approfondiamo il contenuto della colonna Importo (variabile quantitativa)
SELECT   SUM(Importo) AS Totale,
		 COUNT(Importo) AS NumeroNonNull,
	     COUNT(*) - COUNT(Importo) AS NumeroNull,
	     AVG(Importo) AS Media,
		 STDEVP(Importo) AS DeviazioneStandard
FROM     dbo.Fatture;

--se la colonna importo fosse un intero, allora su SQL Server prima di applicare la media devo fare una conversione
SELECT   SUM(Importo) AS Totale,
		 COUNT(Importo) AS NumeroNonNull,
	     COUNT(*) - COUNT(Importo) AS NumeroNull,
	     AVG(CAST(Importo AS DECIMAL(18,2))) AS Media,
		 STDEVP(Importo) AS DeviazioneStandard
FROM     dbo.Fatture;



--Andiamo alla ricerca  di combinazioni duplicate
SELECT   Nome,
	     Cognome,
		 COUNT(*)
FROM     dbo.Clienti
GROUP BY Nome, 
	     Cognome
HAVING   COUNT(*)>1;


SELECT   Nome,
		 COUNT(*)
FROM     dbo.Clienti
GROUP BY Nome
HAVING   COUNT(*)>1;


--approfondiamo la ricerca dei duplicati, visualizzando le righe relative per intero
WITH CTE AS
	(SELECT   Nome,
	          Cognome
	 FROM     dbo.Clienti
	 GROUP BY Nome, 
	          Cognome
	 HAVING   COUNT(*)>1
	 )
SELECT *
FROM   dbo.Clienti AS C
INNER JOIN CTE
	ON C.Nome = CTE.Nome
   AND C.Cognome = CTE.Cognome;

--ripetiamo la query gestendo anche i duplicati che contengono NULL
WITH CTE AS
	(SELECT   Nome,
	          Cognome
	 FROM     dbo.Clienti
	 GROUP BY Nome, 
	          Cognome
	 HAVING   COUNT(*)>1
	 )
SELECT *
FROM   dbo.Clienti AS C
INNER JOIN CTE
	ON (C.Nome = CTE.Nome OR (C.Nome IS NULL AND CTE.Nome IS NULL) )
   AND (C.Cognome = CTE.Cognome OR (C.Cognome IS NULL AND CTE.Cognome IS NULL) );


--Ripetiamo l'analisi sulla sola colonna nome
WITH CTE AS
	(SELECT   Nome
	 FROM     dbo.Clienti
	 GROUP BY Nome
	 HAVING   COUNT(*)>1
	 )
SELECT *
FROM   dbo.Clienti AS C
INNER JOIN CTE
	ON C.Nome = CTE.Nome;
    
--con gestione dei NULL
WITH CTE AS
	(SELECT   Nome
	 FROM     dbo.Clienti
	 GROUP BY Nome
	 HAVING   COUNT(*)>1
	 )
SELECT *
FROM   dbo.Clienti AS C
INNER JOIN CTE
	ON C.Nome = CTE.Nome OR (C.Nome IS NULL AND CTE.Nome IS NULL);


