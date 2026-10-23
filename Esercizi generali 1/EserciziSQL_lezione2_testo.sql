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

/* Esercizio 1
Calcolare il totale degli sconti 
delle fatture emesse nel 2019.  */

SELECT SUM(FP.Sconto) AS TotaleSconti
FROM dbo.FattureProdotti AS FP 
INNER JOIN dbo.Fatture AS F  
ON FP.IdFattura = F.IdFattura
WHERE YEAR(F.DataFattura) = 2019;



/* Esercizio 2
Quante fatture sono state pagate in ritardo?  */

SELECT COUNT(*) AS ConteggioFattureRitardo
FROM dbo.Fatture
WHERE DataPagamento > DataTerminePagamento;

/* Esercizio 3
Calcolare la somma delle spese di spedizione,
azzerandole per� quando un prodotto � arrivato in ritardo */

SELECT SUM(
		CASE
			WHEN (DataPagamento > DataTerminePagamento) THEN 0
			ELSE Spedizione
		END
		) AS SpeseSpedizione
FROM dbo.Fatture;



/* Esercizio 4
Quando un prodotto arriva in ritardo, 
il cliente ha diritto a un rimborso di 1,5 euro 
per ogni giorno di ritardo. Calcolare i rimborsi del 2018.  */


SELECT SUM(DATEDIFF(DAY, DataArrivoRichiesta, DataArrivoEffettiva)*1.5) AS Rimborso
FROM dbo.Fatture
WHERE DataArrivoEffettiva > DataArrivoRichiesta
AND YEAR(DataFattura) = 2018;