SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_SalesISIS]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_SalesISIS]
GO

CREATE PROCEDURE [dbo].[update_SalesISIS]
	@StartDate date,
	@EndDate date
AS
BEGIN

	MERGE INTO dbo.t_SalesISIS AS ReportingTable
		USING (	
			SELECT
				CAST(ISISTable.DUE_PERD AS int) AS TransactionDateID	-- Дата операции
				,Documents.ID AS DocumentID								-- ID документа
				,ROW_NUMBER() OVER (ORDER BY Documents.ID, Goods.ID, ISISTable.NIV) AS DocumentRow						-- Номер строки документа
				,SalesDocuments.ID AS SalesDocumentID					-- ID документа продажи
				,TransactionsType.ID AS TransactionTypeID				-- ID типа операции
				,CASE
					WHEN Business.ID <> Teams.BusinessID THEN ISNULL(Teams.BusinessID, Business.ID)
					ELSE Business.ID
				END AS BusinessID										-- ID направления бизнеса
				,Organizations.ID AS CompanyID							-- ID организации
				,Branches.ID AS BranchID								-- ID филиала
				,BranchesISIS.ID AS BranchISISID						-- ID филиала по ISIS
				,pg_filial.filial
				,Storehouses.ID AS StorehouseID							-- ID склада
				,Customers.ID AS CustomerID								-- ID контрагента
				,CustomersISIS.ID AS CustomerISISID						-- ID контрагента по ISIS
				,DeliveryPoints.ID AS TardeShopID						-- ID точки доставки (продажи)
				,DeliveryPointsISIS.ID AS TardeShopISISID				-- ID точки доставки (продажи) по ISIS
				,CreditLines.ID AS CreditLineID							-- ID кредитного направления
				,Routes_.ID AS RouteID									-- ID марушрта (торгового представителя)
				,Staff.ID AS AgentID									-- ID торгового агента (сотрудника)
				,PriceTypes.ID AS TypePriceID							-- ID типа цены
				,(	SELECT
						ID
					FROM t_TradeChanels
					INNER JOIN (	SELECT TOP 1
										TradeChanel.ISISКанал
									FROM [uas_central].dbo.РегистрСведений_ПериодическиеРеквизитыТочекДоставки AS TradeChanel
									WHERE TradeChanel.ТочкаДоставки = ISISTable._client_id_new
											AND TradeChanel._Период <= CAST(ISISTable.DUE_PERD AS date)
									ORDER BY TradeChanel._Период DESC) AS Реквизиты ON Реквизиты.ISISКанал = UID_1C
				) AS TradeChanelID										-- ID канала торговли
				,Goods.ID AS GoodID										-- ID номенклатуры
				,(	SELECT
						ID
					FROM t_InitiativesTypes
					INNER JOIN (	SELECT TOP 1
										CSKUStates.ВидИнициативы AS InitiativesType
									FROM [uas_central].dbo.РегистрСведений_СтатусыКодовДистрибьюции AS CSKUStates
									INNER JOIN [uas_central].dbo.РегистрСведений_КодыCSKU AS Good ON Good.CSKU = CSKUStates.CSKU
																								AND Good.Номенклатура = ISISTable._tovar_id_new
									INNER JOIN (	SELECT TOP 1
														TradeChanel.ISISКанал
													FROM [uas_central].dbo.РегистрСведений_ПериодическиеРеквизитыТочекДоставки AS TradeChanel
													WHERE TradeChanel.ТочкаДоставки = ISISTable._client_id_new
															AND TradeChanel._Период <= CAST(ISISTable.DUE_PERD AS date)
													ORDER BY TradeChanel._Период DESC
												) AS Реквизиты ON Реквизиты.ISISКанал = CSKUStates.КаналПродаж
									WHERE CSKUStates._Период <= CAST(ISISTable.DUE_PERD AS date)
										AND CSKUStates.Активна = 0x01
									ORDER BY CSKUStates._Период DESC
									) AS InitiativesTypes ON InitiativesTypes.InitiativesType = UID_1C

				) AS InitiativesTypeID
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0) AS QuantityBase					-- Количество в базовых единицах измерения
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									/ Goods.FactorUnit AS QuantityUnit						-- Количество в [шт]
				,ISISTable.Volume AS QuantityBox						-- Количество в [кор]
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									/ Goods.FactorPack AS QuantityPack						-- Количество в [уп]
				,ISISTable.Volume	* Goods.MSU / 1000 AS QuantityMSU							-- Количество в [MSU]
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									* ISNULL(MeasuresBase.Объем, 0) AS Value					-- Объем
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									* ISNULL(MeasuresBase.ВесБрутто, 0) AS WeightGross			-- Вес брутто
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									* ISNULL(MeasuresBase.ВесНетто, 0) AS WeightNet				-- Вес нетто
				,0 AS AmountVAT																	-- Сумма НДС
				,ISISTable.GIV AS AmountWithoutDiscount											-- Сумма без скидки
				,ISISTable.NIV AS Amount														-- Сумма
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									* ISNULL ((	
												SELECT TOP 1
													Cost.Сумма AS Ammount
												FROM [uas_central].dbo.РегистрСведений_Срезы AS Cost
												WHERE Cost.Активность = 0x01
													AND Cost.Номенклатура = ISISTable._tovar_id_new
													AND Cost._Период <= CAST(ISISTable.DUE_PERD AS date)
												ORDER BY Cost._Период DESC)
											, 0) AS AmountInCost								-- Сумма себестоимости
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.Коэффициент, 0)
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON Class.Ссылка = MeasuresBase.БазоваяЕдиница
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
									* ISNULL ((
												SELECT TOP 1
														Price.Цена AS InputPrice
												FROM [uas_central].dbo.РегистрСведений_ЦеныНоменклатуры AS Price
												INNER JOIN [uas_central].dbo.Справочник_ТипыЦенНоменклатуры AS PriceType ON PriceType.Ссылка = Price.ТипЦены
																												AND PriceType.ИмяПредопределенныхДанных = 0x9688769FCF7C991545B04E324B1591F5
												WHERE Price.Номенклатура = ISISTable._tovar_id_new
													AND Price._Период <= CAST(ISISTable.DUE_PERD AS date)
												ORDER BY Price._Период DESC)
											, 0) AS AmountInInputPrices							-- Сумма во входных ценах
			FROM [pg_reports].dbo.isis_work_table AS ISISTable
			INNER JOIN dbo.t_Documents AS Documents ON Documents.UID_1C = ISISTable._iddoc
			LEFT JOIN dbo.t_SalesDocuments AS SalesDocuments ON SalesDocuments.UID_1C = ISISTable._rashod_iddoc
			LEFT JOIN [uas_central].dbo.Документ_РеализацияТоваров AS SalesDoc_1C ON SalesDoc_1C.Ссылка = ISISTable._rashod_iddoc
			LEFT JOIN dbo.t_TransactionsType AS TransactionsType ON TransactionsType.UID_1C = IIF(ISISTable.Volume >= 0, 0xAFFBA27C585D82A441142E9FD4A14101, 0xAC3B38E4640B29B34E8A850E3E15B6D4)
			LEFT JOIN dbo.t_Routes AS Routes_ ON Routes_.ID = SalesDocuments.RouteID
			LEFT JOIN dbo.t_Teams AS Teams ON Teams.ID = Routes_.TeamID
			LEFT JOIN dbo.t_Staff AS Staff ON Staff.ID = SalesDocuments.StaffID
			LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON PriceTypes.ID = SalesDocuments.PriceTypeID
			LEFT JOIN dbo.t_Business AS Business ON Business.UID_1C = SalesDoc_1C.НаправлениеБизнеса
			LEFT JOIN dbo.t_Organizations AS Organizations ON Organizations.UID_1C = SalesDoc_1C.Организация
			LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = SalesDoc_1C.Филиал
			LEFT JOIN [pg_reports].dbo.pg_filial_codes AS pg_filial ON pg_filial.pg_code = ISISTable.DIST_ID
			LEFT JOIN dbo.t_Branches AS BranchesISIS ON BranchesISIS.UID_1C = pg_filial.UID_1C
			LEFT JOIN dbo.t_Storehouses AS Storehouses ON Storehouses.UID_1C = SalesDoc_1C.Склад
			LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.UID_1C = SalesDoc_1C.ТочкаДоставки
			LEFT JOIN dbo.t_Customers AS Customers ON Customers.UID_1C = SalesDoc_1C.Контрагент
			LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPointsISIS ON DeliveryPointsISIS.UID_1C = ISISTable._client_id_new
			LEFT JOIN dbo.t_Customers AS CustomersISIS ON CustomersISIS.UID_1C = (SELECT TOP 1 Владелец FROM [uas_central].dbo.Справочник_ТочкиДоставки WHERE Ссылка = ISISTable._client_id_new)
			LEFT JOIN dbo.t_CreditLines AS CreditLines ON CreditLines.UID_1C = SalesDoc_1C.КредитноеНаправление
			LEFT JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = ISISTable._tovar_id_new
			LEFT JOIN [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresBase ON MeasuresBase.Ссылка = Goods.MeasuresBaseUID_1C AND MeasuresBase.ПометкаУдаления = 0
			WHERE CAST(ISISTable.DUE_PERD AS date) BETWEEN @StartDate AND @EndDate
			) AS From_1C
	ON ReportingTable.DocumentID = From_1C.DocumentID AND ReportingTable.DocumentRow = From_1C.DocumentRow
		WHEN MATCHED THEN
			UPDATE
			SET	TransactionDateID = From_1C.TransactionDateID
				,SalesDocumentID = From_1C.SalesDocumentID
				,TransactionTypeID = From_1C.TransactionTypeID
				,BusinessID = From_1C.BusinessID
				,CompanyID = From_1C.CompanyID
				,BranchID = From_1C.BranchID
				,BranchISISID = From_1C.BranchISISID
				,StorehouseID = From_1C.StorehouseID
				,CustomerID = From_1C.CustomerID
				,CustomerISISID = From_1C.CustomerISISID
				,TardeShopID = From_1C.TardeShopID
				,TardeShopISISID = From_1C.TardeShopISISID
				,CreditLineID = From_1C.CreditLineID
				,RouteID = From_1C.RouteID
				,AgentID = From_1C.AgentID
				,TypePriceID = From_1C.TypePriceID
				,TradeChanelID = From_1C.TradeChanelID
				,GoodID = From_1C.GoodID
				,InitiativesTypeID = From_1C.InitiativesTypeID
				,QuantityBase = From_1C.QuantityBase
				,QuantityUnit = From_1C.QuantityUnit
				,QuantityBox = From_1C.QuantityBox
				,QuantityPack = From_1C.QuantityPack
				,QuantityMSU = From_1C.QuantityMSU
				,Value = From_1C.Value
				,WeightGross = From_1C.WeightGross
				,WeightNet = From_1C.WeightNet
				,AmountVAT = From_1C.AmountVAT
				,AmountWithoutDiscount = From_1C.AmountWithoutDiscount
				,Amount = From_1C.Amount
				,AmountInCost = From_1C.AmountInCost
				,AmountInInputPrices = From_1C.AmountInInputPrices
		WHEN NOT MATCHED BY SOURCE AND (ReportingTable.TransactionDateID >= CAST(CONVERT(varchar(8), @StartDate ,112) AS int)
										AND ReportingTable.TransactionDateID <= CAST(CONVERT(varchar(8), @EndDate ,112) AS int)) THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	TransactionDateID
						,DocumentID
						,DocumentRow
						,SalesDocumentID
						,TransactionTypeID
						,BusinessID
						,CompanyID
						,BranchID
						,BranchISISID
						,StorehouseID
						,CustomerID
						,CustomerISISID
						,TardeShopID
						,TardeShopISISID
						,CreditLineID
						,RouteID
						,AgentID
						,TypePriceID
						,TradeChanelID
						,GoodID
						,InitiativesTypeID
						,QuantityBase
						,QuantityUnit
						,QuantityBox
						,QuantityPack
						,QuantityMSU
						,Value
						,WeightGross
						,WeightNet
						,AmountVAT
						,AmountWithoutDiscount
						,Amount
						,AmountInCost
						,AmountInInputPrices)
			VALUES (	From_1C.TransactionDateID
						,From_1C.DocumentID
						,From_1C.DocumentRow
						,From_1C.SalesDocumentID
						,From_1C.TransactionTypeID
						,From_1C.BusinessID
						,From_1C.CompanyID
						,From_1C.BranchID
						,From_1C.BranchISISID
						,From_1C.StorehouseID
						,From_1C.CustomerID
						,From_1C.CustomerISISID
						,From_1C.TardeShopID
						,From_1C.TardeShopISISID
						,From_1C.CreditLineID
						,From_1C.RouteID
						,From_1C.AgentID
						,From_1C.TypePriceID
						,From_1C.TradeChanelID
						,From_1C.GoodID
						,From_1C.InitiativesTypeID
						,From_1C.QuantityBase
						,From_1C.QuantityUnit
						,From_1C.QuantityBox
						,From_1C.QuantityPack
						,From_1C.QuantityMSU
						,From_1C.Value
						,From_1C.WeightGross
						,From_1C.WeightNet
						,From_1C.AmountVAT
						,From_1C.AmountWithoutDiscount
						,From_1C.Amount
						,From_1C.AmountInCost
						,From_1C.AmountInInputPrices);

END

GO
