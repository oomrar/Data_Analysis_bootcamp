/*OSSERVAZIONE IMPORTANTE: 
in questa esercitazione modificheremo senza remore la struttura del Database. 
Lo abbiamo creato appositamente per esercitarci! 
Nel mondo reale ogni modifica fatta alla struttura del Database deve essere 
assolutamente condivisa, per evitare errori in tutte le applicazioni collegate al Database.
*/ 

/*Descrizione dell'esercitazione
Modifichiamo le tabelle presenti nel database CorsoSql inserendo 
tutti i vincoli necessari  a garantire la qualità dei dati presenti. 
Discuteremo in particolare dei vincoli di tipo, 
NULL/NOT NULL, chiave primaria e chiave esterna.
*/

USE CorsoSQL

/*Esercizio 1
Modificare le colonne IdCliente, Nome e Cognome in modo 
che non possano contenere NULL.
Facciamo attenzione a riportare correttamente anche il tipo.
ATTENZIONE: su SQL Server quando eseguiamo un ALTER COLUMN dobbiamo specificare sempre 
anche il vincolo NOT NULL/NULL. Se non lo specifichiamo, il valore
impostato sarà sempre NULL, anche se in precedenza c'era il vincolo NOT NULL*/

ALTER TABLE dbo.Clienti
ALTER COLUMN IdCliente INT NOT NULL;
ALTER TABLE dbo.Clienti
ALTER COLUMN Nome VARCHAR(50) NOT NULL;
ALTER TABLE dbo.Clienti
ALTER COLUMN Cognome VARCHAR(50) NOT NULL;

/*Esercizio 2 
Creare una chiave primaria sulla colonna IdCliente*/
ALTER TABLE dbo.Clienti
ADD PRIMARY KEY (IdCliente);

/*Esercizio 3 
Modificare il tipo della colonna Iva a DECIMAL(18,2).
Prima di effettuare la modifica, valutare come cambia il risultato della query 
SELECT AVG(Iva)
FROM   dbo.Fatture;
*/
SELECT AVG(Iva)
FROM   dbo.Fatture;

ALTER TABLE dbo.Fatture ALTER COLUMN Iva DECIMAL (18,2);


/*Esercizio 4
Creare una chiave primaria sulla colonna IdFattura.
L'istruzione fallirà, capire perché e riprovare*/

ALTER TABLE dbo.Fatture
ALTER COLUMN IdFattura INT NOT NULL;
ALTER TABLE dbo.Fatture
ADD CONSTRAINT PK_IdFattura PRIMARY KEY (IdFattura);


/*Esercizio 5
Aggiungere il vincolo NOT NULL a Importo*/

ALTER TABLE dbo.Fatture
ALTER COLUMN Importo DECIMAL(18, 2) NOT NULL;

/*Esercizio 6
Aggiungere una chiave esterna alla colonna IdCliente
della tabella Fatture, con riferimento alla colonna IdCliente
della tabella Clienti*/

ALTER TABLE dbo.Fatture ADD FOREIGN KEY (IdCliente)
REFERENCES dbo.Clienti(IdCliente);


/*Esercizio 7
Aggiungere una chiave esterna alla colonna IdFornitore
della tabella Fattura, con riferimento alla colonna IdFornitore
della tabella Fornitori. L'istruzione fallirà.
Capire perché e fare tutte le modifiche necessarie
*/

ALTER TABLE dbo.Fornitori
ALTER COLUMN IdFornitore INT NOT NULL;

ALTER TABLE dbo.Fornitori ADD PRIMARY KEY (IdFornitore);
ALTER TABLE dbo.Fatture ADD FOREIGN KEY (IdFornitore)
REFERENCES dbo.Fornitori(IdFornitore);

/*Esercizio 8
Modificare il tipo delle colonne  DataFineContratto
della tabella Fornitori. Facciamo attenzione a specificare anche 
correttamente il vincolo NOT NULL/NULL. Se non lo specifichiamo, il valore
impostato sarà sempre NULL, anche se in precedenza c'era il vincolo NOT NULL*/

ALTER TABLE dbo.Fornitori
ALTER COLUMN DataFineContratto DATE NOT NULL;


/*Esercizio 9
Aggiungiamo il vincolo NOT NULL a IdCliente della tabella Fatture*/

ALTER TABLE dbo.Fatture
ALTER COLUMN IdCliente INT NOT NULL;

/*Esercizio 10
Aggiungiamo il vincolo NOT NULL a IdProdotto della tabella Prodotti*/
/*Aggiungiamo il vincolo NOT NULL a IdProdotto*/

ALTER TABLE dbo.Prodotti
ALTER COLUMN IdProdotto INT NOT NULL;


/*Esercizio 11
Creiamo una chiave primaria sulla colonna IdProdotto assegnandole
il nome PK_Prodotti*/

ALTER TABLE dbo.Prodotti 
ADD CONSTRAINT PK_Prodotti PRIMARY KEY (IdProdotto);

/*Esercizio 12
Aggiungiamo un vincolo di tipo check sulla tabella Fatture
per permettere nella colonna Tipologia soltanto i valori A,V e C*/

ALTER TABLE dbo.Fatture
ADD CHECK (Tipologia IN ('A','V','C'));