IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TSLContainSpecificationSub' AND xtype = 'U' )
    Drop table minjun_TSLContainSpecificationSub

CREATE TABLE minjun_TSLContainSpecificationSub
(
    CompanySeq		INT 	 NOT NULL, 
    MatItemSeq		INT 	 NOT NULL, 
    ItemSeq		INT 	 NOT NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL, 
CONSTRAINT PKminjun_TSLContainSpecificationSub PRIMARY KEY CLUSTERED (CompanySeq ASC, MatItemSeq ASC, ItemSeq ASC)

)


IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TSLContainSpecificationSubLog' AND xtype = 'U' )
    Drop table minjun_TSLContainSpecificationSubLog

CREATE TABLE minjun_TSLContainSpecificationSubLog
(
    LogSeq		INT IDENTITY(1,1) NOT NULL, 
    LogUserSeq		INT NOT NULL, 
    LogDateTime		DATETIME NOT NULL, 
    LogType		NCHAR(1) NOT NULL, 
    LogPgmSeq		INT NULL, 
    CompanySeq		INT 	 NOT NULL, 
    MatItemSeq		INT 	 NOT NULL, 
    ItemSeq		INT 	 NOT NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL
)

CREATE UNIQUE CLUSTERED INDEX IDXTempminjun_TSLContainSpecificationSubLog ON minjun_TSLContainSpecificationSubLog (LogSeq)
go