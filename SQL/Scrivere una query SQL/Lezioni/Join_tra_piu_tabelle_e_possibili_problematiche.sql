USE Gestionale;

/*Nel commento è presente il risultato quando interroghiamo solamente
la tabella fatture (e che resta tale fino all'ultima join con FattureProdotti)
*/
SELECT COUNT(*) AS NumeroRighe, --300
	COUNT(DISTINCT Fa.IdFattura) AS NumeroFatture, --300
	SUM(Fa.Spedizione) AS SommaSpedizione --295.00
FROM   dbo.Fatture AS Fa
INNER JOIN	dbo.Clienti AS Cl
	ON Fa.IdCliente = Cl.IdCliente
INNER JOIN	dbo.Fornitori AS Fo
	ON Fa.IdFornitore = Fo.IdFornitore
INNER JOIN	dbo.Corrieri AS Co
	ON Fa.IdCorriere = Co.IdCorriere
INNER JOIN	dbo.FattureProdotti AS fp
	ON Fa.IdFattura = fp.IdFattura;

/*Una fattura può essere ripetuta più volte all'interno della
tabella FattureProdotti */
SELECT * 
FROM dbo.FattureProdotti 
WHERE IdFattura = 3
