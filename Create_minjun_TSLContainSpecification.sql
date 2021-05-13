IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TSLContainSpecification' AND xtype = 'U' )
    Drop table minjun_TSLContainSpecification

CREATE TABLE minjun_TSLContainSpecification
(
    CompanySeq		INT 	 NOT NULL, 
    MatItemSeq		INT 	 NOT NULL, 
    UMContainKind		INT 	 NULL, 
    UMContainLSeq		INT 	 NULL, 
    UMContainMSeq		INT 	 NULL, 
    UMContainSSeq		INT 	 NULL, 
    CustSeq		INT 	 NULL, 
    UMMaterial		INT 	 NULL, 
    UMOriCountry		INT 	 NULL, 
    Volume		DECIMAL(19,5) 	 NULL, 
    UMCreateKind		INT 	 NULL, 
    UMRoughness		INT 	 NULL, 
    Thickness		DECIMAL(19,5) 	 NULL, 
    Length		DECIMAL(19,5) 	 NULL, 
    OuterDiamete		DECIMAL(19,5) 	 NULL, 
    Weight		DECIMAL(19,5) 	 NULL, 
    TestPressure		DECIMAL(19,5) 	 NULL, 
    DesignPressure		DECIMAL(19,5) 	 NULL, 
    UnitSeq		INT 	 NULL, 
    UMInsideProc		INT 	 NULL, 
    Remark		NVARCHAR(500) 	 NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL, 
CONSTRAINT PKminjun_TSLContainSpecification PRIMARY KEY CLUSTERED (CompanySeq ASC, MatItemSeq ASC)

)


IF EXISTS (SELECT * FROM Sysobjects where Name = 'minjun_TSLContainSpecificationLog' AND xtype = 'U' )
    Drop table minjun_TSLContainSpecificationLog

CREATE TABLE minjun_TSLContainSpecificationLog
(
    LogSeq		INT IDENTITY(1,1) NOT NULL, 
    LogUserSeq		INT NOT NULL, 
    LogDateTime		DATETIME NOT NULL, 
    LogType		NCHAR(1) NOT NULL, 
    LogPgmSeq		INT NULL, 
    CompanySeq		INT 	 NOT NULL, 
    MatItemSeq		INT 	 NOT NULL, 
    UMContainKind		INT 	 NULL, 
    UMContainLSeq		INT 	 NULL, 
    UMContainMSeq		INT 	 NULL, 
    UMContainSSeq		INT 	 NULL, 
    CustSeq		INT 	 NULL, 
    UMMaterial		INT 	 NULL, 
    UMOriCountry		INT 	 NULL, 
    Volume		DECIMAL(19,5) 	 NULL, 
    UMCreateKind		INT 	 NULL, 
    UMRoughness		INT 	 NULL, 
    Thickness		DECIMAL(19,5) 	 NULL, 
    Length		DECIMAL(19,5) 	 NULL, 
    OuterDiamete		DECIMAL(19,5) 	 NULL, 
    Weight		DECIMAL(19,5) 	 NULL, 
    TestPressure		DECIMAL(19,5) 	 NULL, 
    DesignPressure		DECIMAL(19,5) 	 NULL, 
    UnitSeq		INT 	 NULL, 
    UMInsideProc		INT 	 NULL, 
    Remark		NVARCHAR(500) 	 NULL, 
    LastUserSeq		INT 	 NULL, 
    LastDateTime		DATETIME 	 NULL
)

CREATE UNIQUE CLUSTERED INDEX IDXTempminjun_TSLContainSpecificationLog ON minjun_TSLContainSpecificationLog (LogSeq)
go