USE CorsoSQL;

/*Questa join è "corretta". Può essere il punto di partenza
per molte analisi che incrociano i dati di fatture e clienti.
*/
SELECT *
FROM   dbo.Fatture AS F
INNER JOIN	dbo.Clienti AS C
	ON F.IdCliente = C.IdCliente;
--ORDER BY F.IdFornitore;


/*Possibili errori nella scrittura di una Join */

/*Facciamo attenzione perché la query seguente compila, 
ma il risultato ottenuto è privo di senso!
Guardiamo ad esempio la fattura 7.*/
SELECT *
FROM   dbo.Fatture AS F
INNER JOIN	dbo.Clienti AS C
	ON F.IdFattura = C.IdCliente;


/*Ricorda: le colonne che utilizzo nella condizioni di JOIN devono contenere sempre 
la stessa tipologia di informazione.
Ma da solo questo non basta! Ecco un altro esempio potenzialmente errato. 
Mi risulta molto difficile trovare un esercizio per cui questa operazioni abbia senso*/
SELECT * 
FROM dbo.Clienti AS C
INNER JOIN dbo.Fornitori AS F
	ON C.RegioneResidenza = F.RegioneResidenza
--ORDER BY C.IdCliente;
ORDER BY F.IdFornitore;


/*Questa join invece è "corretta", nel senso che può essere il punto di partenza
per molte analisi che incrociano i dati di fatture e clienti*/
SELECT *
FROM   dbo.Fatture AS F
INNER JOIN	dbo.Clienti AS C
	ON F.IdCliente = C.IdCliente;



/*Consiglio: controlliamo sempre come cambia il conteggio dei dati dopo la JOIN e
cerchiamo di capire perché. Potrebbero essere svariati motivi*/

--Partiamo dalla tabella Fatture
SELECT COUNT(*)
FROM   dbo.Fatture AS F;

SELECT COUNT(*)
FROM   dbo.Fatture AS F
INNER JOIN	dbo.Clienti AS C
	ON F.IdFattura = C.IdCliente;

SELECT COUNT(*)
FROM   dbo.Fatture AS F
LEFT JOIN	dbo.Fornitori AS C
	ON F.IdFornitore = C.IdFornitore;

SELECT COUNT(*)
FROM   dbo.Fatture AS F
INNER JOIN	dbo.Fornitori AS C
	ON F.IdFattura = C.IdFornitore;


--Partiamo dalla tabella Clienti
SELECT COUNT(*)
FROM   dbo.Clienti AS C;

SELECT COUNT(*)
FROM   dbo.Clienti AS C 
INNER JOIN	dbo.Fatture AS F
   ON  C.IdCliente = F.IdCliente;

SELECT COUNT(*)
FROM   dbo.Clienti AS C 
INNER JOIN	dbo.Fatture AS F
   ON  C.IdCliente = C.IdCliente;


