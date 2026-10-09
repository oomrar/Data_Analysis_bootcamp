/*Esempio 7
popolare la tabella Clienti a partire 
dal contenuto del file Clienti.csv*/

/*Nei casi reali, il database può essere popolato a partire 
da dati contenuti in file. Per questa tipologia di attività
si segue il paradigma noto come ETL (Extract - Transform - Load)
*/

/*Con EXTRACT intendiamo la fase in cui spostiamo i dati
dal file al database. In alcuni casi, se il file ha le informazioni
organizzate in modo diverso rispetto a quella che è stata la progettazione
delle tabelle, può essere utile creare un database "di parcheggio", noto
solitamente come STAGING_AREA, oppure rinominare le tabelle in cui
importeremo i dati usando ad esempio il prefisso STAGING. Possiamo
importare i dati in due modalità: tramite SQL Server Management
Studio o tramite codice SQL*/

/*Import tramite SQL SERVER MANAGEMENT STUDIO
I passi da seguire sono
1) click con tasto destro sul database dove vogliamo importare i dati
2) scegliere dal menù la voce "Attività" e in seguito "Importa dati..." 
3) in alto, scegliere dal menù "Origine dati" la voce "Flat File Source"
e cliccare su Next
4) scegliere il file tramite il tasto sfoglia, selezionare il delimitatore
nella scheda colonna, guardare l'anteprima e cliccare su Next
5) in alto, scegliere dal menù "Destinazione" la voce
"Sql Server Native Client 11.0" e cliccare Next
6) inserire le credenziali per connettersi al database (molto spesso
il default proposto va già bene, quindi basta cliccare su Next)
7) scegliere il nome della tabella (ad esempio StagingClienti). 
Se la tabella esiste già, specificare tramite il tasto
ModificaMapping se eliminare o meno le righe già 
presenti (solitamente si eliminano)
8) scegliere di Eseguire Immediatamente, senza salvare */

SELECT * FROM dbo.StagingClienti

/*Import tramite codice SQL, utilizzando BULK INSERT. */
/*Nota: l'import può essere fatto solo in una tabella
già esistente. */

--Cancello la tabella creata precedentemente con la procedura guidata
DROP TABLE dbo.StagingClienti

CREATE TABLE dbo.StagingClienti(
	CodiceCLiente varchar(255),
	Denominazione  varchar(255),
	DataNascita varchar(255),
	RegioneResidenza varchar(255)
	)

GO

/*Attenzione
probabilmente prima di ogni nuovo import dovremo svuotare la
tabella di Staging. Basterà lanciare l'istruzione TRUNCATE*/

TRUNCATE TABLE dbo.StagingClienti

/*Ecco il codice della BULK INSERT */
	
BULK INSERT dbo.StagingClienti
FROM 'C:\Users\ianto\Desktop\Corsi\CorsoSQL\Clienti.csv'
WITH
(   
    FIRSTROW = 2,
    FIELDTERMINATOR = ';', 
    ROWTERMINATOR = '\n',   
    TABLOCK
)

SELECT * FROM dbo.StagingClienti
SELECT * FROM dbo.Clienti

/*La fase di TRANSFORM consiste nel riorganizzare il 
contenuto e il formato dei dati importati nella 
tabella di Staging per renderlo omogeneo
con la struttura della tabella target*/

SELECT CodiceCliente,
	TRIM(SUBSTRING(Denominazione,1,
          CHARINDEX(',',Denominazione)-1)) AS Nome,
	TRIM(SUBSTRING(Denominazione, 
          CHARINDEX(',',Denominazione) + 1,
          1000))  as Cognome,
	CONVERT(date, DataNascita, 103) AS DataNascita,
	RegioneResidenza
FROM dbo.StagingClienti

/*L'ultima fase di LOAD consiste nel caricare i dati nella tabella
target. In base a come è disegnato il processo, la procedura 
di LOAD può avvenire in tre modalità:
1) svuotiamo e ripopoliamo la tabella Target
2) modifichiamo la tabella Target aggiungendo solo le nuove righe
ed eventualmente aggiornando quelle già esistenti
3) inseriamo tutte le nuove righe nella tabella Target senza cancellare 
niente, ma indicando la data di riferimento dei dati

La scelta del disegno dipende sostanzialmente da
1) avere la necessità di archiviare i dati e ripetere gli 
esperimenti
2) se il file contiene tutti i dati di analisi,
oppure è un'integrazione di quanto già presente sul database*/

/*Prima modalità: svuotiamo e ripopoliamo la tabella Target */
TRUNCATE TABLE dbo.Clienti;

INSERT INTO dbo.Clienti
    (IdCliente, Nome, Cognome,
	 DataNascita, RegioneResidenza)
SELECT CodiceCliente,
	TRIM(SUBSTRING(Denominazione,1,
          CHARINDEX(',',Denominazione)-1)) as Nome,
	TRIM(SUBSTRING(Denominazione, 
          CHARINDEX(',',Denominazione) + 1,
          1000))  as Cognome,
	CONVERT(DATE, DataNascita, 103) as DataNascita,
	RegioneResidenza
FROM   dbo.StagingClienti as s;

SELECT * FROM dbo.Clienti

/*Seconda modalità
gestiamo le aggiunte e le modifiche rispetto ai dati già presenti*/

UPDATE cl
SET cl.Nome=Fl.Nome,
	cl.Cognome=Fl.Cognome,
	cl.DataNascita=Fl.DataNascita,
	cl.RegioneResidenza=Fl.RegioneResidenza
FROM   dbo.Clienti AS cl
INNER JOIN (SELECT CodiceCliente,
				TRIM(SUBSTRING(Denominazione,1,
					  CHARINDEX(',',Denominazione)-1)) as Nome,
				TRIM(SUBSTRING(Denominazione, 
					  CHARINDEX(',',Denominazione) + 1,
					  1000))  as Cognome,
				CONVERT(DATE, DataNascita, 103) as DataNascita,
				RegioneResidenza
			FROM dbo.StagingClienti
) AS Fl
	ON cl.IdCliente = Fl.CodiceCliente;

INSERT INTO dbo.Clienti
	(IdCliente,Nome,Cognome,
	DataNascita, RegioneResidenza)
SELECT CodiceCliente,
	TRIM(SUBSTRING(Denominazione,1,
		CHARINDEX(',',Denominazione)-1)) as Nome,
	TRIM(SUBSTRING(Denominazione, 
		CHARINDEX(',',Denominazione) + 1,
		1000))  as Cognome,
	CONVERT(DATE, DataNascita, 103) as DataNascita,
	RegioneResidenza
FROM dbo.StagingClienti as s
WHERE NOT EXISTS (SELECT *
				  FROM  dbo.Clienti as c
				  WHERE s.CodiceCliente=c.IdCliente);


