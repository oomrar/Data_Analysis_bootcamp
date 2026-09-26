---------------------------------
--APPROFONDIMENTO CASE WHEN
---------------------------------
USE CorsoSQL;

/*Esempio 1
Visualizzare le colonne IdFattura, Importo, Tipologia e Tipologia_descrizione
della tabella delle Fatture. Valorizzare la Tipologia_descrizione in questo modo:
- se tipologia = 'A' allora 'Acquisto'
- se tipologia = 'V' allora 'Vendita' */

SELECT IdFattura, 
   Importo,
   Tipologia,
   CASE WHEN Tipologia = 'A' THEN 'Acquisto'
        WHEN Tipologia = 'V'  THEN 'Vendita'
        ELSE NULL
   END AS Tipologia_descrizione
FROM dbo.Fatture;



/*Esempio 2
Classificare le fatture in tre categorie di prezzo
- Basso se l'importo è compreso tra 0 e 30 (0 incluso, 30 escluso)
- Medio se l'importo è compreso tra 30 e 70 (30 incluso, 70 escluso)
- Alto se l'importo è maggiore o uguale di 70.
Contare il numero di fatture per ogni categoria */

SELECT 
   CASE WHEN Importo >= 0 AND Importo < 30 THEN 'Basso'
        WHEN Importo >= 30 AND Importo < 70 THEN 'Medio'
        WHEN Importo >= 70 THEN 'Alto'
        ELSE 'Non classificata'
   END AS Tipologia_cliente,
   COUNT(*) AS Numero
FROM dbo.Fatture
GROUP BY 
	CASE WHEN Importo >= 0 AND Importo < 30 THEN 'Basso'
		 WHEN Importo >= 30 AND Importo < 70 THEN 'Medio'
		 WHEN Importo >= 70 THEN 'Alto'
		ELSE 'Non classificata'
	END; 


WITH CTE AS (
	SELECT 
	   CASE WHEN Importo >= 0 AND Importo < 30 THEN 'Basso'
			WHEN Importo >= 30 AND Importo < 70 THEN 'Medio'
			WHEN Importo >= 70 THEN 'Alto'
			ELSE 'Non classificata'
	   END AS Tipologia_cliente
	FROM dbo.Fatture)
SELECT Tipologia_cliente, COUNT(*)
FROM CTE
GROUP BY Tipologia_cliente;



 /*Esempio 3 
Ordinare i clienti secondo questo criterio
- Deve apparire all'inizio il cliente con IdCliente = 7
- Poi gli altri clienti nell'usuale ordine per Nome e Cognome
Contare il numero di fatture per ogni categoria */

SELECT *
FROM   dbo.Clienti
ORDER BY CASE WHEN IdCliente = 7 THEN 1 
              ELSE 2
		 END ASC,
		 Nome ASC,
		 Cognome ASC;



/*Esempio 4 
Calcolare la somma degli importi delle fatture,
considerando un ulteriore incremento del 20% per gli importi delle 
fatture di tipologia di A*/

SELECT SUM(CASE WHEN Tipologia = 'A' THEN Importo * 1.20
                ELSE Importo
			END) AS Totale
FROM   dbo.Fatture;
