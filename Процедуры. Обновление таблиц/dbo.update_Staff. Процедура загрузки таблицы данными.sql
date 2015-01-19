SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Staff]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Staff]
GO

CREATE PROCEDURE [dbo].[update_Staff]
AS
BEGIN

	MERGE INTO [dbo].[t_Staff] AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C
				,Element.������������ AS Description
			FROM [uas_central].dbo.����������_���������� AS Element	-- ����������.����������
			WHERE Element.��������� = 0x01
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