SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TypesOfDebt]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TypesOfDebt]
GO

CREATE PROCEDURE [dbo].[update_TypesOfDebt]
AS
BEGIN

	MERGE INTO [dbo].[t_TypesOfDebt] AS ReportingTable
	USING (	
			SELECT
				1 AS ID
				,'Аванс' AS ТипДолга
			UNION ALL
			SELECT
				2 AS ID
				,'Просрочено' AS ТипДолга
			UNION ALL
			SELECT
				3 AS ID
				,'Не просрочено' AS ТипДолга
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	ТипДолга = From_1C.ТипДолга
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,ТипДолга)
			VALUES (	From_1C.ID
						,From_1C.ТипДолга);

END
GO
