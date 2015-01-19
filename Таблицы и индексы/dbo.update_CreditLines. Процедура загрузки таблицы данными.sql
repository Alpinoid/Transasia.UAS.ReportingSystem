SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CreditLines]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CreditLines]
GO

CREATE PROCEDURE [dbo].[update_CreditLines]
AS
BEGIN

	MERGE INTO [dbo].[t_CreditLines] AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C
				,Element.������������ AS Description
				,ISNULL(Bussiness.Description, '��� �����������') AS Business	-- ����������� �������
			FROM [uas_central].dbo.����������_�������������������� AS Element	-- ����������.��������������������
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.������������������
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,Business = From_1C.Business
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,Business)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.Business);

END
GO

