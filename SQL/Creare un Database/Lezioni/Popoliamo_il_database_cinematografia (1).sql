/*************************************
Popoliamo il Database cinematografia 
*************************************/
USE Cinematografia;


/*Per prima cosa osserviamo che le tabelle 
devono essere popolate con un certo ordine*/

--La seguente istruzione genera un errore per il vincolo di chiave esterna
INSERT INTO dbo.Film (Titolo, AnnoProduzione,
	DataUscita, DurataMinuti, IdRegista)
VALUES ('Un bel film',2020,
		'20220530',120,1);

--Dovr� creare prima il regista e poi il film
INSERT INTO dbo.Registi(Nome,Cognome,DataNascita)
VALUES ('Giovanni','Verdi','19750301');

/*Attenzione: se ho utilizzato l'IDENTITY, sar� il Database ad aver valorizzato l'IdRegista.
Dovr� quindi recuperare questo valore per inserirlo nella tabella Film. */
SELECT * 
FROM dbo.Registi
WHERE Nome='Giovanni' 
AND Cognome='Verdi';

SELECT SCOPE_IDENTITY();

INSERT INTO dbo.Film (Titolo, AnnoProduzione,
	DataUscita, DurataMinuti, IdRegista)
VALUES ('Un bel film',2020,
		'20220530',120,1);

/*Attenzione! l'identity inserita in Film non
sar� 1, perch� il valore � gi� stato "consutamo"
dalla prima insert che abbiamo lanciato ed � fallita */
SELECT *
FROM   dbo.Film;

SELECT SCOPE_IDENTITY();


/*Popoliamo le tabelle Attori e AttoriFilm utilizzando
SQL Server Management Studio*/

SELECT * FROM dbo.Attori;


/*Scriviamo le Join tra le tabelle*/
SELECT *
FROM dbo.Film AS f 
INNER JOIN dbo.Registi AS r
	ON f.IdRegista = r.IdRegista;

SELECT *
FROM   FilmAttori AS fa
INNER JOIN Film AS f
	ON fa.IdFilm = f.IdFilm;

SELECT *
FROM   FilmAttori AS fa
INNER JOIN Film AS f
	ON fa.IdFilm = f.IdFilm
INNER JOIN Attori AS a
	ON fa.IdAttore = a.IdAttore;
	
--Subquery con "AnnoProduzione" candidabile come chiave primaria
SELECT AnnoProduzione, COUNT(*)
FROM  dbo.Film
GROUP BY AnnoProduzione;

--Subquery con la combinazione di "Anno" e "Mese" candidabile come chiave primaria
SELECT YEAR(DataUscita) AS Anno,
	MONTH(DataUscita) AS Mese, 
	COUNT(*) AS conteggio
FROM   dbo.Film
GROUP BY YEAR(DataUscita),
	MONTH(DataUscita);