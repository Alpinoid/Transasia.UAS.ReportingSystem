SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TypesOfGoldStore]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TypesOfGoldStore]
GO

CREATE PROCEDURE [dbo].[update_TypesOfGoldStore]
AS
BEGIN
	
	SET IDENTITY_INSERT dbo.t_TypesOfGoldStore ON

	MERGE INTO [dbo].[t_TypesOfGoldStore] AS ReportingTable
	USING (	
			SELECT
				0 AS ID
				,'Без статуса' AS Description
			UNION ALL
			SELECT
				1 AS ID
				,'Золотой магазин' AS Description
			UNION ALL
			SELECT
				2 AS ID
				,'Золотой магазин Лайт' AS Description
			UNION ALL
			SELECT
				3 AS ID
				,'Инновационный Золотой магазин' AS Description
			UNION ALL
			SELECT
				4 AS ID
				,'Изумрудная аптека' AS Description
			UNION ALL
			SELECT
				5 AS ID
				,'Золотой киоск' AS Description
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,Description)
			VALUES (	From_1C.ID
						,From_1C.Description);

END
GO

