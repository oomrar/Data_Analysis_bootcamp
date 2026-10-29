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

/* Esercizio 8
Estrarre i corrieri che hanno fatto
consegne a gennaio 2018 ma non hanno fatto
consegne a febbraio 2018  */

SELECT c.IdCorriere, c.Denominazione
FROM dbo.Corrieri AS c
INNER JOIN dbo.Fatture AS f  
ON c.IdCorriere = f.IdCorriere
WHERE (MONTH(f.DataFattura) = 01 AND YEAR(f.DataFattura) = 2018)
EXCEPT
SELECT c.IdCorriere, c.Denominazione
FROM dbo.Corrieri AS c
INNER JOIN dbo.Fatture AS f  
ON c.IdCorriere = f.IdCorriere
WHERE (MONTH(f.DataFattura) = 02 AND YEAR(f.DataFattura) = 2018);


/* Esercizio 9
Trovare prodotti che non sono 
stati mai venduti nel 2018  */

SELECT DISTINCT p.IdProdotto, p.NomeProdotto
FROM dbo.Prodotti AS p
LEFT JOIN dbo.FattureProdotti AS fp  
ON p.IdProdotto = fp.IdProdotto
LEFT JOIN dbo.Fatture AS f  
ON fp.IdFattura = f.IdFattura
EXCEPT
SELECT DISTINCT p.IdProdotto, p.NomeProdotto
FROM dbo.Prodotti AS p
LEFT JOIN dbo.FattureProdotti AS fp  
ON p.IdProdotto = fp.IdProdotto
LEFT JOIN dbo.Fatture AS f  
ON fp.IdFattura = f.IdFattura
WHERE YEAR(f.DataFattura) = 2018;






/* Esercizio 10
Visualizzare l'elenco delle fatture con in aggiunta
una colonna valorizzata soltanto per i clienti 
della Lombardia, riportante la mail del cliente  */


/* Esercizio 11
Estrarre corrieri che non hanno fatture associate */
