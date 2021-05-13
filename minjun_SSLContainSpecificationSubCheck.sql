IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationSubCheck' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationSubCheck
GO
    
/*************************************************************************************************    
 설  명 - 비즈니스-용기사양등록_minjun : Sub확인
 작성일 - '2020-04-09
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationSubCheck
    @ServiceSeq    INT          = 0 ,   -- 서비스 내부코드
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- 법인 내부코드
    @LanguageSeq   INT          = 1 ,   -- 언어 내부코드
    @UserSeq       INT          = 0 ,   -- 사용자 내부코드
    @PgmSeq        INT          = 0 ,   -- 프로그램 내부코드
    @IsTransaction BIT          = 0     -- 트랜젝션 여부
AS
    DECLARE @MessageType    INT             -- 오류메시지 타입
           ,@Status         INT             -- 상태변수
           ,@Results        NVARCHAR(250)   -- 결과문구
           ,@Count          INT             -- 채번데이터 Row 수
           ,@Seq            INT             -- Seq
           ,@MaxNo          NVARCHAR(20)    -- 채번 데이터 최대 No
           ,@Date           NCHAR(8)        -- Date
           ,@TblName        NVARCHAR(MAX)   -- Table명
           ,@SeqName        NVARCHAR(MAX)   -- Table 키값 명
    
    -- 테이블, 키값 명칭
    SELECT  @TblName    = N'minjun_TSLContainSpecificationSub'
           ,@SeqName    = N'MatItemSeq'
    
    


EXEC dbo._SCOMMessage   @MessageType    OUTPUT
                           ,@Status         OUTPUT
                           ,@Results        OUTPUT
                           ,6                       -- SELECT * FROM _TCAMessageLanguage WITH(NOLOCK) WHERE LanguageSeq = 1 AND Message LIKE '%가%입력%'
                           ,@LanguageSeq
                           ,0, '제품'               -- SELECT * FROM _TCADictionary WITH(NOLOCK) WHERE LanguageSeq = 1 AND Word LIKE '%%'
                          
    UPDATE  #BIZ_OUT_DataBlock1
       SET  Result          = REPLACE(@Results, '@2', M.ItemSeq)
           ,MessageType     = @MessageType
           ,Status          = @Status
      FROM  #BIZ_OUT_DataBlock1     AS M
            JOIN(   SELECT  X.ItemSeq
                      FROM  minjun_TSLContainSpecificationSub         AS X   WITH(NOLOCK)
                     WHERE  X.CompanySeq    = @CompanySeq
                       AND  NOT EXISTS( SELECT  1
                                          FROM  #BIZ_OUT_DataBlock1
                                         WHERE  WorkingTag IN('U', 'D')
                                           AND  Status = 0
                                           AND  ItemSeq     = X.ItemSeq
                                           )

                    INTERSECT  --기존에 있던 값을 가지고 있기 위해 기존에 있는 임시테이블에 던져줌
                    SELECT  Y.ItemSeq
                      FROM  #BIZ_OUT_DataBlock1         AS Y   WITH(NOLOCK)
                     WHERE  Y.WorkingTag IN('A', 'U')
                       AND  Y.Status = 0

                 )AS A    ON  A.ItemSeq  = M.ItemSeq
     WHERE  M.WorkingTag IN('A', 'U')
       AND  M.Status = 0






    -- 자재 상태가 폐기인 것은 SS1에 저장은 되지만 SS2에는 저장을 할 수 없음
       UPDATE  #BIZ_OUT_DataBlock1
          SET  Result          = '폐기된 용기입니다.'
              ,MessageType     = 9999
              ,Status          = 9999
         FROM  #BIZ_OUT_DataBlock1     AS M
         JOIN  _TDAItem                AS A     WITH(NOLOCK)   ON  A.CompanySeq = @CompanySeq
                                                               AND A.ItemSeq    = M.MatItemSeq
         WHERE A.SMStatus = 2001002
    


   -- SS1저장을 하지 않고 SS2 저장 진행 시 오류 체크
    UPDATE  #BIZ_OUT_DataBlock1
       SET  Result          = '메인 데이터가 부족합니다.'
           ,MessageType     = 8888
           ,Status          = 8888
      FROM  #BIZ_OUT_DataBlock1                 AS M
      WHERE NOT EXISTS (SELECT * FROM minjun_TSLContainSpecification AS A WHERE M.MatItemSeq  = A.MatItemSeq)














  --  -- 채번해야 하는 데이터 수 확인
  --  SELECT @Count = COUNT(1) FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'A' AND Status = 0 
  --   
  --  -- 채번
  --  IF @Count > 0
  --  BEGIN
  --      -- 내부코드채번 : 테이블별로 시스템에서 Max값으로 자동 채번된 값을 리턴하여 채번
  --      EXEC @Seq = dbo._SCOMCreateSeq @CompanySeq, @TblName, @SeqName, @Count
  --      
  --      UPDATE  #BIZ_OUT_DataBlock1
  --         SET  MatItemSeq = @Seq + DataSeq
  --       WHERE  WorkingTag  = 'A'
  --         AND  Status      = 0
  --      
  --      -- 외부번호 채번에 쓰일 일자값
  --      SELECT @Date = CONVERT(NVARCHAR(8), GETDATE(), 112)        
  --      
  --      -- 외부번호채번 : 업무별 외부키생성정의등록 화면에서 정의된 채번규칙으로 채번
  --      EXEC dbo._SCOMCreateNo 'SL', @TblName, @CompanySeq, '', @Date, @MaxNo OUTPUT
  --      
  --      UPDATE  #BIZ_OUT_DataBlock1
  --         SET  TableNo = @MaxNo
  --       WHERE  WorkingTag  = 'A'
  --         AND  Status      = 0
  --  END

RETURN