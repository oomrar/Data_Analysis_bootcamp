/*************************
**STRUTTURA DEL NOME DI
**UNA TABELLA SU SQL SERVER
**************************/

USE CorsoSQL

/* Su SQL Server è considerata una buona pratica
specificare SEMPRE lo schema della tabella per
evitare ambiguità */

--Scriverò dunque
SELECT *
FROM   dbo.Clienti;

--Invece 
SELECT *
FROM   Clienti;

/*Ciò vale per ogni tipologia di comando SQL,
scriverò ad esempio CREATE dbo.Clienti, 
UPDATE dbo.Clienti, eccetera... */

/*Per creare un nuovo schema uso questo comando */
CREATE SCHEMA Test;

/*Per creare una tabella in questa nuovo schema
userò l'usuale comando CREATE TABLE, specificando
lo schema nel nome della tabella */
CREATE TABLE Test.Vendite (IdVendita INT,
						ValoreEuro DECIMAL(18,2));

/*Se provo a creare una tabella su una schema che non 
esiste otterrò un errore*/
CREATE TABLE Test2.Vendite (IdVendita INT,
						ValoreEuro DECIMAL(18,2));

/*Due schemi diversi possono avere tabelle
con lo stesso nome*/
CREATE TABLE Test.Clienti (IdCliente INT);

/*In questi casi è fondamentale specificare lo schema,
se non lo facciamo verrà considerato lo schema di DEFAULT
associato al particolare utente che lancia la query*/
SELECT * FROM dbo.Clienti;
SELECT * FROM test.Clienti;
SELECT * FROM Clienti;

/*Se antepongo al nome dello schema il nome del database,
posso lanciare query che combinano informazioni di 
database diversi */
USE CorsoSQL

/*Interrogo la tabella Clienti del database
Gestionale */
SELECT * 
FROM Gestionale.dbo.Clienti

/*Ottengo un'unica lista dei nomi e cognomi 
dei clienti dei database CorsoSQL e Gestionale */
SELECT Nome, Cognome
FROM Gestionale.dbo.Clienti
	UNION ALL
SELECT Nome, Cognome
FROM CorsoSQL.dbo.Clienti;

/*Quando scriviamo query che coinvolgono tabelle
di più database è una buona pratica specificare 
sempre il nome dei database in tutti i casi */