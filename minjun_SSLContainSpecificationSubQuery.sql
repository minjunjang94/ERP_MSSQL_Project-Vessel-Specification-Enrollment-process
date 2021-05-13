IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationSubQuery' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationSubQuery
GO
    
/*************************************************************************************************    
 설  명 - 비즈니스-용기사양등록_minjun : Sub조회
 작성일 - '2020-04-09
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationSubQuery
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
             @MatItemSeq            INT


    -- 조회조건 받아오기
    SELECT  
      @MatItemSeq                     = RTRIM(LTRIM(ISNULL(M.MatItemSeq       ,   0)))



      FROM  #BIZ_IN_DataBlock1      AS M

    -- 조회결과 담아주기

    SELECT  
             A.MatItemSeq
            ,A.ItemSeq 
            ,B.ItemNo
            ,B.ItemName
            ,A.ItemSeq    AS ItemSeqOLD    

            
      FROM  minjun_TSLContainSpecificationSub                         AS A  
            LEFT OUTER JOIN   _TDAItem                                AS B    WITH(NOLOCK)     ON  B.CompanySeq    = A.CompanySeq
                                                                                              AND  B.ItemSeq       = A.ItemSeq


    WHERE  A.CompanySeq    = @CompanySeq
     AND (@MatItemSeq                = 0                  OR  A.MatItemSeq          =    @MatItemSeq        )

RETURN