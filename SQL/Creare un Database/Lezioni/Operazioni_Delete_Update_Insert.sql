----------------------------------------------------------------
--POPOLARE E AGGIORNARE UN DATABASE
--PAROLE CHIAVE INSERT, DELETE, UPDATE, BULK INSERT, TRUNCATE
----------------------------------------------------------------

/*Posizioniamoci sul database CorsoSql*/
USE CorsoSQL

/*In questa sezione vediamo come modificare permanentemente
i dati all'interno di un database. Le parole chiavi fondamentali
sono
INSERT --> inserisce righe in una tabella
DELETE --> elimina righe in una tabella
UPDATE --> aggiorna valori di una o più colonne in una o più righe 
           --di una tabella 
BULK INSERT --> inserisce righe in una tabella a partire da un file */


/*Esempio 1
cancellare i clienti della Lombardia */

/*Per eseguire la delete in sicurezza, PRELIMINARMENTE 
seleziono i clienti della Lombardia */

SELECT *
FROM   dbo.Clienti
WHERE  RegioneResidenza ='Lombardia'
 
/*quando sono sicuro del filtro scritto,
sostituisco select con delete per cancellare 
permanentemente quelle righe*/
DELETE
FROM   dbo.Clienti
WHERE  RegioneResidenza = 'Lombardia'


/*Esempio 2
eliminare le fatture di clienti della Puglia*/

/*Preliminarmente selezione queste fatture. 
Posso farlo in svariati modi: con una join,
exists, in...*/

SELECT * 
FROM   dbo.Fatture
WHERE  IdCliente in (SELECT IdCliente 
					 FROM   dbo.Clienti
					 WHERE  RegioneResidenza = 'Puglia')

/*Quando sono sicuro, sostituisco select * con delete*/

DELETE
FROM   dbo.Fatture
WHERE  IdCliente in (SELECT IdCliente 
					 FROM   dbo.Clienti
					 WHERE  RegioneResidenza = 'Puglia')

/*Risolviamo lo stesso problema scrivendo una delete 
contenente una join. Partiamo prima sempre con una select */

SELECT *
FROM   dbo.Fatture
INNER JOIN dbo.Clienti
	ON dbo.Fatture.IdCliente = dbo.Clienti.IdCliente
WHERE dbo.Clienti.RegioneResidenza = 'Piemonte'

/*In questo caso, quando trasformiamo la SELECT in
DELETE, è fondamentale specificare 
in quale tabella eliminare le righe */

DELETE dbo.Fatture
FROM   dbo.Fatture
INNER JOIN Clienti
	ON dbo.Fatture.IdCliente = dbo.Clienti.IdCliente
WHERE  dbo.Clienti.RegioneResidenza = 'Piemonte'


/*Esempio 3
aggiornare la regione di residenza del cliente numero 1 in Abruzzo*/

/*Scriviamo preliminarmente la SELECT*/
SELECT RegioneResidenza, 
	'Abruzzo' as NewRegioneResidenza,
	* 
FROM   dbo.Clienti
WHERE  IdCliente = 1;

/*Aggiorniamo la SELECT in UPDATE*/
UPDATE   dbo.Clienti
SET      RegioneResidenza = 'Abruzzo'
WHERE    IdCliente = 1;


/*Esempio 4
Aumentare tutti gli importi della fatture di tipologia A del 10%*/

/*Scriviamo preliminarmente la SELECT*/
SELECT Importo, 
	Importo + Importo * 0.10 as NuovoImporto,
	* 
FROM   dbo.Fatture
WHERE  Tipologia = 'A';

/*Aggiorniamo la SELECT in UPDATE*/
UPDATE dbo.Fatture
SET Importo = Importo + Importo * 0.10 
WHERE  Tipologia = 'A';

SELECT * FROM dbo.Fatture
/*Esempio 5
inserire una riga nella tabella clienti contente i seguenti valori: 
11,'Nicola','Iantomasi','20080101','Piemonte' */
 
INSERT INTO dbo.Clienti (IdCliente, Nome, Cognome,
                     DataNascita, RegioneResidenza)
VALUES (11, 'Nicola', 'Iantomasi', '20080101', 'Piemonte')

SELECT * FROM dbo.Clienti WHERE idcliente=11
/*Esempio 6
inserire nella tabella Clienti il prospect numero 3 assegnandogli
l'IdCliente 12.*/

/*Scrivo PRELIMINARMENTE la select tenendo presente l'elenco 
di colonne della tabella Clienti*/

SELECT 12 AS IdCliente,
	Nome,
	Cognome,
	DataNascita,
	null as RegioneResidenza
FROM  dbo.Prospect
WHERE IdProspect = 3;

/*quando sono sicuro del risultato, aggiungo i dati 
alla tabelle Clienti inserendo l'insert.
*/

INSERT INTO dbo.Clienti (IdCliente, Nome,Cognome,
					DataNascita,RegioneResidenza)
SELECT 12 AS IdCliente,
	Nome,
	Cognome,
	DataNascita,
	null as RegioneResidenza
FROM  dbo.Prospect
WHERE IdProspect = 3;
