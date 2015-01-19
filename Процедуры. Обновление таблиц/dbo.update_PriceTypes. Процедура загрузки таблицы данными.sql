SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_PriceTypes]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_PriceTypes]
GO

CREATE PROCEDURE [dbo].[update_PriceTypes]
AS
BEGIN

	MERGE INTO [dbo].[t_PriceTypes] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C
				,Element.Наименование AS Description
				,ISNULL(Bussiness.Description, 'Без направления') AS Business	-- Направление бизнес
			FROM [uas_central].dbo.Справочник_ТипыЦенНоменклатуры AS Element						-- Справочник.ТипыЦенНоменклатуры
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.НаправлениеБизнеса	-- Справочник.НаправленияБизнеса
			WHERE Element.ЭтоГруппа = 0x01
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
