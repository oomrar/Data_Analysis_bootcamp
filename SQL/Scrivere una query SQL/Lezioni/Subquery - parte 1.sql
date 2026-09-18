-----------------------------------------------------------
--LEZIONE 4: RISOLVERE PROBLEMI COMPLESSI
--COMBINANDO IL RISULTATO DI PIÙ QUERY SEMPLICI
--CTE, SOTTOQUERY, TABELLE TEMPORANEE, EXISTS, NOT EXISTS
-----------------------------------------------------------

USE CorsoSql

/*Le istruzioni viste finora sono i mattoni fondamentali
con i quali è possibile risolvere una percentuale elevatissima
di problemi legati all'analisi dichiarativa dei dati. 

Nella maggior parte dei casi, è sufficiente affrontare i
problemi più complessi suddividendoli in sotto-problemi più semplici,
affrontando ognuno di loro con la classica sintassi 
SELECT-FROM-WHERE-GROUP BY-HAVING, e infine "mettendo insieme i singoli step
in un'unica soluzione". In questa sezione vediamo per l'appunto 
come "mettere insieme" più query semplici per risolvere problemi complessi.*/


/*Esempio 1
Calcolare il fatturato annuo medio. 
Con fatturato annuo intendiamo la somma degli importi delle fatture 
in quell'anno. Quindi con fatturato annuo medio intendiamo
semplicemente la media aritmetica di tali fatturati annui.*/

/*Affrontare il problema in una sola query è quasi impossibile. 
Spesso si finisce per scrivere una query del genere che restituisce
un errore di esecuzione*/

/*
SELECT YEAR(DataFattura) as Anno,
	AVG(SUM(Importo)) as FatturatoMedio
FROM   Fatture
GROUP BY YEAR(DataFattura)
*/

/*
Invece di provare a risolvere il tutto con una sola query, 
dividiamo il problema in due sotto-problemi:
1) calcolare la somma degli importi delle fatture divisi per anni
2) calcolare la media di questi valori

Il primo sotto problema è risolvibile con questa semplice query */

SELECT YEAR(DataFattura) as Anno,
	SUM(Importo) as FatturatoAnnuo
FROM   dbo.Fatture
GROUP BY YEAR(DataFattura)

/*Osserviamo il risultato di questa query.

Anno	FatturatoAnnuo
2016	87.00
2017	238.00
2018	201.00
2019	197.00

Ci appare in tutto e per tutto simile al contenuto di una tabella. 
Immaginiamo per un attimo di avere un'ipotetica tabella di nome
"Step1" con questi dati. Come risolvereste il secondo problema?
Basterebbe scrivere

SELECT AVG(FatturatoAnnuo) AS FatturatoAnnuoMedio
FROM   Step1;

È sicuramente impensabile creare realmente una tabella per ogni passo
intermedio di ogni singolo problema. In pochi giorni avremmo migliaia di 
tabelle e il database diventerebbe inutilizzabile. Vediamo tre
strade alternative per risolvere questo problema */

/*Soluzione 1: SubQuery*/
SELECT AVG(FatturatoAnnuo) AS FatturatoAnnuoMedio
FROM   (
		SELECT YEAR(DataFattura) as Anno,
			SUM(Importo) as FatturatoAnnuo
		FROM   dbo.Fatture
		GROUP BY YEAR(DataFattura)
		) AS Step1;

/*Commento:
siccome abbiamo detto che il risultato di una query si mostra in tutto
e per tutto come una tabella, l'idea è quello di inserire la query 
direttamente nella clausola FROM di una query più esterna. Abbiamo 
in questo caso una subquery. Dobbiamo seguire solo qualche vincolo di
sintassi: racchiudere la query interna tra parantesi tonde e assegnarle
un nome con AS. */

/*Soluzione 2: CTE (Common Table Expression) */
WITH Step1 as 
	(
	SELECT YEAR(DataFattura) as Anno,
		   SUM(Importo) as FatturatoAnnuo
	FROM   dbo.Fatture
	GROUP BY YEAR(DataFattura)
	)
SELECT AVG(FatturatoAnnuo) AS FatturatoAnnuoMedio
FROM   Step1;
		

/*Commento:
Questa tecnica è praticamente identica alla SubQuery. L'unica differenza
è che il codice degli step intermedi va scritto "sopra" la query principale,
rendendo il tutto più leggibile*/

/*Soluzione 3: Tabelle temporanee */

SELECT   YEAR(DataFattura) as Anno,
	     SUM(Importo) as FatturatoAnnuo
INTO     #Step1
FROM     dbo.Fatture
GROUP BY YEAR(DataFattura)

SELECT AVG(FatturatoAnnuo) AS FatturatoAnnuoMedio
FROM   #Step1;

/*Attenzione! È fondamentale che il nome della tabella
indicata nella INTO inizi con il carattere #*/

/*Commento:
Questa tecnica crea una vera e propria tabella. Infatti, inserire la 
clausola INTO prima della FROM ha l'effetto di creare e popolare
una tabella con il risultato della query. Se il nome di tale tabella
inizia con il simbolo #, si tratterà però di una tabella temporanea. 
Essa ha due caratteristiche principali:
1) viene eliminata automaticamente appena ci disconnettiamo
dal database
2) non è visibile ad altri utenti (a meno che non inseriamo all'inizio
un doppio cancelletto, ad esempio ##step1)

È importante osservare che, seppur temporaneamente, i dati occuperanno spazio
sul disco, in un area di memoria condivisa da tutti i database dell'istanza.
*/

