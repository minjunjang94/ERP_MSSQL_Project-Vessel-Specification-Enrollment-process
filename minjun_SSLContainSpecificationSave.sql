IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationSave' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationSave
GO
    
/*************************************************************************************************    
 ��  �� - ����Ͻ�-�������_minjun : ����
 �ۼ��� - '2020-04-09
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationSave
    @ServiceSeq    INT          = 0 ,   -- ���� �����ڵ�
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- ���� �����ڵ�
    @LanguageSeq   INT          = 1 ,   -- ��� �����ڵ�
    @UserSeq       INT          = 0 ,   -- ����� �����ڵ�
    @PgmSeq        INT          = 0 ,   -- ���α׷� �����ڵ�
    @IsTransaction BIT          = 0     -- Ʈ������ ����
AS
    DECLARE @TblName        NVARCHAR(MAX)   -- Table��
           ,@ItemTblName    NVARCHAR(MAX)   -- ��Table��
           ,@SeqName        NVARCHAR(MAX)   -- Seq��
           ,@SerlName       NVARCHAR(MAX)   -- Serl��
           ,@SQL            NVARCHAR(MAX)
           ,@TblColumns     NVARCHAR(MAX)
           ,@Seq            INT
    
    -- ���̺�, Ű�� ��Ī
    SELECT  @TblName        = N'minjun_TSLContainSpecification'
           --,@ItemTblName    = N'minjun_TSLContainSpecification'
           ,@SeqName        = N'MatItemSeq'
           --,@SerlName       = N'TableSerl'
           --,@SQL            = N''

    -- �α����̺� �����(������ �Ķ���ʹ� �ݵ�� ���ٷ� ������)  	
	SELECT @TblColumns = dbo._FGetColumnsForLog(@TblName)
    
    EXEC _SCOMLog @CompanySeq
                 ,@UserSeq   
                 ,@TblName                  -- ���̺��      
                 ,'#BIZ_OUT_DataBlock1'     -- �ӽ� ���̺��      
                 ,@SeqName                  -- CompanySeq�� ������ Ű(Ű�� �������� ���� , �� ���� )      
                 ,@TblColumns               -- ���̺� ��� �ʵ��
                 ,''
                 ,@PgmSeq
                    
    -- =============================================================================================================================================
    -- DELETE
    -- =============================================================================================================================================
    IF EXISTS (SELECT 1 FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'D' AND Status = 0 )    
    BEGIN
      -- Detail���̺� �����α� �����
      SELECT  @ItemTblName    = @TblName + N'Item'
  
      -- Detail���̺� �÷��� ��������
      SELECT  @TblColumns     = dbo._FGetColumnsForLog(@ItemTblName)
  
      -- Query �������� ���
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
      
       -- Query ����
       EXEC SP_EXECUTESQL @SQL

        IF @@ERROR <> 0 RETURN


        -- Detail���̺� ������ ����
        DELETE  A
          FROM  #BIZ_OUT_DataBlock1         AS M
                JOIN minjun_TSLContainSpecification          AS A  WITH(NOLOCK)  ON  A.CompanySeq    = @CompanySeq
                                                                                AND  A.MatItemSeq    = M.MatItemSeq
         WHERE  M.WorkingTag    = 'D'
           AND  M.Status        = 0

        IF @@ERROR <> 0 RETURN
        
       -- Master���̺� ������ ����
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



