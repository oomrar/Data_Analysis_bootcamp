
CREATE DATABASE EventiDB;
GO

USE EventiDB;

CREATE TABLE dbo.Luoghi (
    IdLuogo INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    NomeLuogo VARCHAR(50) NOT NULL,
    Citta VARCHAR(50) NOT NULL);

CREATE TABLE dbo.Eventi (
        IdEvento INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
        TitoloEvento VARCHAR(100) NOT NULL,
        PrezzoBiglietto DECIMAL(18,2) NOT NULL DEFAULT 15.00
        CHECK (PrezzoBiglietto >= 0),
        IdLuogo INT NOT NULL
        FOREIGN KEY(IdLuogo) REFERENCES dbo.Luoghi(IdLuogo));

INSERT INTO dbo.Luoghi (NomeLuogo, Citta)
VALUES 
    ('Sardegna', 'Cagliari'), 
    ('Lombardia', 'Milano');

INSERT INTO dbo.Eventi (TitoloEvento, PrezzoBiglietto, IdLuogo)
VALUES 
    ('Partita CAGLIARI FC', 120.00, 1), 
    ('Fiera AI', DEFAULT, 2),
    ('Barca a vela', 25, 1);

SELECT * 
FROM dbo.Luoghi

SELECT  *
FROM dbo.Eventi
