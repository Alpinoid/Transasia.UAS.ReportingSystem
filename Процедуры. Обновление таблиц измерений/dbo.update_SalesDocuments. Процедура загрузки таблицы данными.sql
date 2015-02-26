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
				,CAST(ISNULL(DocSales.ДатаФактическойДоставки, 0) AS date) AS DocDeliveryDate	-- Дата доставки
				,CAST(ISNULL(DocSales.ДатаОплаты, 0)  AS date) AS DocPaymentDay					-- Дата оплаты
				,CONVERT(int, DocSales.БонусныйДокумент) AS IsBonusDoc							-- Признак бонусного документа
				,Routes_.ID AS RouteID															-- ID маршрута
				,Staff.ID AS StaffID															-- ID торгового агента
				,PriceTypes.ID AS PriceTypeID													-- ID типа цены
			FROM [uas_central].dbo.Документ_РеализацияТоваров AS DocSales						-- Документ.РеализацияТоваров
			LEFT JOIN dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.UID_1C = DocSales.ТипДокумента
			LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = DocSales.СпособОплаты
			LEFT JOIN dbo.t_Routes AS Routes_ ON Routes_.UID_1C = DocSales.Маршрут
			LEFT JOIN dbo.t_Staff AS Staff ON Staff.UID_1C = DocSales.ТорговыйАгент
			LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON PriceTypes.UID_1C = DocSales.ТипЦены
			WHERE DocSales.Проведен = 0x01						-- Проведен
			UNION ALL
			SELECT
				DocSales.Ссылка AS UID_1C																		-- ID документа
				,ISNULL(DocSales.ВидДокумента, 'Ввод начальных остатков взаиморасчета')
					+' №'+RTRIM(ISNULL(DocSales.НомерИсходногоДокумента, DocSales.Номер))+' от '
					+ CONVERT(varchar(10), CAST(ISNULL(DocSales.ДатаИсходногоДокумента, DocSales.Дата) AS date), 104) AS Description	-- Описание документа
				,CAST(ISNULL(DocSales.ДатаИсходногоДокумента, DocSales.Дата) AS date) AS DocDate				-- Дата документа
				,ISNULL(DocSales.НомерИсходногоДокумента, DocSales.Номер) AS DocNumber							-- Номер документа
				,SalesDocumentsType.ID AS DocumentTypeID														-- ID типа документа
				,PaymentsType.ID AS PaymentMethodID																-- ID способа оплаты документа
				,CAST(ISNULL(DocSales.ДатаИсходногоДокумента, DocSales.Дата) AS date) AS DocDeliveryDate		-- Дата доставки
				,CAST(ISNULL(DocSales.ДатаОплаты, 0)  AS date) AS DocPaymentDay									-- Дата оплаты
				,CONVERT(int, DocSales.БонусныйДокумент) AS IsBonusDoc											-- Признак бонусного документа
				,NULL AS RouteID																				-- ID маршрута
				,NULL AS StaffID																				-- ID торгового агента
				,NULL AS StaPriceTypeID																			-- ID типа цены
			FROM [uas_central].dbo.Документ_ВводНачальныхОстатковВзаиморасчета AS DocSales		-- Документ.ВводНачальныхОстатковВзаиморасчета
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
				,RouteID = From_1C.RouteID
				,StaffID = From_1C.StaffID
				,PriceTypeID = From_1C.PriceTypeID
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
						,IsBonusDoc
						,RouteID
						,StaffID
						,PriceTypeID)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.DocDate
						,From_1C.DocNumber
						,From_1C.DocumentTypeID
						,From_1C.PaymentMethodID
						,From_1C.DocDeliveryDate
						,From_1C.DocPaymentDay
						,From_1C.IsBonusDoc
						,From_1C.RouteID
						,From_1C.StaffID
						,From_1C.PriceTypeID);

END
GO