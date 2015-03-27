SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CSKUPeriodsOfTPR]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CSKUPeriodsOfTPR]
GO

CREATE PROCEDURE [dbo].[update_CSKUPeriodsOfTPR]
AS
BEGIN

	MERGE INTO [dbo].[t_CSKUPeriodsOfTPR] AS ReportingTable
	USING (	
			SELECT 
				CSKU.ID AS CSKUID
				,PeriodsOfTPR.ID AS PeriodsOfTPRID
			FROM [uas_central].dbo.Справочник_БонусыАкции AS Акции
			INNER JOIN dbo.t_PeriodsOfTPR AS PeriodsOfTPR ON PeriodsOfTPR.StartDate = Акции.ДатаНачала AND  PeriodsOfTPR.EndDate = Акции.ДатаОкончания
			LEFT JOIN [uas_central].dbo.Справочник_БонусыАкции_ЧтоНужноКупить AS ЧтоНужноКупить ON ЧтоНужноКупить.Владелец = Акции.Ссылка
			LEFT JOIN [uas_central].dbo.Справочник_БонусыНаборы_БонусыЭлементыНабора AS БонусыЭлементыНабора ON БонусыЭлементыНабора.Владелец = ЧтоНужноКупить.Набор
			INNER JOIN dbo.t_CSKU AS CSKU ON CSKU.UID_1C = БонусыЭлементыНабора.SKU
			WHERE Акции.ТипАкции = (SELECT Значение FROM [uas_central].dbo.Перечисление_БонусТипАкции WHERE Имя = 'Промо_1')
			GROUP BY PeriodsOfTPR.ID, CSKU.ID
			) AS From_1C
	ON ReportingTable.CSKUID = From_1C.CSKUID AND ReportingTable.PeriodsOfTPRID = From_1C.PeriodsOfTPRID
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	CSKUID
						,PeriodsOfTPRID)
			VALUES (	From_1C.CSKUID
						,From_1C.PeriodsOfTPRID);

END
GO