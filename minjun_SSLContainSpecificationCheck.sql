IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationCheck' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationCheck
GO
    
/*************************************************************************************************    
 ��  �� - ����Ͻ�-�������_minjun : Ȯ��
 �ۼ��� - '2020-04-09
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationCheck
    @ServiceSeq    INT          = 0 ,   -- ���� �����ڵ�
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- ���� �����ڵ�
    @LanguageSeq   INT          = 1 ,   -- ��� �����ڵ�
    @UserSeq       INT          = 0 ,   -- ����� �����ڵ�
    @PgmSeq        INT          = 0 ,   -- ���α׷� �����ڵ�
    @IsTransaction BIT          = 0     -- Ʈ������ ����
AS
    DECLARE @MessageType    INT             -- �����޽��� Ÿ��
           ,@Status         INT             -- ���º���
           ,@Results        NVARCHAR(250)   -- �������
           ,@Count          INT             -- ä�������� Row ��
           ,@Seq            INT             -- Seq
           ,@MaxNo          NVARCHAR(20)    -- ä�� ������ �ִ� No
           ,@Date           NCHAR(8)        -- Date
           ,@TblName        NVARCHAR(MAX)   -- Table��
           ,@SeqName        NVARCHAR(MAX)   -- Table Ű�� ��
    

    UPDATE   #BIZ_OUT_DataBlock1
      SET   WorkingTag = 'A'
     FROM   #BIZ_OUT_DataBlock1      AS M
    WHERE  M.WorkingTag = 'U'
       AND  M.MatItemSeq NOT IN(SELECT MatItemSeq   FROM minjun_TSLContainSpecification)








  --  -- ���̺�, Ű�� ��Ī
  --  SELECT  @TblName    = N'minjun_TSLContainSpecification'
  --         ,@SeqName    = N'MatItemSeq'
  --  
  --  -- üũ����
  --  EXEC dbo._SCOMMessage   @MessageType    OUTPUT
  --                         ,@Status         OUTPUT
  --                         ,@Results        OUTPUT
  --                         ,0                       -- SELECT * FROM _TCAMessageLanguage WITH(NOLOCK) WHERE LanguageSeq = 1 AND Message LIKE '%%'
  --                         ,@LanguageSeq
  --                         ,0, ''                   -- SELECT * FROM _TCADictionary WITH(NOLOCK) WHERE LanguageSeq = 1 AND Word LIKE '%%'
  --                         ,0, ''                   -- SELECT * FROM _TCADictionary WITH(NOLOCK) WHERE LanguageSeq = 1 AND Word LIKE '%%'
  --  UPDATE  #BIZ_OUT_DataBlock1
  --     SET  Result          = @Results
  --         ,MessageType     = @MessageType
  --         ,Status          = @Status
  --    FROM  #BIZ_OUT_DataBlock1     AS M
  --   WHERE  M.WorkingTag IN('')
  --     AND  M.Status = 0
  --
  --
  --
  --
  --
  --  -- ä���ؾ� �ϴ� ������ �� Ȯ��
  --  SELECT @Count = COUNT(1) FROM #BIZ_OUT_DataBlock1 WHERE WorkingTag = 'A' AND Status = 0 
  --   
  --  -- ä��
  --  IF @Count > 0
  --  BEGIN
  --      -- �����ڵ�ä�� : ���̺��� �ý��ۿ��� Max������ �ڵ� ä���� ���� �����Ͽ� ä��
  --      EXEC @Seq = dbo._SCOMCreateSeq @CompanySeq, @TblName, @SeqName, @Count
  --      
  --      UPDATE  #BIZ_OUT_DataBlock1
  --         SET  MatItemSeq = @Seq + DataSeq
  --       WHERE  WorkingTag  = 'A'
  --         AND  Status      = 0
  --      
  --     -- �ܺι�ȣ ä���� ���� ���ڰ�
  --     SELECT @Date = CONVERT(NVARCHAR(8), GETDATE(), 112)        
  --     
  --     -- �ܺι�ȣä�� : ������ �ܺ�Ű�������ǵ�� ȭ�鿡�� ���ǵ� ä����Ģ���� ä��
  --     EXEC dbo._SCOMCreateNo 'SL', @TblName, @CompanySeq, '', @Date, @MaxNo OUTPUT
  --     
  --     UPDATE  #BIZ_OUT_DataBlock1
  --        SET  TableNo = @MaxNo
  --      WHERE  WorkingTag  = 'A'
  --        AND  Status      = 0
  --  END

RETURN