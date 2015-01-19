SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TypesOfDelay]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TypesOfDelay]
GO

CREATE PROCEDURE [dbo].[update_TypesOfDelay]
AS
BEGIN

	MERGE INTO [dbo].[t_TypesOfDelay] AS ReportingTable
	USING (	
			SELECT
				1 AS ID
				,'Аванс' AS ВидПросрочки
				,0 AS MinDay
				,0 AS MaxDay
			UNION ALL
			SELECT
				2 AS ID
				,'Не просрочено' AS ВидПросрочки
				,0 AS MinDay
				,0 AS MaxDay
			UNION ALL
			SELECT
				3 AS ID
				,'До 3 дней' AS ВидПросрочки
				,0 AS MinDay
				,3 AS MaxDay
			UNION ALL
			SELECT
				4 AS ID
				,'От 4 до 10 дней' AS ВидПросрочки
				,4 AS MinDay
				,10 AS MaxDay
			UNION ALL
			SELECT
				5 AS ID
				,'От 11 до 25 дней' AS ВидПросрочки
				,11 AS MinDay
				,25 AS MaxDay
			UNION ALL
			SELECT
				6 AS ID
				,'Более 25 дней' AS ВидПросрочки
				,26 AS MinDay
				,99999 AS MaxDay
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	ВидПросрочки = From_1C.ВидПросрочки
				,MinDay = From_1C.MinDay
				,MaxDay = From_1C.MaxDay
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,ВидПросрочки
						,MinDay
						,MaxDay)
			VALUES (	From_1C.ID
						,From_1C.ВидПросрочки
						,From_1C.MinDay
						,From_1C.MaxDay);

END
GO

