SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TradeChanels]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TradeChanels]
GO

CREATE PROCEDURE [dbo].[update_TradeChanels]
AS
BEGIN

	MERGE INTO [dbo].[t_TradeChanels] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C
				,Element.Наименование AS Description
				,CASE
					WHEN SUM(1) OVER (PARTITION BY Parent.Наименование) <=1 THEN Element.Наименование
					ELSE Parent.Наименование
				END AS ParentDescription
				
				,Element.РегламентноеНаименование AS OfficialDescription
				,Element.КодISIS AS CodeISIS
				,Element.КБД AS IsKBD
			FROM [uas_central].dbo.Справочник_КаналыПродаж AS Element											-- Справочник.КаналыПродаж
			LEFT JOIN [uas_central].dbo.Справочник_КаналыПродаж AS Parent ON Parent.Ссылка = Element.Родитель	-- Справочник.КаналыПродаж (родитель)
										OR (Parent.Ссылка = Element.Ссылка AND Element.Родитель = 0)
			WHERE Element.Родитель <> 0x00  AND Element.ПометкаУдаления = 0x00
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,ParentDescription = From_1C.ParentDescription
				,OfficialDescription = From_1C.OfficialDescription
				,CodeISIS = From_1C.CodeISIS
				,IsKBD = From_1C.IsKBD
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,ParentDescription
						,Description
						,OfficialDescription
						,CodeISIS
						,IsKBD)
			VALUES (	From_1C.UID_1C
						,From_1C.ParentDescription
						,From_1C.Description
						,From_1C.OfficialDescription
						,From_1C.CodeISIS
						,From_1C.IsKBD);

END
GO
