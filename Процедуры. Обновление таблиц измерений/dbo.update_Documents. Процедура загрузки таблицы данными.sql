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
				,DocumentsTypes.ID AS DocumentsTypeID											-- Тип документа
				,CAST(DocSales.Дата AS date) AS DocDate											-- Дата документа
				,DocSales.Номер AS DocNumber													-- Номер документа
				,ISNULL(SalesDocumentsType.ID, 2) AS SalesDocumentTypeID						-- ID типа документа
				,ISNULL(PaymentsType.ID, 1) AS PaymentMethodID									-- ID способа оплаты документа
				,DocSales.БонусныйДокумент AS IsBonusDoc										-- Признак бонусного документа
				,ISNULL((	SELECT
						ID
					FROM t_SalesDocumentsStates
					INNER JOIN (	SELECT TOP 1
										States.Статус
									FROM [uas_central].dbo.РегистрСведений_СтатусыДокументаПродажи AS States
									WHERE States.ДокументПродажи = DocSales.Ссылка
									ORDER BY States._Период DESC) AS Статусы ON Статусы.Статус = UID_1C
						), 1) AS StateID														-- ID статуса документа
			FROM [uas_central].dbo.Документ_РеализацияТоваров AS DocSales				-- Документ.РеализацияТоваров
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x0000008E
			LEFT JOIN dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.UID_1C = DocSales.ТипДокумента
			LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = DocSales.СпособОплаты
			WHERE DocSales.Проведен = 0x01		-- Проведен
			UNION ALL
			SELECT
				DocRefunds.Ссылка AS UID_1C														-- ID документа
				,'Возврат товаров от покупателя №'+RTRIM(DocRefunds.Номер)+' от '
					+ CONVERT(varchar(10), CAST(DocRefunds.Дата AS date), 104) AS Description	-- Описание документа
				,DocumentsTypes.ID AS DocumentsTypeID											-- Тип документа
				,CAST(DocRefunds.Дата AS date) AS DocDate										-- Дата документа
				,DocRefunds.Номер AS DocNumber													-- Номер документа
				,ISNULL(SalesDocumentsType.ID, 2) AS SalesDocumentTypeID						-- ID типа документа
				,ISNULL(PaymentsType.ID, 1) AS PaymentMethodID									-- ID способа оплаты документа
				,DocRefunds.БонусныйДокумент AS IsBonusDoc										-- Признак бонусного документа
				,5 AS StateID																	-- ID статуса документа
			FROM [uas_central].dbo.Документ_ВозвратТоваровОтПокупателя AS DocRefunds	-- Документ.ВозвратТоваровОтПокупателя
			INNER JOIN dbo.t_DocumentsTypes AS DocumentsTypes ON DocumentsTypes.UID_1C = 0x00000079
			LEFT JOIN dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.UID_1C = DocRefunds.ТипДокумента
			LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = DocRefunds.СпособОплаты
			WHERE DocRefunds.Проведен = 0x01	-- Проведен
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,DocumentsTypeID = From_1C.DocumentsTypeID
				,DocDate = From_1C.DocDate
				,DocNumber = From_1C.DocNumber
				,SalesDocumentTypeID = From_1C.SalesDocumentTypeID
				,PaymentMethodID = From_1C.PaymentMethodID
				,IsBonusDoc = From_1C.IsBonusDoc
				,StateID = From_1C.StateID
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,DocumentsTypeID
						,DocDate
						,DocNumber
						,SalesDocumentTypeID
						,PaymentMethodID
						,IsBonusDoc
						,StateID)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.DocumentsTypeID
						,From_1C.DocDate
						,From_1C.DocNumber
						,From_1C.SalesDocumentTypeID
						,From_1C.PaymentMethodID
						,From_1C.IsBonusDoc
						,From_1C.StateID);

END
GO