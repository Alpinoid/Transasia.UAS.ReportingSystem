SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_DocumentsTypes]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_DocumentsTypes]
GO

CREATE PROCEDURE [dbo].[update_DocumentsTypes]
AS
BEGIN

	MERGE INTO [dbo].[t_DocumentsTypes] AS ReportingTable
	USING (	
			SELECT
				0x00000000 AS UID_1C
				,'Аванс' AS Description
			UNION ALL
			SELECT
				Идентификатор.ЗначениеПустойСсылки_ВидСсылки AS UID_1C
				,Идентификатор.Синоним AS Description				
			FROM [uas_central].dbo.Справочник_ИдентификаторыОбъектовМетаданных AS Идентификатор
			INNER JOIN [uas_central].dbo.Справочник_ИдентификаторыОбъектовМетаданных AS ИдентификаторДокументов ON ИдентификаторДокументов.Ссылка = Идентификатор.Родитель
																												AND ИдентификаторДокументов.Наименование = 'Документы'
			WHERE Идентификатор.ПометкаУдаления = 0x00
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