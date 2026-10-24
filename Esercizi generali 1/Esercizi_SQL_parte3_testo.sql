/*************************
**SECONDA ESERCITAZIONE 
**************************/

USE Gestionale


/*Struttura del database 
dbo.Clienti (IdCliente PK, IsActive, Nome, Cognome, 
		 DataNascita, Nazione, Regione, Cap, 
		 Telefono, Fax, Email);
dbo.Corrieri (IdCorriere PK, Denominazione, PartitaIva, 
		  CodiceFiscale, Nazione, Regione, Telefono,
		  DataPrimaCollaborazione)
dbo.Fatture (IdFattura PK, IdCliente, IdFornitore, 
		 DataFattura, DataTerminePagamento, DataPagamento,
		 Spedizione, IdCorriere, DataArrivoRichiesta, 
		 DataArrivoEffettiva);
dbo.FattureProdotti (IdFattura PK, IdProdotto PK, PrezzoUnitario,
				 Quantita, Sconto, Omaggio,  Iva)
dbo.Fornitori (IdFornitore PK, Denominazione, PartitaIva,
		   CodiceFiscale, Nazione, Regione,
		   Telefono, DataPrimaCollaborazione)
dbo.Prodotti (IdProdotto PK, NomeProdotto, DescrizioneProdotto,
		  PrezzoConsigliato, Categoria, Target)
*/

/* Esercizio 5
Estrarre la colonna �telefono� della tabella 
Clienti senza le parantesi. */

SELECT Telefono
FROM dbo.Clienti

SELECT (REPLACE(REPLACE(Telefono, '(', ''),')', '')) AS Telefono
FROM dbo.Clienti;

/* Esercizio 6 
Quale categoria ha fruttato 
maggiore fatturato nel 2018?  */

WITH CTE AS(
SELECT Categoria, SUM(fp.PrezzoUnitario * fp.Quantita) AS Fatturato
FROM dbo.Prodotti AS p  
INNER JOIN dbo.FattureProdotti AS fp 
ON p.IdProdotto = fp.IdProdotto
INNER JOIN dbo.Fatture AS f  
ON fp.IdFattura = f.IdFattura
WHERE YEAR(f.DataFattura) = 2018
GROUP BY p.Categoria) 

SELECT TOP 1 Categoria
FROM CTE
ORDER BY Fatturato DESC;




/* Esercizio 7
Quale corriere nel 2018 � stato, in media, 
pi� veloce nel consegnare i prodotti?   */


SELECT TOP 1 c.IdCorriere, c.Denominazione, AVG(convert(decimal(18,2),DATEDIFF(DAY, f.DataFattura, f.DataArrivoEffettiva))) AS MediaConsegne
FROM dbo.Corrieri AS c  
INNER JOIN dbo.Fatture AS f
ON c.IdCorriere = f.IdCorriere
WHERE YEAR(f.DataFattura) = 2018
GROUP BY c.IdCorriere, c.Denominazione
ORDER BY MediaConsegne ASC
