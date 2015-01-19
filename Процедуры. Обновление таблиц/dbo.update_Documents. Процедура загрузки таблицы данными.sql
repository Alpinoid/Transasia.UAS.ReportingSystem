SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Documents]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Documents]
GO

CREATE PROCEDURE [dbo].[update_Documents]
AS
BEGIN

	MERGE INTO [dbo].[t_Documents] AS ReportingTable
	USING (	
			SELECT
				DocSales.Ссылка AS UID_1C														-- ID документа
				,'Реализация товаров №'+RTRIM(DocSales.Номер)+' от '
					+ CONVERT(varchar(10), CAST(DocSales.Дата AS date), 104) AS Description		-- Описание документа
				,DocumentsTypes.ID AS DocumentsType												-- Тип документа
				,CAST(DocSales.Дата AS date) AS DocDate											-- Дата документа
				,DocSales.Номер AS DocNumber													-- Номер документа
			FROM [uas_central].dbo.Документ_РеализацияТоваров AS DocSales				-- Документ.РеализацияТоваров
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x0000008E
			WHERE DocSales.Проведен = 0x01		-- Проведен
			UNION ALL
			SELECT
				DocRefunds.Ссылка AS UID_1C														-- ID документа
				,'Возврат товаров от покупателя №'+RTRIM(DocRefunds.Номер)+' от '
					+ CONVERT(varchar(10), CAST(DocRefunds.Дата AS date), 104) AS Description	-- Описание документа
				,DocumentsTypes.ID AS DocumentsType										-- Тип документа
				,CAST(DocRefunds.Дата AS date) AS DocDate										-- Дата документа
				,DocRefunds.Номер AS DocNumber													-- Номер документа
			FROM [uas_central].dbo.Документ_ВозвратТоваровОтПокупателя AS DocRefunds	-- Документ.ВозвратТоваровОтПокупателя
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x00000079
			WHERE DocRefunds.Проведен = 0x01	-- Проведен
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,DocumentsType = From_1C.DocumentsType
				,DocDate = From_1C.DocDate
				,DocNumber = From_1C.DocNumber
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,DocumentsType
						,DocDate
						,DocNumber)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.DocumentsType
						,From_1C.DocDate
						,From_1C.DocNumber);

END
GO