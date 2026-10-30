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
di vendita nel 2018 è maggiore del prezzo consigliato */


/* Esercizio 4
Riportare per ogni fattura la somma tra
- l’importo totale (calcolabile come 
prodotto di quantita*prezzoUnitario) 
- la spesa di spedizione
Attenzione alle duplicazioni causate da join. 

Ps. supponiamo che tutte le fatture siano presenti 
sia nella tabella Fatture che nella
tabella FattureProdotti */


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
con tipologia A la somma delle fatture con tipologia */ 
