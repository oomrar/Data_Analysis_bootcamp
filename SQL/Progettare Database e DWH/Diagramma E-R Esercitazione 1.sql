

USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'SocialMedia')
BEGIN
    ALTER DATABASE SocialMedia SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SocialMedia;
END
GO

CREATE DATABASE SocialMedia
GO
use SocialMedia
GO
CREATE TABLE dbo.Utenti(
    IdUtente INT NOT NULL,
    username VARCHAR (50) NOT NULL,
    email VARCHAR (50) NOT NULL,
    data_registrazione DATE NOT NULL,
    PRIMARY KEY (IdUtente)
    )

CREATE TABLE dbo.Post(
    IdPost INT NOT NULL,
    titolo VARCHAR (50) NULL,
    contenuto NVARCHAR (MAX) NULL,
    DataPubblicazione DATETIME NULL,
    pubblicato BIT NOT NULL,
    IdUtente INT NOT NULL,
    PRIMARY KEY (IdPost),
    FOREIGN KEY (IdUtente) REFERENCES dbo.Utenti(IdUtente)
    )

CREATE TABLE dbo.Commenti(
    IdCommento INT NOT NULL,
    contenuto VARCHAR (MAX) NOT NULL,
    DataContenuto DATETIME NOT NULL,
    PRIMARY KEY (IdCommento),
    IdUtente INT NOT NULL,
    IdCommentoRisposta INT NULL,
    IdPost INT NOT NULL,
    FOREIGN KEY (IdUtente) REFERENCES dbo.Utenti (IdUtente),
    FOREIGN KEY (IdCommentoRisposta) REFERENCES dbo.Commenti (IdCommento),
    FOREIGN KEY (IdPost) REFERENCES dbo.Post(IdPost)
    )

CREATE TABLE dbo.Follow (
    IdFollow INT NOT NULL,
    DataFollow DATETIME NOT NULL,
    PRIMARY KEY (IdFollow),
    follower INT NOT NULL,
    following INT NOT NULL,
    FOREIGN KEY (follower) REFERENCES dbo.Utenti (IdUtente),
    FOREIGN KEY (following) REFERENCES dbo.Utenti (IdUtente),
    CHECK (follower != following)
    )

CREATE TABLE dbo.Categorie(
    IdCategoria INT NOT NULL,
    nome VARCHAR (20) NOT NULL,
    descrizione VARCHAR (MAX) NOT NULL,
    PRIMARY KEY (IdCategoria),
    )

CREATE TABLE dbo.CategoriaPost(
    IdCategoria INT NOT NULL,
    IdPost INT NOT NULL,
    PRIMARY KEY (IdCategoria, IdPost),
    FOREIGN KEY (IdCategoria) REFERENCES dbo.Categorie (IdCategoria),
    FOREIGN KEY (IdPost) REFERENCES dbo.Post (IdPost)
    )