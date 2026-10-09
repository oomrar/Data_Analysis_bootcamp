--------------------------------------------------------
--LEZIONE 7: SALVARE E RIESEGUIRE CODICE ALL'INTERNO DEL DATABASE
--PAROLE CHIAVE: VIEW, PROCEDURE, EXEC
--------------------------------------------------------
/*Le viste e le stored procedure sono oggetti del database, 
anche se non occupano memoria in quanto è solo il codice ad essere salvato
e non i dati, entreranno nelle procedure di backup, dovranno esserne regolati
i diritti di visibilità, eccetera...Quindi occhio a non esagerare e ad 
avere l'ok dal resto del team.*/

USE CorsoSql

/*Esempio 1
Salvare il codice che estrae il fatturato annuo*/
CREATE VIEW dbo.v_FatturatoAnnuo AS 
	SELECT YEAR(DataFattura) as Anno,
		SUM(Importo) as FatturatoAnnuo
	FROM   dbo.Fatture
	GROUP BY YEAR(DataFattura);
GO

/*Per riutilizzare il codice salvato nella vista, basterà
fare riferimento al nome della vista all'interno della
clausola FROM di una query, come se si trattasse di una tabella */

SELECT *
FROM   dbo.v_FatturatoAnnuo;

/*È importante sottolineare che in v_FatturatoAnnuo non è salvato
nessun dato. Le viste salvano soltanto l'istruzione di select.
La query in alto è dunque equivalente alla seguente */

SELECT *
FROM   (
		SELECT YEAR(DataFattura) as Anno,
			SUM(Importo) as FatturatoAnnuo
		FROM   dbo.Fatture
		GROUP BY YEAR(DataFattura)
		) as v_FatturatoAnnuo;

/*Esempio 2
Salvare il codice che elimina permanentemente
l'intero contenuto della tabella Prospect*/

CREATE PROCEDURE dbo.SvuotaProspect as
BEGIN
	TRUNCATE TABLE dbo.Prospect;
END

/* Per eseguire il codice salvato in una stored procedure occorre 
utilizzare la parola chiave EXEC */
EXEC dbo.SvuotaProspect;

SELECT * FROM dbo.prospect;

/*Attenzione! EXEC si può omettere, quindi se inavvertitamente
lanciamo del frammento di codice SQL contenente una parola, 
in realtà stiamo tentando di eseguire una stored procedure con quel
nome */

/*Jolly
Con le stored procedure è possibile 
rendere il codice SQL dipendente da parametri, 
come nell'esempio qui in basso */

/*Esempio 3 
creare una procedura che prende in input due parametri:
- InteressePercentuale
- IdFornitore

La procedura deve aggiornare tutte le fatture associate
al fornitore dato in input, incrementando l'importo della percentuale 
indicata nel secondo parametro. La procedura deve mostrare la nuova
somma complessiva degli importi di quel fornitore */

CREATE PROCEDURE dbo.AggiornaEmostraFatture
	@InteressePercentuale decimal(18,2),  --> non servono le parentesi prima dei parametri
	@Fornitore int
AS
BEGIN 
	UPDATE dbo.Fatture
	SET    Importo = Importo + Importo * COALESCE(@InteressePercentuale,0)
	WHERE  IdFornitore = @Fornitore;

	SELECT SUM(importo) as Importo
	FROM   dbo.Fatture
	WHERE  IdFornitore = @Fornitore;

END;
GO

/*Per eseguire questo codice, utilizziamo 
la sintassi exec <NomeProcedura> parametri*/

EXEC dbo.AggiornaEmostraFatture @InteressePercentuale=0.02, @Fornitore=1;




