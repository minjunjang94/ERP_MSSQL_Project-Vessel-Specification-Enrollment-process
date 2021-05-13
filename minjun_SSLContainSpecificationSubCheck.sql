IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationSubCheck' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationSubCheck
GO
    
/*************************************************************************************************    
 ��  �� - ����Ͻ�-�������_minjun : SubȮ��
 �ۼ��� - '2020-04-09
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationSubCheck
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
    
    -- ���̺�, Ű�� ��Ī
    SELECT  @TblName    = N'minjun_TSLContainSpecificationSub'
           ,@SeqName    = N'MatItemSeq'
    
    


EXEC dbo._SCOMMessage   @MessageType    OUTPUT
                           ,@Status         OUTPUT
                           ,@Results        OUTPUT
                           ,6                       -- SELECT * FROM _TCAMessageLanguage WITH(NOLOCK) WHERE LanguageSeq = 1 AND Message LIKE '%��%�Է�%'
                           ,@LanguageSeq
                           ,0, '��ǰ'               -- SELECT * FROM _TCADictionary WITH(NOLOCK) WHERE LanguageSeq = 1 AND Word LIKE '%%'
                          
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

                    INTERSECT  --������ �ִ� ���� ������ �ֱ� ���� ������ �ִ� �ӽ����̺� ������
                    SELECT  Y.ItemSeq
                      FROM  #BIZ_OUT_DataBlock1         AS Y   WITH(NOLOCK)
                     WHERE  Y.WorkingTag IN('A', 'U')
                       AND  Y.Status = 0

                 )AS A    ON  A.ItemSeq  = M.ItemSeq
     WHERE  M.WorkingTag IN('A', 'U')
       AND  M.Status = 0






    -- ���� ���°� ����� ���� SS1�� ������ ������ SS2���� ������ �� �� ����
       UPDATE  #BIZ_OUT_DataBlock1
          SET  Result          = '���� ����Դϴ�.'
              ,MessageType     = 9999
              ,Status          = 9999
         FROM  #BIZ_OUT_DataBlock1     AS M
         JOIN  _TDAItem                AS A     WITH(NOLOCK)   ON  A.CompanySeq = @CompanySeq
                                                               AND A.ItemSeq    = M.MatItemSeq
         WHERE A.SMStatus = 2001002
    


   -- SS1������ ���� �ʰ� SS2 ���� ���� �� ���� üũ
    UPDATE  #BIZ_OUT_DataBlock1
       SET  Result          = '���� �����Ͱ� �����մϴ�.'
           ,MessageType     = 8888
           ,Status          = 8888
      FROM  #BIZ_OUT_DataBlock1                 AS M
      WHERE NOT EXISTS (SELECT * FROM minjun_TSLContainSpecification AS A WHERE M.MatItemSeq  = A.MatItemSeq)














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
  --      -- �ܺι�ȣ ä���� ���� ���ڰ�
  --      SELECT @Date = CONVERT(NVARCHAR(8), GETDATE(), 112)        
  --      
  --      -- �ܺι�ȣä�� : ������ �ܺ�Ű�������ǵ�� ȭ�鿡�� ���ǵ� ä����Ģ���� ä��
  --      EXEC dbo._SCOMCreateNo 'SL', @TblName, @CompanySeq, '', @Date, @MaxNo OUTPUT
  --      
  --      UPDATE  #BIZ_OUT_DataBlock1
  --         SET  TableNo = @MaxNo
  --       WHERE  WorkingTag  = 'A'
  --         AND  Status      = 0
  --  END

RETURN