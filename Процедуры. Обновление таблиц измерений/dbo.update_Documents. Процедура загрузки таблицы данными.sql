SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Documents]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Documents]
GO

CREATE PROCEDURE [dbo].[update_Documents]
AS
BEGIN

	MERGE INTO [dbo].[t_Documents] AS ReportingTable
	USING (	
			SELECT
				DocSales.������ AS UID_1C														-- ID ���������
				,'���������� ������� �'+RTRIM(DocSales.�����)+' �� '
					+ CONVERT(varchar(10), CAST(DocSales.���� AS date), 104) AS Description		-- �������� ���������
				,DocumentsTypes.ID AS DocumentsTypeID											-- ��� ���������
				,CAST(DocSales.���� AS date) AS DocDate											-- ���� ���������
				,DocSales.����� AS DocNumber													-- ����� ���������
				,ISNULL(SalesDocumentsType.ID, 2) AS SalesDocumentTypeID						-- ID ���� ���������
				,ISNULL(PaymentsType.ID, 1) AS PaymentMethodID									-- ID ������� ������ ���������
				,DocSales.���������������� AS IsBonusDoc										-- ������� ��������� ���������
				,ISNULL((	SELECT
						ID
					FROM t_SalesDocumentsStates
					INNER JOIN (	SELECT TOP 1
										States.������
									FROM [uas_central].dbo.���������������_����������������������� AS States
									WHERE States.��������������� = DocSales.������
									ORDER BY States._������ DESC) AS ������� ON �������.������ = UID_1C
						), 1) AS StateID														-- ID ������� ���������
			FROM [uas_central].dbo.��������_����������������� AS DocSales				-- ��������.�����������������
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x0000008E
			LEFT JOIN dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.UID_1C = DocSales.������������
			LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = DocSales.������������
			WHERE DocSales.�������� = 0x01		-- ��������
			UNION ALL
			SELECT
				DocRefunds.������ AS UID_1C														-- ID ���������
				,'������� ������� �� ���������� �'+RTRIM(DocRefunds.�����)+' �� '
					+ CONVERT(varchar(10), CAST(DocRefunds.���� AS date), 104) AS Description	-- �������� ���������
				,DocumentsTypes.ID AS DocumentsTypeID											-- ��� ���������
				,CAST(DocRefunds.���� AS date) AS DocDate										-- ���� ���������
				,DocRefunds.����� AS DocNumber													-- ����� ���������
				,ISNULL(SalesDocumentsType.ID, 2) AS SalesDocumentTypeID						-- ID ���� ���������
				,ISNULL(PaymentsType.ID, 1) AS PaymentMethodID									-- ID ������� ������ ���������
				,DocRefunds.���������������� AS IsBonusDoc										-- ������� ��������� ���������
				,5 AS StateID																	-- ID ������� ���������
			FROM [uas_central].dbo.��������_�������������������������� AS DocRefunds	-- ��������.��������������������������
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x00000079
			LEFT JOIN dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.UID_1C = DocRefunds.������������
			LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = DocRefunds.������������
			WHERE DocRefunds.�������� = 0x01	-- ��������
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,DocumentsTypeID = From_1C.DocumentsTypeID
				,DocDate = From_1C.DocDate
				,DocNumber = From_1C.DocNumber
				,SalesDocumentTypeID = From_1C.SalesDocumentTypeID
				,PaymentMethodID = From_1C.PaymentMethodID
				,IsBonusDoc = From_1C.IsBonusDoc
				,StateID = From_1C.StateID
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,DocumentsTypeID
						,DocDate
						,DocNumber
						,SalesDocumentTypeID
						,PaymentMethodID
						,IsBonusDoc
						,StateID)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.DocumentsTypeID
						,From_1C.DocDate
						,From_1C.DocNumber
						,From_1C.SalesDocumentTypeID
						,From_1C.PaymentMethodID
						,From_1C.IsBonusDoc
						,From_1C.StateID);

END
GO