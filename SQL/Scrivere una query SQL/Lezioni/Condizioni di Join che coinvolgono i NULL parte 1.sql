USE CorsoSQL;

CREATE TABLE dbo.Magazzino(
	Codice1 VARCHAR(5),
	Codice2 VARCHAR(5),
	Nome VARCHAR(50));

INSERT INTO dbo.Magazzino (Codice1,Codice2,Nome)
VALUES 
	('A1','B1','Prodotto1'),
	('A1','B2','Prodotto2'),
	('A2','B1','Prodotto3'),
	('A2',NULL,'Prodotto4') ;

CREATE TABLE dbo.Prezzario(
	Codice1 VARCHAR(5),
	Codice2 VARCHAR(5),
	Prezzo DECIMAL(18,4) );

INSERT INTO dbo.Prezzario (Codice1,Codice2,Prezzo)
VALUES 
	('A1','B1',3.24),
	('A1','B2',2.5),
	('A2','B1',1.21),
	('A2',NULL,1.4);

/*Visualizzare in una sola query i codici, il nome e il prezzo dei prodotti.
Combinare le tabelle utilizzando le colonne Codice1 e Codice2.
Per questo esercizio specifico, parità di Codice1 occorre combinare i dati 
anche se entrambi i Codice2 sono NULL */

SELECT *
FROM   dbo.Magazzino;

SELECT *
FROM   dbo.Prezzario;

/*Primo tentativo errato che considera soltanto il Codice1*/
SELECT *
FROM dbo.Magazzino AS Ma
INNER JOIN dbo.Prezzario AS Pr
	ON Ma.Codice1 = Pr.Codice1
ORDER BY Ma.Nome;


/*Secondo tentativo che non implementa la richiesta dell'esercizio sui NULL*/ 
SELECT *
FROM dbo.Magazzino AS Ma
INNER JOIN dbo.Prezzario AS Pr
	ON Ma.Codice1 = Pr.Codice1
	AND Ma.Codice2 = Pr.Codice2;


/*Query che gestisce i NULL come richiesto dall'esercizio*/ 
SELECT *
FROM dbo.Magazzino AS Ma
INNER JOIN dbo.Prezzario AS Pr
	ON Ma.Codice1 = Pr.Codice1
	AND ( Ma.Codice2 = Pr.Codice2 OR (Ma.Codice2 IS NULL AND Pr.Codice2 IS NULL)  );

