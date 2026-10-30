/*************************
**TERZA ESERCITAZIONE 
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
Riportare l�elenco dei prodotti aggiungendo:
- una colonna con il numero di fatture 
emesse nel 2018 che contengono il prodotto
- una colonna con il numero di fatture 
emesse nel 2019 che contengono il prodotto  */


SELECT p.IdProdotto, 
	p.NomeProdotto, 
	(
		SELECT COUNT(*)
		FROM dbo.Fatture AS f
		RIGHT JOIN dbo.FattureProdotti AS fp  
		ON fp.IdFattura = f.IdFattura
		AND p.IdProdotto = fp.IdProdotto
		WHERE YEAR(f.DataFattura) = 2018
	) AS '2018',
	(
		SELECT COUNT(*)
		FROM dbo.Fatture AS f
		RIGHT JOIN dbo.FattureProdotti AS fp  
		ON fp.IdFattura = f.IdFattura
		AND p.IdProdotto = fp.IdProdotto
		WHERE YEAR(f.DataFattura) = 2019
	) AS '2019'
FROM dbo.Prodotti AS p;





/* Esercizio 2
Quale categoria di prodotti, nel corso degli anni, 
ha fruttato un fatturato annuo-medio maggiore ? */

WITH Step1 AS (
SELECT p.Categoria, YEAR(f.DataFattura) AS Anno, SUM(fp.PrezzoUnitario * fp.Quantita) AS FatturatoTotaleCategoria
FROM dbo.Prodotti AS p 
INNER JOIN dbo.FattureProdotti AS fp 
ON p.IdProdotto = fp.IdProdotto
INNER JOIN dbo.Fatture AS f  
ON fp.IdFattura = f.IdFattura
GROUP BY p.Categoria, YEAR(f.DataFattura))

SELECT TOP 1 Categoria, AVG(FatturatoTotaleCategoria) AS FatturatoMedio
FROM Step1
GROUP BY Categoria
ORDER BY FatturatoMedio DESC;

