/*Esempio 2
Riportare codice, nome e cognome dei clienti che hanno associata almeno
una fattura con importo superiore a 50 euro */

/*Potremmo affrontare questo problema anche con le tecniche 
dei capitolo precedenti, ad esempio tramite la query seguente*/
SELECT DISTINCT C.IdCliente, C.Nome, C.Cognome
FROM   dbo.Fatture as F
INNER JOIN dbo.Clienti as C
	ON F.IdCliente = C.IdCliente
WHERE  F.Importo > 50;

/*Osservazione
dopo la FROM abbiamo una riga per ogni fattura, di conseguenza 
se vogliamo restituire un elenco di clienti è fondamentale scrivere
una DISTINCT dopo la select, o equivalentemente usare una GROUP BY
per utilizzarne l'effetto di rimozione dei duplicati */

SELECT C.IdCliente, C.Nome, C.Cognome
FROM   dbo.Fatture as F
INNER JOIN dbo.Clienti as C
	ON F.IdCliente = C.IdCliente
WHERE  F.Importo > 50
GROUP BY C.IdCliente, C.Nome, C.Cognome;

/*Vediamo come risolvere il problema utilizzando le SubQuery.
Fino ad ora le abbiamo utilizzate soltanto all'interno della
clausola FROM. Vediamo ora come utilizzarle per filtrare i dati
all'interno della WHERE.

Per l'esercizio in questione osserviamo che, se da un lato le 
informazioni necessarie sono presenti in due tabelle distinte (Fatture 
e Clienti), dall'altro lato le colonne da visualizzare in output
appartento tutte ad uno sola tabella (Clienti).

In questo caso possiamo evitare la JOIN (e dunque anche la DISTINCT) 
utilizzando le sottoquery nella WHERE in congiunzione con l'IN o con 
l'EXISTS. */

/*Prima Soluzione */
SELECT IdCliente, Nome, Cognome
FROM   dbo.Clienti  
WHERE  IdCliente in (SELECT IdCliente 
					 FROM   dbo.Fatture 
					 WHERE  Importo > 50);

/*Seconda Soluzione */
SELECT IdCliente, Nome, Cognome
FROM   dbo.Clienti AS C
WHERE  EXISTS (SELECT IdCliente 
			   FROM   dbo.Fatture AS F
			   WHERE  C.IdCliente = F.IdCliente
			   AND    F.Importo > 50);

/*Osservazione:
in generale l'EXISTS è più generale dell'IN. Ad esempio il seguente
problema non potrebbe essere risolto con l'IN:
"Estrarre tutti i clienti che hanno una fattura emessa nel
mese del loro compleanno". 

La risoluzione seguente è errata in quanto nessuno ci assicura
che la fattura considerata nell'insieme dopo "IN" sia associata
esattamente al cliente estratto.*/

SELECT IdCliente, Nome, Cognome
FROM   dbo.Clienti  
WHERE  MONTH(DataNascita) in (SELECT MONTH(DataFattura) 
						      FROM  dbo.Fatture 
						      WHERE Importo > 50);

/* Il risultato corretto si può ottenere invece 
con l'EXISTS */

SELECT IdCliente, Nome, Cognome
FROM   dbo.Clienti AS C
WHERE  EXISTS (SELECT * 
			   FROM   dbo.Fatture AS F
			   WHERE  C.IdCliente = F.IdCliente
			   AND    MONTH(C.DataNascita) = MONTH(F.DataFattura) );


/*Esempio 3
Estrarre codice, nome e cognome dei clienti senza fatture associate*/

/*Prima soluzione*/
SELECT C.IdCliente, C.Nome, C.Cognome
FROM   dbo.Clienti as C
LEFT JOIN dbo.Fatture as F
	ON C.IdCliente = F.IdCliente
WHERE F.IdCliente IS NULL;

/*Seconda soluzione*/
SELECT IdCliente, Nome, Cognome
FROM   dbo.Clienti as C
WHERE  NOT EXISTS (SELECT * 
				   FROM  dbo.Fatture as F
				   WHERE C.IdCliente = F.IdCliente);

/*Terza Soluzione poco performante*/
SELECT *
FROM   dbo.Clienti
WHERE  IdCliente IN (SELECT IdCliente
					 FROM   dbo.Clienti		
						EXCEPT
					 SELECT IdCliente
					 FROM   dbo.Fatture);

/*Soluzione ad alto tasso di errore*/
SELECT IdCliente, Nome, Cognome
FROM   dbo.Clienti 
WHERE  IdCliente NOT IN (SELECT IdCliente
				         FROM   dbo.Fatture);

/*Commento
L'alta probabilità di errore deriva dal fatto che 
la presenza di un NULL nell'output di una SubQuery inserita
dopo una NOT IN porterà la query finale ad avere zero record. 
Per convincerci proviamo a lanciare il codice seguente */
SELECT *
FROM   dbo.Clienti
WHERE  IdCliente NOT IN (1, NULL);

