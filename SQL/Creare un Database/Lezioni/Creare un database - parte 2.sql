CREATE TABLE dbo.Attori (
	IdAttore int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL,
	DataNascita date NULL);

CREATE TABLE dbo.Registi(
	IdRegista INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Cognome VARCHAR(50) NOT NULL, 
	DataNascita DATE NULL);

CREATE TABLE dbo.Film (
    IdFilm INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Titolo VARCHAR(100) NOT NULL,
	AnnoProduzione INT NULL,
	DataUscita DATE NULL,
	DurataMinuti DECIMAL(18,2) NULL);

/*Terzo step: Studiare le relazioni tra le tabelle*/

/*Tra le entit� del database possono esistere delle relazioni.
Le relazioni possono essere classificate in quattro tipoligie. 
Consideriamo per le tabelle dbo.Registi e dbo.Film tutte 
e quattro le potenziali tipologie, scegliendo 
in seguito quella pi� corretta.

Relazione uno a molti
Un Regista pu� dirigere un solo film  
mentre un film pu� essere diretto da pi� registi
-->SOLUZIONE: inserisco una colonna nella tabella dbo.Registi con
l'indicazione del film che ha diretto

Relazione molti a uno
Un Regista pu� dirigere pi� film 
mentre un film pu� essere diretto da un solo regista
-->SOLUZIONE: inseriamo una colonna nella tabella dbo.Film contenente 
l'indicazione del regista che dirige il film

Relazione uno a uno
Un Regista pu� dirigere un solo film 
e un film pu� essere diretto da un solo Regista
-->SOLUZIONE1: inseriamo una colonna nella tabella dbo.Film contenente 
l'indicazione del regista che dirige il film
-->SOLUZIONE2: inserisco una colonna nella tabella dbo.Registi con
l'indicazione del film che ha diretto
-->SOLUZIONE3: creo una sola tabella con tutte le informazioni 

Relazione molti a molti
Un Regista pu� dirigere pi� di un film 
e un film pu� essere diretto da pi� registi.
SOLUZIONE: creo una nuova tabella contenente le associazioni
tra le chiavi primarie delle due tabelle */

/*Per il caso specifico Regista-Film la relazione pi� idonea
� la molti a uno. Procediamo dunque con la modifica della tabella
dbo.Film cos� come indicato nella relativa soluzione */

ALTER TABLE dbo.FILM ADD IdRegista INT NOT NULL DEFAULT

/*Su questa nuova colonna andremo a creare un vincolo di
Chiave Esterna. Con questo vincolo non sar� possibile 
1) inserire nella colonna IdRegista della tabella dbo.Film
un valore che non � gi� presente nella colonna IdRegista della
tabella dbo.Registi
2) eliminare dalla tabella dbo.Registi una riga con un IdRegista gi�
presente nella tabella dbo.Film */

ALTER TABLE dbo.Film ADD FOREIGN KEY (IdRegista)
REFERENCES dbo.Registi(IdRegista);

/*Osservazioni:
La colonna IdRegista deve essere chiave primaria 
della tabella dbo.Registi.
La colonna IdRegista della tabella dbo.Film potrebbe in alcuni casi
anche ammettere valori null, la scelta dipende dal contesto*/

/*Per il caso specifico Film-Attori la relazione pi� idonea
� la molti a molti. Creiamo dunque la tabella di associazione*/

CREATE TABLE dbo.FilmAttori (
	IdFilm INT NOT NULL ,
	IdAttore INT NOT NULL );


/*Su questa tabella inseriamo una chiave primaria sulla combinazione
delle colonne IdFilm e IdAttore e due chiavi esterne sulle colonne
IdFilm e IdAttore considerate separatamente */

ALTER TABLE dbo.FilmAttori ADD PRIMARY KEY (IdFilm, IdAttore);

ALTER TABLE dbo.FilmAttori ADD FOREIGN KEY (IdFilm)
REFERENCES dbo.Film(IdFilm);

ALTER TABLE dbo.FilmAttori ADD FOREIGN KEY (IdAttore)
REFERENCES dbo.Attori(IdAttore);

/*Anche se non � molto frequente, le tabelle di associazioni possono 
contenere anche altre colonne. L'importante � che si tratti
di attributi relativi alla relazione tra attore e film,
n� al singolo attore (in quel caso le inseriremmo nella tabella
degli attori) e n� al singolo regista (in quel caso le inseriremmo
nella tabella dei film). 
In questo caso ad esempio potremmo considerare di aggiungere 
una colonna che indichi se l'attore � uno dei protagonisti
di quel film*/


-----------------------------------------------------
--Quarto passo: aggiungere ulteriori vincoli di tipo check
-----------------------------------------------------

/*I vincoli check permettono di rafforzare i vincoli di tipo.
Con il prossimo vincolo ci assicuriamo che nel nostro database
non entrino righe dove l'anno di produzione del film � precedente
al 1950.*/ 

ALTER TABLE dbo.FILM ADD CHECK (AnnoProduzione >= 1950);

/*Attenzione a non esagerare col numero di vincoli di questo
tipo perch� ovviamente avranno un impatto sulle performance delle
operazioni di aggiornamento del database */


/*Jolly:
Per i campi numerici � altamento sconsigliato l'utilizzo 
di float. Ecco un esempio dei problemi che possono capitare*/

CREATE TABLE dbo.TabellaConFloat (campo1 FLOAT);

INSERT INTO dbo.TabellaConFloat (campo1)
VALUES (0.1);

/*ora prendiamo due minuti di tempo e lanciamo le due query seguenti
(update e select) insieme e per circa cento volte. 
Intorno alla cinquantesima esecuzione inizieremo a vedere
dei risultati approssimati*/

UPDATE dbo.TabellaConFloat
SET    campo1=campo1+0.1
WHERE  campo1<10;
SELECT * FROM dbo.TabellaConFloat;



