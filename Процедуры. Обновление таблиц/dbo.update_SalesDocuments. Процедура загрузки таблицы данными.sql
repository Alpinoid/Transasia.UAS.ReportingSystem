SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_SalesDocuments]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_SalesDocuments]
GO

CREATE PROCEDURE [dbo].[update_SalesDocuments]
AS
BEGIN

	MERGE INTO [dbo].[t_SalesDocuments] AS ReportingTable
	USING (	
			SELECT
				DocSales.Ссылка AS UID_1C														-- ID документа
				,'Реализация товаров №'+RTRIM(DocSales.Номер)+' от '
					+ CONVERT(varchar(10), CAST(DocSales.Дата AS date), 104) AS Description		-- Описание документа
				,CAST(DocSales.Дата AS date) AS DocDate											-- Дата документа
				,DocSales.Номер AS DocNumber													-- Номер документа
				,SalesDocumentsType.ID AS DocumentTypeID										-- ID типа документа
				,PaymentsType.ID AS PaymentMethodID												-- ID способа оплаты документа
				,CAST(ISNULL(DocSales.ДатаФактическойДоставки, 0) AS date) AS DocDeliveryDate	-- Дата доставки																			-- Дата доставки
				,CAST(ISNULL(DocSales.ДатаОплаты, 0)  AS date) AS DocPaymentDay					-- Дата оплаты
				,CONVERT(int, DocSales.БонусныйДокумент) AS IsBonusDoc							-- Признак бонусного документа
			FROM [uas_central].dbo.Документ_РеализацияТоваров AS DocSales						-- Документ.РеализацияТоваров
			LEFT JOIN dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.UID_1C = DocSales.ТипДокумента
			LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = DocSales.СпособОплаты
			WHERE DocSales.Проведен = 0x01						-- Проведен
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,DocDate = From_1C.DocDate
				,DocNumber = From_1C.DocNumber
				,DocumentTypeID = From_1C.DocumentTypeID
				,PaymentMethodID = From_1C.PaymentMethodID
				,DocDeliveryDate = From_1C.DocDeliveryDate
				,DocPaymentDay = From_1C.DocPaymentDay
				,IsBonusDoc = From_1C.IsBonusDoc
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,DocDate
						,DocNumber
						,DocumentTypeID
						,PaymentMethodID
						,DocDeliveryDate
						,DocPaymentDay
						,IsBonusDoc)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.DocDate
						,From_1C.DocNumber
						,From_1C.DocumentTypeID
						,From_1C.PaymentMethodID
						,From_1C.DocDeliveryDate
						,From_1C.DocPaymentDay
						,From_1C.IsBonusDoc);

END
GO