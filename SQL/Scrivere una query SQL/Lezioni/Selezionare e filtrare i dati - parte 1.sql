--------------------------------------------------
--LEZIONE 0: PRIMI PASSI CON SQL
--PAROLE CHIAVE: SELECT,FROM
--ALTRI COSTRUTTI: TOP, AS, ORDER BY, ASC, DESC 
--------------------------------------------------

--Lavoriamo sul Database CorsoSQL
Use CorsoSql;

/*Esempio1
Visualizzare il contenuto delle colonne 
Nome e Cognome della tabella Clienti */
SELECT Nome, Cognome
FROM   dbo.Clienti;

/*Commento
Dopo la parola chiave SELECT, abbiamo inserito i nomi delle colonne
che vogliamo visualizzare. Dopo la parola chiave FROM abbiamo inserito
la tabella che contiene tali colonne */


/*Esempio2
Visualizzare il contenuto delle colonne 
Nome, Cognome, DataNascita della tabella Clienti*/
SELECT Nome, Cognome, DataNascita
FROM   dbo.Clienti;

/*Commento
per aggiungere una colonna rispetto all'esempio 1, 
basta inserire il suo nome nella SELECT separandola dalle
altre con una virgola. */


/*Esempio3
Visualizzare tutte le colonne della tabella clienti */
SELECT IdCliente, Nome, Cognome, DataNascita, RegioneResidenza
FROM   dbo.Clienti;

/*Scorciatoia: possiamo ottenere lo stesso risultato
pi� velocemente inserendo dopo SELECT il simbolo */
SELECT *
FROM   dbo.Clienti;

/*Osservazione importante:
in un database reale alcune tabelle potrebbero 
contenere tantissime righe. Eseguire una semplice query del tipo 
"SELECT * FROM Tabella" potrebbe comportare un importante carico
di lavoro per il sistema. Nella prossima query � utilizzata la sintassi
"SELECT TOP 50" che permette di visualizzare soltanto 50 
righe della tabella, un numero sufficiente per farci un'idea
sul suo contenuto */

SELECT TOP 5 *
FROM   dbo.Clienti;

/*Osservazione: 
la query precedente estrae 50 righe casuali della tabella.
Nelle tabelle di un database relazione NON c'� il concetto di 
"prima riga", "seconda riga", eccetera. Per specificare un ordinamento
� necessario inserire una clausola ORDER BY. La query seguente
ad esempio estrae i primi 50 clienti secondo l'ordinamento
ascendente della colonna nome*/

SELECT TOP 5 *
FROM   dbo.Clienti
ORDER  BY Nome ASC;

/*Osservazione:
per l'ordinamento decrescente possiamo usare 
ORDER BY Nome DESC. Se non specifichiamo ASC o DESC
il valore di default � ASC */


/*Esempio 4
Riportare Nome, Cognome e IdCliente. La colonna contenente il
IdCliente deve avere come titolo CodiceCliente.*/
SELECT Nome, Cognome, IdCliente AS CodiceCliente
FROM   dbo.Clienti;

/*Commento
Per raggiungere lo scopo � bastato utilizzare la parola AS.
Ovviamente non si tratta di una rinomina sulla tabella reale
salvata all'interno del database, ma soltanto di
modificare quanto si vede nell'output della query. */



-----------------------------------------------------------------
--LEZIONE 1: FILTRARE I DATI IN UNA TABELLA
--PAROLA CHIAVE: WHERE
--ALTRI COSTRUTTI: AND, OR, =, IN, >, >=, <, <=, <>, LIKE 
-----------------------------------------------------------------

/*Esempio 1
Visualizzare nome, cognome e regione di residenza dei clienti residenti in Lombardia*/

SELECT Nome, Cognome, RegioneResidenza
FROM   dbo.Clienti
WHERE  RegioneResidenza = 'Lombardia';

/*Commento:
per inserire il filtro abbiamo usato la nuova parola chiave WHERE.
Osserviamo che la parola 'Lombardia' � racchiusa tra apici.
Se non usassimo gli apici, il codice restituirebbe un errore
perch� andrebbe a cercare i valori contenuti all'interno
di un'ipotetica colonna di nome Lombardia */


/*Esempio 2
Visualizzare nome, cognome e regione di residenza dei clienti residenti in Lombardia 
e che si chiamano Alberto*/

SELECT Nome, Cognome, RegioneResidenza
FROM   dbo.Clienti
WHERE  RegioneResidenza = 'Lombardia'
AND    Nome = 'Alberto';    

/*Commento:
Quando inserisco pi� di un filtro, essi devono essere connessi con un AND 
oppure con un OR. Analizzate come cambia il risultato lanciando la query 
usando l'OR*/

SELECT Nome, Cognome, RegioneResidenza
FROM   dbo.Clienti
WHERE  RegioneResidenza = 'Lombardia'
OR     Nome = 'Alberto';   



/*Commento
Per evitare ambiguit� � sempre meglio utilizzare nel codice SQL
i nomi estesi delle tabelle. Scriveremo dunque dbo.Clienti,
dbo.Fatture, dbo.Prodotti, inserendo anche la parte iniziale */
SELECT *
FROM   dbo.Clienti;


