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

/* Esercizio 3 
Contare il numero di prodotti per cui il prezzo medio 
di vendita nel 2018 � maggiore del prezzo consigliato */

WITH TabPrezzoMedio AS(
	SELECT p.IdProdotto, p.PrezzoConsigliato, AVG(fp.PrezzoUnitario) AS PrezzoMedio
	FROM dbo.Prodotti AS p  
	INNER JOIN dbo.FattureProdotti AS fp  
	ON p.IdProdotto = fp.IdProdotto
	INNER JOIN dbo.Fatture AS f  
	ON fp.IdFattura = f.IdFattura
	WHERE YEAR(f.DataFattura) = 2018
	GROUP BY p.IdProdotto, p.PrezzoConsigliato, YEAR(f.DataFattura)
	HAVING AVG(fp.PrezzoUnitario) > p.PrezzoConsigliato)

SELECT COUNT(*) AS Conteggio
FROM TabPrezzoMedio;




/* Esercizio 4
Riportare per ogni fattura la somma tra
- l�importo totale (calcolabile come 
prodotto di quantita*prezzoUnitario) 
- la spesa di spedizione
Attenzione alle duplicazioni causate da join. 

Ps. supponiamo che tutte le fatture siano presenti 
sia nella tabella Fatture che nella
tabella FattureProdotti */

WITH SenzaSpese AS(
SELECT f.IdFattura, 
		f.Spedizione,
		SUM(fp.Quantita * fp.PrezzoUnitario) AS ImportoTotale
FROM dbo.Fatture AS f 
INNER JOIN dbo.FattureProdotti AS fp 
ON f.IdFattura = fp.IdFattura
GROUP BY f.IdFattura, f.Spedizione)

SELECT IdFattura, (ImportoTotale + (COALESCE (Spedizione, 0))) AS ImportoComplessivo
FROM SenzaSpese;



USE CorsoSQL;

/*Struttura del database 
dbo.Clienti (IdCliente PK, Nome, Cognome, 
		 DataNascita, RegioneResidenza);
dbo.Prospect (IdProspect PK, Nome, Cognome, 
		  DataNascita, Nazione, FlagUE);
dbo.Fatture (IdFattura PK, Tipologia, Importo, 
		 Iva, IdCliente, DataFattura, NumeroFornitore);
dbo.Fornitori (IdFornitore PK, Denominazione, RegioneResidenza,
		   DataPrimaAcquisto, FornitoreAttivo, DataFineContratto)
dbo.Prodotti (IdProdotto PK, Descrizione, InProduzione, InCommercio, 
		  RegioneProduzione, DataAttivazione, DataDisattivazione, 
		  Costo, CentralitaBusiness) */

/* Esercizio 5
Nel database CorsoSQL calcolare:
- la somma annua delle fatture con tipologia A
- la somma annua delle fatture con tipologia V
- la differenza annua tra la somma delle fatture 
con tipologia A e la somma delle fatture con tipologia B */ 

WITH TipA AS (
	SELECT YEAR(DataFattura) AS Anno, SUM(Importo) AS SommaAnnua
	FROM dbo.Fatture
	WHERE Tipologia = 'A'
	GROUP BY YEAR(DataFattura)),
	TipV AS(
	SELECT YEAR(DataFattura) AS Anno, SUM(Importo) AS SommaAnnua
	FROM dbo.Fatture
	WHERE Tipologia = 'V'
	GROUP BY YEAR(DataFattura)
	)

SELECT COALESCE(A.Anno, V.Anno) AS Anno,
	COALESCE(A.SommaAnnua, 0) AS TipologiaA,
	COALESCE(V.SommaAnnua, 0) AS TipologiaV,
	(COALESCE(A.SommaAnnua, 0) - COALESCE(V.SommaAnnua, 0)) AS Differenza
FROM TipA AS A
FULL JOIN TipV AS V  
ON A.Anno = V.Anno;


