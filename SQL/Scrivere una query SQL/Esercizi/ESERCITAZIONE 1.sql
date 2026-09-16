/*Svolgi gli esercizi seguenti sul Database CorsoSQL*/

USE CorsoSQL;
--Esercizio 1: Estrarre le denominazioni di tutti i fornitori.
SELECT Denominazione
FROM dbo.Fornitori;

--Esercizio 2: Estrarre i primi 5 clienti in ordine alfabetico per cognome.
SELECT TOP 5 Nome, Cognome
FROM dbo.Clienti
ORDER BY Cognome ASC;

--Esercizio 3: Visualizzare gli importi delle fatture con importo maggiore
SELECT TOP 3 IdFattura, Importo
FROM dbo.Fatture
ORDER BY Importo DESC;

--Esercizio 4: Selezionare i clienti residenti in 'Lombardia' o 'Lazio'.
SELECT *
FROM dbo.Clienti
WHERE RegioneResidenza IN ('Lombardia', 'Lazio')

--Esercizio 5: Trovare i clienti il cui cognome contiene la stringa 'os' in qualsiasi posizione.
SELECT *
FROM dbo.Clienti
WHERE Cognome LIKE '%os%';

--Esercizio 6: Estrarre il numero di fatture emesse tra il 1� giugno 2018 e il 31 agosto 2019.
SELECT COUNT(IdFattura) AS NumeroFatture
FROM dbo.Fatture
WHERE DataFattura >= '20180610'
AND DataFattura <= '20190831';

--Esercizio 7: Trovare l'importo massimo e minimo tra le fatture di tipologia 'A'.
SELECT MAX(Importo) AS ImportoMAX, MIN(Importo) AS ImportoMIN
FROM dbo.Fatture
WHERE Tipologia = 'A';

--Esercizio 8: Calcolare l'importo medio delle fatture emesse nel 2018.
SELECT AVG(Importo) AS Media
FROM dbo.Fatture
WHERE YEAR(DataFattura) = 2018;

--Esercizio 9: Riportare per ogni anno il fatturato totale (somma importi) delle fatture di tipologia V.
SELECT YEAR(DataFattura) AS Anno, SUM(Importo) AS FatturatoTotale
FROM dbo.Fatture
WHERE Tipologia = 'V'
GROUP BY YEAR(DataFattura);

--Esercizio 10: Calcolare il numero di fatture emesse per ogni tipologia.
SELECT Tipologia, COUNT(*)
FROM dbo.Fatture
GROUP BY Tipologia

--Esercizio 11: Selezionare le regioni che hanno pi� di 10 clienti.
SELECT RegioneResidenza, COUNT(*) AS CLienti
FROM dbo.Clienti
GROUP BY RegioneResidenza
HAVING COUNT(*) > 10;


--Esercizio 12: Trovare i fornitori che hanno emesso fatture per un totale superiore a 80.
SELECT IdFornitore, SUM(Importo) AS Fatturato
FROM dbo.Fatture
GROUP BY IdFornitore
HAVING SUM(Importo) > 80;

--Esercizio 13: Contare quanti fornitori diversi hanno lavorato con ogni cliente.
SELECT IdCliente, COUNT(DISTINCT IdFornitore) AS FornitoriUnici
FROM dbo.Fatture
GROUP BY IdCliente;


/*Svolgi gli esercizi seguenti (un po' pi� difficili) sul Database Gestionale*/
USE Gestionale;

/*Esercizio 1:
Scrivi una query per estrarre le fatture che rispettano
almeno una tra queste condizioni
- data fattura compresa tra 2 novembre 2018 e 1 marzo 2019 (estremi eslusi)
- spedizione non valorizzata
- id fornitore 1 o 3.



In particolare visualizzare in output 
- l'IdFattura
- una colonna di nome Esito Consegna valorizzata con "In orario" se la DataArrivoEffettiva
� minore o uguale alla DataArrivoRichiesta, "In ritardo" altrimenti
(altrimenti NULL)

*/

SELECT IdFattura, 
    CASE
        WHEN DataArrivoEffettiva <= DataArrivoRichiesta THEN 'In orario'
        ELSE 'In ritardo'
    END AS EsitoConsegna
FROM dbo.Fatture
WHERE (DataFattura BETWEEN '20181102' AND '20190301')
    OR Spedizione IS NULL
    OR IdFornitore IN (1,3);


/*Esercizio 2:
Scrivi una query per estrarre l'elenco delle Denominazioni dei fornitori
che sono presenti in almeno una fattura nel periodo tra il primo agosto 2018 e il 
15 agosto 2018 (considerare la DataFattura)
*/
SELECT fo.Denominazione
FROM dbo.Fatture AS fa  
INNER JOIN dbo.Fornitori AS fo  
    ON fa.IdFornitore = fo.IdFornitore
WHERE fa.DataFattura BETWEEN '20180801' AND '20180815'
GROUP BY fo.Denominazione



/*Esercizio 3
Scrivi una query per estrarre per ogni anno
il numero di clienti a cui � stata emessa almeno una fattura in quell'anno.
(Considerare la DataFattura)
*/

SELECT YEAR(DataFattura) AS Anno, COUNT(DISTINCT IdCliente)
FROM dbo.Fatture
GROUP BY YEAR(DataFattura);



/*Esercizio 4
Scrivi la query per estrarre la combinazione di anno e mese dove 
si � registrato il numero pi� alto di clienti che hanno fatto almeno una fattura in quell'anno-mese.
Gestire eventuali pari-merito a piacere.
(Considerare la DataFattura)
*/

SELECT TOP 1 WITH TIES 
    YEAR(DataFattura) AS Anno,
    MONTH(DataFattura) AS Mese
FROM dbo.Fatture
GROUP BY 
    YEAR(DataFattura), 
    MONTH(DataFattura)
ORDER BY COUNT(DISTINCT IdCliente) DESC;