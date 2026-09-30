/*Rispondi alle seguenti domande
1) Cos'� una Subquery?
è una tabella virtuale che viene usata per generare output che derivano da passaggi intermedi a partire dalla tabella iniziale.
2) Qual � la differenza tra Subquery e CTE?
Mentre nella subquery la tabella viene generata nel momento in cui si esegue la query, nella CTE viene creata in una fase separata una tabella temporanea che verrà poi implementata nel codice come una tabella normale
3) Considera la tabella
Fatture(IdFattura, IdCliente, DataFattura, Importo).
Estrai per ogni cliente l'Id della fattura di importo maggiore. 
A parit� di importo considera l'IdFattura pi� grande.
*/

WITH CTE AS
    (SELECT IdFattura, IdCliente, DataFattura, Importo, 
        RANK() OVER(PARTITION BY IdCliente ORDER BY Importo DESC, IdFattura DESC) AS Ordinamento
    FROM dbo.Fatture)

SELECT *
FROM CTE
WHERE Ordinamento = 1


/*Svolgi gli esercizi seguenti sul Database CorsoSQL*/
USE CorsoSQL;

/*Esercizio 1:
Estrarre l�elenco degli IdCliente che hanno almeno una fattura di importo 
superiore alla media di tutte le fatture.*/

SELECT DISTINCT IdCliente, Importo, (SELECT AVG(Importo) FROM dbo.Fatture) AS MediaGenerale
FROM dbo.Fatture
WHERE Importo > (SELECT AVG(Importo) FROM dbo.Fatture);



/*Esercizio 2:
Estrarre il cliente che ha effettuato l'acquisto pi� costoso per ogni anno.*/

WITH CTE AS
    (SELECT IdFattura, IdCliente, DataFattura, Importo, 
        RANK() OVER(PARTITION BY YEAR(DataFattura) ORDER BY Importo DESC) AS Ordinamento
    FROM dbo.Fatture
    )

SELECT *
FROM CTE
WHERE Ordinamento = 1



/*Esercizio 3:
Calcolare la differenza in giorni tra la prima e l'ultima fattura di ogni cliente.*/

SELECT IdCliente, 
       MIN(DataFattura) AS PrimaFattura,
       MAX(DataFattura) AS UltimaFattura,
       DATEDIFF(DAY, MIN(DataFattura), MAX(DataFattura)) AS Differenza 
FROM dbo.Fatture
GROUP BY IdCliente



/*Svolgi gli esercizi seguenti sul Database Gestionale*/
USE Gestionale;

/*Esercizio 4:
Scrivi una query per estrarre l'elenco delle Denominazioni dei fornitori
che sono presenti in almeno una fattura nel periodo tra il primo agosto 2018 e il 
15 agosto 2018 (considerare la DataFattura).
Non utilizzare JOIN+DISTINCT. Risolvi la query con EXISTS o IN
*/

SELECT Denominazione
FROM dbo.Fornitori AS FO  
WHERE EXISTS (SELECT * 
              FROM dbo.Fatture AS FA  
              WHERE FA.IdFornitore = FO.IdFornitore
              AND (FA.DataFattura >= '2018/08/01' AND FA.DataFattura <= '2018/08/15')
              )



/*Esercizio 5
Scrivi la query per estrarre per ogni cliente della regione Lazio o Toscana:
- il nome e cognome separati da uno spazio in un unico campo "Denominazione",
- la regione
- il numero di fatture totali
- il numero di fatture del 2018
- la somma delle quantita di prodotti acquistati nel 2018
*/

SELECT (CL.Nome + ' ' + CL.Cognome) AS Denominazione, CL.Regione, 
       (SELECT COUNT(*) FROM dbo.Fatture AS FA WHERE FA.IdCliente = CL.IdCliente) AS FattureTotali,
       (SELECT COUNT(*) FROM dbo.Fatture AS FA WHERE FA.IdCliente = CL.IdCliente AND YEAR(FA.DataFattura) = 2018) AS Fatture2018,
       (SELECT SUM(FP.Quantita)
        FROM dbo.FattureProdotti AS FP
        INNER JOIN dbo.Fatture AS FA 
            ON FP.IdFattura = FA.IdFattura
        WHERE FA.IdCliente = CL.IdCliente
        AND YEAR(FA.DataFattura) = 2018) AS SommaQuantita
       
FROM dbo.Clienti AS CL
WHERE CL.Regione = 'Lazio' OR CL.Regione = 'Toscana'



/*Svolgi il seguente progetto sul Database Gestionale*/
USE Gestionale;

/*Suggerimento: ti consiglio di non cercare di risolvere direttamente l'esercizio scrivendo fin da subito
un'unica grande query. Procedi per step, calcola i singoli passaggi e mettili insieme con 
CTE, subuqery o tabelle temporanee.
Le window function possono essere sicuramente utili, tuttavia non � necessario utilizzarle, puoi 
arrivare alla fine dell'esercizio anche facendone a meno */

/*Lessico:
- Fatturato dalla vendita di un prodotto: prodotto tra quantit� e prezzo unitario all'interno della 
tabella FattureProdotti
- Fatturato di un corriere: somma del fatturato dei singoli prodotti appartenenti a fatture
associate a quel corriere
- Fatturato annuo: somma del fatturato dei singoli prodotti appartenenti a fatture
associate a quell'anno (prendere in considerazione la colonna DataFattura)
- Incidenza percentuale annua di un corriere: rapporto tra il fatturato del corriere in un anno
e il fatturato totale in quell'anno. Ad esempio se nel 2018 il fatturato totale � stato 100 e 
il fatturato del corriere 1 � stato 20 (sempre considerando il 2018) allora l'incidenza del corriere
1 nel 2018 � stata pari a 20/100 = 0.2 = 20%
*/

/*Tema:
Calcolare per ogni corriere l'incidenza percentuale nel 2018, nel 2019 e stabilire se la tendenza �:
- in aumento se la differenza tra il 2019 e il 2018 � maggiore di 0.10
- in discesa se la differenza tra il 2019 e il 2018 � minore di -0.10
- stabile altrimenti

Esempio di Output
IdCorriere 	Denominazione	Incidenza2018	Incidenza2019	Tendenza
1			Corriere Iba	0.399101		0.371952		Stabile
2			Corriere Cic	0.154192		0.361866		In aumento
3			Corriere Dais	0.446706		0.266180		In discesa
*/

/*Calcolo incidenza percentuale*/

/*Fatturato annuale del corriere*/

/*Fatturato totale dell'anno*/

/*Somma di :: Fatturato dalla vendita di un prodotto: prodotto tra quantit� e prezzo unitario all'interno della 
tabella FattureProdotti*/
IF OBJECT_ID('tempdb..#PROVA') IS NOT NULL
    DROP TABLE #PROVA;

WITH FatturatoTotale AS
(SELECT YEAR(FA.DataFattura) AS Anno, SUM((Quantita * PrezzoUnitario)) AS FatturatoTotaleAnnuo
FROM dbo.FattureProdotti AS FP 
INNER JOIN dbo.Fatture AS FA 
    ON FP.IdFattura = FA.IdFattura
GROUP BY YEAR(FA.DataFattura)),

FatturatoCorriere AS
(SELECT YEAR(FA.DataFattura) AS Anno, CO.IdCorriere, SUM((FP.Quantita * FP.PrezzoUnitario)) AS FatturatoAnnuoCorriere
FROM dbo.FattureProdotti AS FP  
INNER JOIN dbo.Fatture AS FA  
    ON FP.IdFattura = FA.IdFattura
INNER JOIN dbo.Corrieri AS CO  
    ON FA.IdCorriere = CO.IdCorriere
GROUP BY YEAR(FA.DataFattura), CO.IdCorriere
)


SELECT T.Anno, C.IdCorriere, (C.FatturatoAnnuoCorriere/T.FatturatoTotaleAnnuo) AS IncidenzaPercentuale
INTO #PROVA
FROM FatturatoTotale AS T
INNER JOIN FatturatoCorriere AS C
    ON T.Anno = C.Anno



SELECT IdCorriere,
       Denominazione,
       Incidenza2018,
       Incidenza2019,
       CASE 
            WHEN (Incidenza2019-Incidenza2018) > 0.10 THEN 'in aumento'
            WHEN (Incidenza2019-Incidenza2018) < -0.10 THEN 'in discesa'
            ELSE 'stabile'
        END AS Tendenza 
FROM 
       (SELECT CO.IdCorriere, 
       CO.Denominazione, 
       (SELECT IncidenzaPercentuale
                          FROM #PROVA AS P  
                          WHERE CO.IdCorriere = P.IdCorriere
                          AND P.Anno = 2018) AS Incidenza2018, 
        (SELECT IncidenzaPercentuale
                          FROM #PROVA AS P  
                          WHERE CO.IdCorriere = P.IdCorriere
                          AND P.Anno = 2019) AS Incidenza2019
             
        FROM dbo.Corrieri AS CO) AS TabellaPivot;
