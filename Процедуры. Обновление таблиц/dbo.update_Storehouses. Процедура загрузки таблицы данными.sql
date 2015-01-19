SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Storehouses]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Storehouses]
GO

CREATE PROCEDURE [dbo].[update_Storehouses]
AS
BEGIN

	MERGE INTO [dbo].[t_Storehouses] AS ReportingTable
	USING (	
			SELECT
				Ссылка AS UID_1C
				,Наименование AS Description
				,ISNULL(Branches.Description, 'Без филиала') AS Branch	-- Филиал
			FROM [uas_central].dbo.Справочник_Склады AS Element							-- Справочник.Склады
			LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = Element.Филиал	-- Справочник.Филиалы
			WHERE Element.ЭтоГруппа = 0x01
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,Branch = From_1C.Branch
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,Branch)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.Branch);

END
GO