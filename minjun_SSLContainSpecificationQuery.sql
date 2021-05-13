IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationQuery' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationQuery
GO
    
/*************************************************************************************************    
 설  명 - 비즈니스-용기사양등록_minjun : 조회
 작성일 - '2020-04-09
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationQuery
    @ServiceSeq    INT          = 0 ,   -- 서비스 내부코드
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- 법인 내부코드
    @LanguageSeq   INT          = 1 ,   -- 언어 내부코드
    @UserSeq       INT          = 0 ,   -- 사용자 내부코드
    @PgmSeq        INT          = 0 ,   -- 프로그램 내부코드
    @IsTransaction BIT          = 0     -- 트랜젝션 여부
AS
    -- 변수선언
    DECLARE 
     @MatItemName               NVARCHAR(100)
    ,@IsReg                     INT
    ,@IsNotReg                  INT
    ,@MatItemNo                 NVARCHAR(100)
    ,@MatItemSpec               NVARCHAR(100)
    ,@UMContainKindSeq          INT
    ,@UMContainLSeq             INT
    ,@UMContainMSeq             INT
    ,@CustSeq                   INT
    ,@UMMaterialSeq             INT




    -- 조회조건 받아오기
    SELECT  
                @MatItemName              = RTRIM(LTRIM(ISNULL(M.MatItemName         ,  '')))
               ,@IsReg                    = RTRIM(LTRIM(ISNULL(M.IsReg               ,  0 )))
               ,@IsNotReg                 = RTRIM(LTRIM(ISNULL(M.IsNotReg            ,  0 )))
               ,@MatItemNo                = RTRIM(LTRIM(ISNULL(M.MatItemNo           ,  '')))
               ,@MatItemSpec              = RTRIM(LTRIM(ISNULL(M.MatItemSpec         ,  '')))
               ,@UMContainKindSeq         = RTRIM(LTRIM(ISNULL(M.UMContainKindSeq    ,  0 )))
               ,@UMContainLSeq            = RTRIM(LTRIM(ISNULL(M.UMContainLSeq       ,  0 )))
               ,@UMContainMSeq            = RTRIM(LTRIM(ISNULL(M.UMContainMSeq       ,  0 )))
               ,@CustSeq                  = RTRIM(LTRIM(ISNULL(M.CustSeq             ,  0 )))
               ,@UMMaterialSeq            = RTRIM(LTRIM(ISNULL(M.UMMaterialSeq       ,  0 )))


      FROM  #BIZ_IN_DataBlock1      AS M



-------------------------------------------------------------------------------------------

    -- 조회
        SELECT  B.ItemSeq        AS MatItemSeq             						
               ,B.ItemNo         AS MatItemNo              						
               ,B.ItemName       AS MatItemName            						
               ,B.Spec           AS MatItemSpec            						
               ,NULL             AS UMContainKindSeq       							
               ,''               AS UMContainKindName      								
               ,NULL             AS UMContainLSeq          							
               ,''               AS UMContainLName         							
               ,NULL             AS UMContainMSeq          							
               ,''               AS UMContainMName         							
               ,NULL             AS UMContainSSeq          							
               ,''               AS UMContainSName         							
               ,NULL             AS CustSeq                          					
               ,''               AS CustName                         						
               ,NULL             AS UMMaterialSeq          						
               ,''               AS UMMaterialName         							
               ,NULL             AS UMOriCountrySeq        							
               ,''               AS UMOriCountryName       								
               ,NULL	         AS Volume                       		
               ,NULL             AS UMCreateKindSeq        							
               ,''               AS UMCreateKindName       								
               ,NULL             AS UMRoughnessSeq         						
               ,''               AS UMRoughnessName        							
               ,NULL             AS Thickness                              						
               ,NULL             AS Length                                 					
               ,NULL             AS OuterDiamete                           							
               ,NULL             AS Weight					
               ,NULL             AS TestPressure							
               ,NULL             AS DesignPressure							
               ,NULL             AS UnitSeq 					
               ,''               AS UnitName						
               ,NULL             AS UMInsideProcSeq							
               ,''               AS UMInsideProcName								
               ,(SELECT 1
                  FROM _TDAItem
                  WHERE SMStatus = 2001002
                    AND B.ItemNo = ItemNo
                    AND B.ItemName = ItemName) AS IsStop									
               ,''               AS Remark		
               ,1                AS Ord
          
          INTO #Temp_NO
          FROM  _TDAItem AS B
         WHERE CompanySeq = 1
           AND AssetSeq = 6
           AND NOT EXISTS (SELECT 1
                               FROM  minjun_TSLContainSpecification      AS CS  
                               WHERE B.ItemSeq = CS.MatItemSeq)



-------------------------------------------------------------------------------------------



    -- 조회결과 담아주기
    SELECT

         B.ItemSeq                  AS MatItemSeq                                           
        ,B.ItemNo                   AS MatItemNo                                            
        ,B.ItemName                 AS MatItemName                                          
        ,B.Spec                     AS MatItemSpec                                          
        ,C.MinorSeq                 AS UMContainKindSeq                                     
        ,C.MinorName                AS UMContainKindName                                    
        ,D.MinorSeq                 AS UMContainLSeq                                        
        ,D.MinorName                AS UMContainLName                                       
        ,E.MinorSeq                 AS UMContainMSeq                                        
        ,E.MinorName                AS UMContainMName                                       
        ,F.MinorSeq                 AS UMContainSSeq                                        
        ,F.MinorName                AS UMContainSName                                       
        ,B2.CustSeq                                                                         
        ,B2.CustName                                                                        
        ,H.MinorSeq                 AS UMMaterialSeq                                        
        ,H.MinorName                AS UMMaterialName                                       
        ,I.MinorSeq                 AS UMOriCountrySeq                                      
        ,I.MinorName                AS UMOriCountryName                                     
        ,A.Volume                                                                           
        ,J.MinorSeq                 AS UMCreateKindSeq                                      
        ,J.MinorName                AS UMCreateKindName                                     
        ,K.MinorSeq                 AS UMRoughnessSeq                                       
        ,K.MinorName                AS UMRoughnessName                                      
        ,A.Thickness                                                                        
        ,A.Length                                                                           
        ,A.OuterDiamete                                                                     
        ,A.Weight
        ,A.TestPressure
        ,A.DesignPressure
        ,B1.UnitSeq 
        ,B1.UnitName
        ,M.MinorSeq                 AS UMInsideProcSeq
        ,M.MinorName                AS UMInsideProcName
        ,(SELECT 1
            FROM _TDAItem
           WHERE SMStatus = 2001002
             AND B.ItemNo =   ItemNo
             AND B.ItemName = ItemName) AS IsStop	
        ,A.Remark
        ,2       AS Ord --?
        
        
      INTO  #Temp 



      FROM  _TDAItem                                            AS B  
      LEFT OUTER JOIN   minjun_TSLContainSpecification          AS A    WITH(NOLOCK)     ON  A.CompanySeq    = B.CompanySeq
                                                                                        AND  A.MatItemSeq    = B.ItemSeq
      LEFT OUTER JOIN   _TDACust                                AS B2   WITH(NOLOCK)     ON  B2.CompanySeq   = A.CompanySeq
                                                                                        AND  B2.CustSeq      = A.CustSeq
      LEFT OUTER JOIN   _TDAUnit                                AS B1   WITH(NOLOCK)     ON  B1.CompanySeq   = A.CompanySeq
                                                                                        AND  B1.UnitSeq      = A.UnitSeq
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000248)
                                                                AS C                     ON  C.CompanySeq    = A.CompanySeq
                                                                                        AND  C.MinorSeq      = A.UMContainKind  
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000249)                              
                                                                AS D                     ON  D.CompanySeq    = A.CompanySeq
                                                                                        AND  D.MinorSeq      = A.UMContainLSeq                                                                                         
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000251)                              
                                                                AS E                     ON  E.CompanySeq    = A.CompanySeq
                                                                                        AND  E.MinorSeq      = A.UMContainMSeq                                                                                         
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000258)                              
                                                                AS F                     ON  F.CompanySeq    = A.CompanySeq
                                                                                        AND  F.MinorSeq      = A.UMContainSSeq                                                                                          
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000250)                              
                                                                AS H                     ON  H.CompanySeq    = A.CompanySeq
                                                                                        AND  H.MinorSeq      = A.UMMaterial
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000259)                              
                                                                AS I                     ON  I.CompanySeq    = A.CompanySeq
                                                                                        AND  I.MinorSeq      = A.UMOriCountry 
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000260)                              
                                                                AS J                     ON  J.CompanySeq    = A.CompanySeq
                                                                                        AND  J.MinorSeq      = A.UMCreateKind 
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000261)                              
                                                                AS K                     ON  K.CompanySeq    = A.CompanySeq
                                                                                        AND  K.MinorSeq      = A.UMRoughness 
      LEFT OUTER JOIN   (select * from _TDAUMinor where  MajorSeq=2000262)                              
                                                                AS M                     ON  M.CompanySeq    = A.CompanySeq
                                                                                        AND  M.MinorSeq      = A.UMInsideProc

     WHERE    A.CompanySeq    = @CompanySeq
     AND (    B.AssetSeq = 6                                                                                                           )
     AND (@MatItemName               = ''                 OR  B.ItemName                 LIKE    @MatItemName          + '%'           )
     AND (@MatItemNo                 = ''                 OR  B.ItemNo                   LIKE    @MatItemNo            + '%'           )
     AND (@MatItemSpec               = ''                 OR  B.Spec                     LIKE    @MatItemSpec          + '%'           )
     AND (@UMContainKindSeq          = 0                  OR  C.MinorSeq                 =       @UMContainKindSeq                     )
     AND (@UMContainLSeq             = 0                  OR  D.MinorSeq                 =       @UMContainLSeq                        )
     AND (@UMContainMSeq             = 0                  OR  E.MinorSeq                 =       @UMContainMSeq                        )
     AND (@CustSeq                   = 0                  OR  B2.CustSeq                 =       @CustSeq                              )
     AND (@UMMaterialSeq             = 0                  OR  H.MinorSeq                 =       @UMMaterialSeq                        )



-------------------------------------------------------------------------------------------


   IF @IsReg = 0 AND @IsNotReg = 1
       SELECT * FROM #Temp_NO


   ELSE IF @IsReg = 1 AND @IsNotReg = 0

       SELECT * FROM #Temp


   ELSE IF (@IsReg = 1 AND @IsNotReg = 1) OR (@IsReg = 0 AND @IsNotReg = 0)
        SELECT * 
          FROM(
                SELECT * FROM #Temp 
                UNION
                SELECT * FROM #Temp_NO
               ) AS TotalItem
    ORDER BY Ord DESC


-------------------------------------------------------------------------------------------

RETURN


  