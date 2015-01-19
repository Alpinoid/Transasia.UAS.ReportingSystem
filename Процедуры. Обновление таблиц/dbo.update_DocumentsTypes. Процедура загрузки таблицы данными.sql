SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_DocumentsTypes]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_DocumentsTypes]
GO

CREATE PROCEDURE [dbo].[update_DocumentsTypes]
AS
BEGIN

	MERGE INTO [dbo].[t_DocumentsTypes] AS ReportingTable
	USING (	
			SELECT
				0x00000000 AS UID_1C
				,'�����' AS Description
			UNION ALL
			SELECT
				�������������.��������������������_��������� AS UID_1C
				,�������������.������� AS Description				
			FROM [uas_central].dbo.����������_�������������������������������� AS �������������
			INNER JOIN [uas_central].dbo.����������_�������������������������������� AS ����������������������� ON �����������������������.������ = �������������.��������
																												AND �����������������������.������������ = '���������'
			WHERE �������������.��������������� = 0x00
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description)
			VALUES (	From_1C.UID_1C
						,From_1C.Description);

END
GO