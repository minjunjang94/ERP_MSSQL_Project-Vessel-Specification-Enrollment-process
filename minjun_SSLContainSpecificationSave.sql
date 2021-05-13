IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationSave' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationSave
GO
    
/*************************************************************************************************    
 설  명 - 비즈니스-용기사양등록_minjun : 저장
 작성일 - '2020-04-09
 작성자 - 장민준
 수정자 - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationSave
    @ServiceSeq    INT          = 0 ,   -- 서비스 내부코드
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- 법인 내부코드
    @LanguageSeq   INT          = 1 ,   -- 언어 내부코드
    @UserSeq       INT          = 0 ,   -- 사용자 내부코드
    @PgmSeq        INT          = 0 ,   -- 프로그램 내부코드
    @IsTransaction BIT          = 0     -- 트랜젝션 여부
AS
    DECLARE @TblName        NVARCHAR(MAX)   -- Table명
           ,@ItemTblName    NVARCHAR(MAX)   -- 상세Table명
           ,@SeqName        NVARCHAR(MAX)   -- Seq명
           ,@SerlName       NVARCHAR(MAX)   -- Serl명
           ,@SQL            NVARCHAR(MAX)
           ,@TblColumns     NVARCHAR(MAX)
           ,@Seq            INT
    
    -- 테이블, 키값 명칭
    SELECT  @TblName        = N'minjun_TSLContainSpecification'
           --,@ItemTblName    = N'minjun_TSLContainSpecification'
           ,@SeqName        = N'MatItemSeq'
           --,@SerlName       = N'TableSerl'
           --,@SQL            = N''

    -- 로그테이블 남기기(마지막 파라메터는 반드시 한줄로 보내기)  	
	SELECT @TblColumns = dbo._FGetColumnsForLog(@TblName)
    
    EXEC _SCOMLog @CompanySeq
                 ,@UserSeq   
                 ,@TblName                  -- 테이블명      
                 ,'#BIZ_OUT_DataBlock1'     -- 임시 테이블명      
                 ,@SeqName                  -- CompanySeq를 제외한 키(키가 여러개일 경우는 , 로 연결 )      
                 ,@TblColumns               -- 테이블 모든 필드명
                 ,''
                 ,@PgmSeq
                    
    -- =============================================================================================================================================
    -- DELETE
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'D' AND Status = 0 )    
    BEGIN
      -- Detail테이블 삭제로그 남기기
      SELECT  @ItemTblName    = @TblName + N'Item'
  
      -- Detail테이블 컬럼명 가져오기
      SELECT  @TblColumns     = dbo._FGetColumnsForLog(@ItemTblName)
  
      -- Query 동적으로 담기
      SELECT  @SQL    = N''
      SELECT  @SQL    = N'
      INSERT INTO '+@ItemTblName+N'Log('+
          @TblColumns + N'
         ,LogUserSeq
         ,LogDateTime
         ,LogType 
         ,LogPgmSeq
      )
      SELECT  '+@TblColumns+N'
             ,CONVERT(INT, '+CONVERT(NVARCHAR, @UserSeq)+N')
             ,GETDATE()
             ,''D''
             ,CONVERT(INT, '+CONVERT(NVARCHAR, @PgmSeq)+N')
        FROM  '+@ItemTblName+N'  WITH(NOLOCK)
       WHERE  CompanySeq = CONVERT(INT, '+CONVERT(NVARCHAR, @CompanySeq)+')
         AND  '+@SeqName+N' = CONVERT(INT, '+CONVERT(NVARCHAR, @Seq)+')'
      
       -- Query 실행
       EXEC SP_EXECUTESQL @SQL

        IF @@ERROR <> 0 RETURN


        -- Detail테이블 데이터 삭제
        DELETE  A
          FROM  #BIZ_OUT_DataBlock1         AS M
                JOIN minjun_TSLContainSpecification          AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                                AND  A.MatItemSeq    = M.MatItemSeq
         WHERE  M.WorkingTag    = 'D'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
        
       -- Master테이블 데이터 삭제
       DELETE  A
         FROM  #BIZ_OUT_DataBlock1         AS M
               JOIN minjun_TSLContainSpecificationSub              AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                                    AND  A.MatItemSeq      = M.MatItemSeq
        WHERE  M.WorkingTag    = 'D' 
          AND  M.Status        = 0
    
       IF @@ERROR <> 0 RETURN
    END

    -- =============================================================================================================================================
    -- Update
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'U' AND Status = 0 )    
    BEGIN
        UPDATE  A 
           SET      

                 UMContainKind   = M.UMContainKindSeq  
                ,UMContainLSeq   = M.UMContainLSeq  
                ,UMContainMSeq   = M.UMContainMSeq  
                ,UMContainSSeq   = M.UMContainSSeq  
                ,CustSeq         = M.CustSeq        
                ,UMMaterial      = M.UMMaterialSeq     
                ,UMOriCountry    = M.UMOriCountrySeq   
                ,Volume          = M.Volume         
                ,UMCreateKind    = M.UMCreateKindSeq   
                ,UMRoughness     = M.UMRoughnessSeq    
                ,Thickness       = M.Thickness      
                ,Length          = M.Length         
                ,OuterDiamete    = M.OuterDiamete   
                ,Weight          = M.Weight         
                ,TestPressure    = M.TestPressure   
                ,DesignPressure  = M.DesignPressure 
                ,UnitSeq         = M.UnitSeq        
                ,UMInsideProc    = M.UMInsideProcSeq   
                ,Remark          = M.Remark         
                ,LastUserSeq     = @UserSeq
                ,LastDateTime    = GETDATE()




          FROM  #BIZ_OUT_DataBlock1         AS M
                JOIN minjun_TSLContainSpecification              AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                                    AND  A.MatItemSeq    = M.MatItemSeq
         WHERE  M.WorkingTag    = 'U'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

    -- =============================================================================================================================================
    -- INSERT
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'A' AND Status = 0 )    
    BEGIN
        INSERT INTO minjun_TSLContainSpecification (
             CompanySeq
            ,MatItemSeq
            ,UMContainKind  
            ,UMContainLSeq  
            ,UMContainMSeq  
            ,UMContainSSeq  
            ,CustSeq        
            ,UMMaterial     
            ,UMOriCountry   
            ,Volume         
            ,UMCreateKind   
            ,UMRoughness    
            ,Thickness      
            ,Length         
            ,OuterDiamete   
            ,Weight         
            ,TestPressure   
            ,DesignPressure 
            ,UnitSeq        
            ,UMInsideProc   
            ,Remark         
            ,LastUserSeq    
            ,LastDateTime   

        )
        SELECT 
         @CompanySeq
        ,M.MatItemSeq
        ,M.UMContainKindSeq
        ,M.UMContainLSeq  
        ,M.UMContainMSeq  
        ,M.UMContainSSeq  
        ,M.CustSeq        
        ,M.UMMaterialSeq   
        ,M.UMOriCountrySeq 
        ,M.Volume         
        ,M.UMCreateKindSeq 
        ,M.UMRoughnessSeq  
        ,M.Thickness      
        ,M.Length         
        ,M.OuterDiamete   
        ,M.Weight         
        ,M.TestPressure   
        ,M.DesignPressure 
        ,M.UnitSeq        
        ,M.UMInsideProcSeq 
        ,M.Remark         
        ,@UserSeq
        ,GETDATE()
        
        
        
        
         
          FROM  #BIZ_OUT_DataBlock1         AS M
         WHERE  M.WorkingTag    = 'A'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
    END

RETURN



