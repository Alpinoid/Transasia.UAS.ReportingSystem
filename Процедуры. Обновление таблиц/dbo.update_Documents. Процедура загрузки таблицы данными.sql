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
				,DocumentsTypes.ID AS DocumentsType												-- ��� ���������
				,CAST(DocSales.���� AS date) AS DocDate											-- ���� ���������
				,DocSales.����� AS DocNumber													-- ����� ���������
			FROM [uas_central].dbo.��������_����������������� AS DocSales				-- ��������.�����������������
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x0000008E
			WHERE DocSales.�������� = 0x01		-- ��������
			UNION ALL
			SELECT
				DocRefunds.������ AS UID_1C														-- ID ���������
				,'������� ������� �� ���������� �'+RTRIM(DocRefunds.�����)+' �� '
					+ CONVERT(varchar(10), CAST(DocRefunds.���� AS date), 104) AS Description	-- �������� ���������
				,DocumentsTypes.ID AS DocumentsType										-- ��� ���������
				,CAST(DocRefunds.���� AS date) AS DocDate										-- ���� ���������
				,DocRefunds.����� AS DocNumber													-- ����� ���������
			FROM [uas_central].dbo.��������_�������������������������� AS DocRefunds	-- ��������.��������������������������
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x00000079
			WHERE DocRefunds.�������� = 0x01	-- ��������
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,DocumentsType = From_1C.DocumentsType
				,DocDate = From_1C.DocDate
				,DocNumber = From_1C.DocNumber
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,DocumentsType
						,DocDate
						,DocNumber)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.DocumentsType
						,From_1C.DocDate
						,From_1C.DocNumber);

END
GO