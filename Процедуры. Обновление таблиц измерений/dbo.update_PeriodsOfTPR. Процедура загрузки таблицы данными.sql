SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_PeriodsOfTPR]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_PeriodsOfTPR]
GO

CREATE PROCEDURE [dbo].[update_PeriodsOfTPR]
AS
BEGIN

	MERGE INTO [dbo].[t_PeriodsOfTPR] AS ReportingTable
	USING (	
			SELECT 
				'TPR: ' + CONVERT(varchar(10), ДатаНачала, 104) + ' - ' + CONVERT(varchar(10), ДатаОкончания, 104) AS Description
				,ДатаНачала AS StartDate
				,ДатаОкончания AS EndDate
			FROM [uas_central].dbo.Справочник_БонусыАкции
			WHERE ТипАкции = (SELECT Значение FROM [uas_central].dbo.Перечисление_БонусТипАкции WHERE Имя = 'Промо_1')
			GROUP BY ДатаНачала, ДатаОкончания
			) AS From_1C
	ON ReportingTable.StartDate = From_1C.StartDate AND ReportingTable.EndDate = From_1C.EndDate
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,StartDate = From_1C.StartDate
				,EndDate = From_1C.EndDate
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	Description
						,StartDate
						,EndDate)
			VALUES (	From_1C.Description
						,From_1C.StartDate
						,From_1C.EndDate);

END
GO