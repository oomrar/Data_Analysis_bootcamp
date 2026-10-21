USE CorsoSQL;
GO

-- 1. CREAZIONE E POPOLAMENTO DELLA PARTE NON NORMALIZZATA (Sorgente)
DROP TABLE IF EXISTS CorsoSQL.non_normalizzato.Prestiti;
DROP TABLE IF EXISTS CorsoSQL.non_normalizzato.Clienti;
GO
DROP SCHEMA IF EXISTS non_normalizzato;
GO

CREATE SCHEMA non_normalizzato;
GO

CREATE TABLE CorsoSQL.non_normalizzato.Prestiti(
	NumeroPrestito INT NOT NULL,
	NumeroCliente INT NOT NULL,
	DataAperturaPrestito DATE NULL,
	Tipologia VARCHAR(50) NULL,
	DataNascitaCliente DATE NULL,
	PRIMARY KEY(NumeroPrestito, NumeroCliente)
);

CREATE TABLE CorsoSQL.non_normalizzato.Clienti(
	NumeroCliente INT NOT NULL,
	Residenza VARCHAR(50) NULL,
	PRIMARY KEY (NumeroCliente)
);

INSERT INTO CorsoSQL.non_normalizzato.Prestiti(NumeroPrestito, NumeroCliente, DataAperturaPrestito, Tipologia, DataNascitaCliente)
VALUES 
	(1, 1, '20260105', 'A', '19800602'),
	(1, 2, '20260105', 'A', '19870301'),
	(2, 3, '20260320', 'V', '19830208'),
	(3, 1, '20260402', 'V', '19800602'),
	(4, 4, '20260405', 'A', '19820915');

INSERT INTO CorsoSQL.non_normalizzato.Clienti(NumeroCliente, Residenza)
VALUES 
	(1, 'Lombardia-86012'),
	(2, 'Lombardia-86012'),
	(3, 'Piemonte-03012'),
	(4, 'Molise-81012');
GO


-- 2. PULIZIA E CREAZIONE DELLO SCHEMA NORMALIZZATO
DROP TABLE IF EXISTS CorsoSQL.normalizzato.PrestitiClienti;
DROP TABLE IF EXISTS CorsoSQL.normalizzato.Prestiti;
DROP TABLE IF EXISTS CorsoSQL.normalizzato.Clienti;
GO
DROP SCHEMA IF EXISTS normalizzato;
GO

CREATE SCHEMA normalizzato;
GO

-- Tabella Clienti (con la data di nascita spostata qui)
CREATE TABLE CorsoSQL.normalizzato.Clienti(
    NumeroCliente INT NOT NULL,
    Residenza VARCHAR(50) NULL,
    DataNascitaCliente DATE NULL,
    Cap VARCHAR(50) NULL,
    PRIMARY KEY (NumeroCliente)
);

-- Tabella Prestiti (con le informazioni uniche del prestito)
CREATE TABLE CorsoSQL.normalizzato.Prestiti(
    NumeroPrestito INT NOT NULL,
    DataAperturaPrestito DATE NULL,
    Tipologia VARCHAR(50) NULL,
    PRIMARY KEY (NumeroPrestito)
);
GO


-- 3. POPOLAMENTO DELLE NUOVE TABELLE TRAMITE SELECT DISTINCT
-- Popoliamo i Clienti prendendo i dati unici dalla vecchia tabella
-- Popoliamo i Clienti nel modo corretto
INSERT INTO CorsoSQL.normalizzato.Clienti (NumeroCliente, Residenza, Cap, DataNascitaCliente)
SELECT DISTINCT 
    c.NumeroCliente, 
    c.Residenza, 
    -- Eventuale CAP estratto dalla residenza (se vuoi metterlo nella colonna Cap)
    TRIM(SUBSTRING(c.Residenza, CHARINDEX('-', c.Residenza) + 1, LEN(c.Residenza))) AS Cap,
    -- La vera data di nascita che recuperiamo dalla vecchia tabella prestiti
    p.DataNascitaCliente 
FROM CorsoSQL.non_normalizzato.Clienti c
JOIN CorsoSQL.non_normalizzato.Prestiti p ON c.NumeroCliente = p.NumeroCliente;


-- Popoliamo i Prestiti prendendo i dati unici dalla vecchia tabella
INSERT INTO CorsoSQL.normalizzato.Prestiti (NumeroPrestito, DataAperturaPrestito, Tipologia)
SELECT DISTINCT NumeroPrestito, DataAperturaPrestito, Tipologia
FROM CorsoSQL.non_normalizzato.Prestiti;
GO

-- Creiamo la tabella per il match

CREATE TABLE CorsoSQL.normalizzato.PrestitiClienti(
    NumeroCliente INT NOT NULL,
    NumeroPrestito INT NOT NULL,
    PRIMARY KEY (NumeroCliente, NumeroPrestito)
)

ALTER TABLE CorsoSQL.normalizzato.PrestitiClienti ADD FOREIGN KEY (NumeroCliente) REFERENCES normalizzato.Clienti(NumeroCliente);
ALTER TABLE CorsoSQL.normalizzato.PrestitiClienti ADD FOREIGN KEY (NumeroPrestito) REFERENCES normalizzato.Prestiti(NumeroPrestito);

INSERT INTO normalizzato.PrestitiClienti
SELECT DISTINCT NumeroCliente, NumeroPrestito
FROM non_normalizzato.Prestiti

SELECT * 
FROM normalizzato.Clienti

SELECT * 
FROM normalizzato.Prestiti

SELECT * 
FROM normalizzato.PrestitiClienti