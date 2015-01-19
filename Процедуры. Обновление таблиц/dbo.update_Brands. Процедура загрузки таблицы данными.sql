SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Brands]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Brands]
GO

CREATE PROCEDURE [dbo].[update_Brands]
AS
BEGIN

	MERGE INTO [dbo].[t_Brands] AS ReportingTable
	USING (	
			SELECT
				Ссылка AS UID_1C
				,Наименование AS Description
			FROM [uas_central].dbo.Справочник_Бренды		-- Справочник.Бренды
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