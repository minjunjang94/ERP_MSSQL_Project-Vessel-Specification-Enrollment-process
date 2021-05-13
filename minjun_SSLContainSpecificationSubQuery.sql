IF EXISTS (SELECT 1 FROM sysobjects WHERE name = 'minjun_SSLContainSpecificationSubQuery' AND xtype = 'P')    
    DROP PROC minjun_SSLContainSpecificationSubQuery
GO
    
/*************************************************************************************************    
 ��  �� - ����Ͻ�-�������_minjun : Sub��ȸ
 �ۼ��� - '2020-04-09
 �ۼ��� - �����
 ������ - 
*************************************************************************************************/    
CREATE PROCEDURE dbo.minjun_SSLContainSpecificationSubQuery
    @ServiceSeq    INT          = 0 ,   -- ���� �����ڵ�
    @WorkingTag    NVARCHAR(10) = '',   -- WorkingTag
    @CompanySeq    INT          = 1 ,   -- ���� �����ڵ�
    @LanguageSeq   INT          = 1 ,   -- ��� �����ڵ�
    @UserSeq       INT          = 0 ,   -- ����� �����ڵ�
    @PgmSeq        INT          = 0 ,   -- ���α׷� �����ڵ�
    @IsTransaction BIT          = 0     -- Ʈ������ ����
AS
    -- ��������
    DECLARE 
             @MatItemSeq            INT


    -- ��ȸ���� �޾ƿ���
    SELECT  
      @MatItemSeq                     = RTRIM(LTRIM(ISNULL(M.MatItemSeq       ,   0)))



      FROM  #BIZ_IN_DataBlock1      AS M

    -- ��ȸ��� ����ֱ�

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