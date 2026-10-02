/*Con l'istruzione SET IMPLICIT_TRANSACTIONS ON, 
solo per questa connessione, le operazioni di aggiornamento 
dei dati non sono pi� immediate. Richiedono la necessit� di
confermare (con una COMMIT) o annullare (con una ROLLBACK)
l'operazione. La scelta deve essere fatta comunque velocemente
per impedire blocchi nella altre connessioni.*/
SET IMPLICIT_TRANSACTIONS ON;
 
DELETE
FROM   dbo.Clienti
WHERE  RegioneResidenza = 'Lombardia'

COMMIT; --conferma l'operazione
ROLLBACK; --annulla l'operazione

/*Ripristiniamo il comportamento standard, anche per questa connessione*/
SET IMPLICIT_TRANSACTIONS OFF;
