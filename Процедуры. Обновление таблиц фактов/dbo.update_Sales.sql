SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Sales]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Sales]
GO

CREATE PROCEDURE [dbo].[update_Sales]
	@StartDate date,
	@EndDate date
AS
BEGIN

	MERGE INTO dbo.t_Sales AS ReportingTable
	USING (	
			SELECT
				CAST(RegSales._Период AS date) AS TransactionDate		-- Дата операции
				,Documents.ID AS DocumentID								-- ID документа
				,RegSales.НомерСтроки AS DocumentRow					-- Номер строки документа
				,SalesDocuments.ID AS SalesDocumentID					-- ID документа продажи
				,TransactionsType.ID AS TransactionTypeID				-- ID типа операции
				,CASE
					WHEN Business.ID <> Teams.BusinessID THEN ISNULL(Teams.BusinessID, Business.ID)
					ELSE Business.ID
				END AS BusinessID										-- ID направления бизнеса
				,Organizations.ID AS CompanyID							-- ID организации
				,Branches.ID AS BranchID								-- ID филиала
				,Storehouses.ID AS StorehouseID							-- ID склада
				,Customers.ID AS CustomerID								-- ID контрагента
				,DeliveryPoints.ID AS TardeShopID						-- ID точки доставки (продажи)
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
									WHERE TradeChanel.ТочкаДоставки = RegSales.ТочкаДоставки
											AND TradeChanel._Период <= RegSales._Период
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
																								AND Good.Номенклатура = RegSales.Номенклатура
									INNER JOIN (	SELECT TOP 1
														TradeChanel.ISISКанал
													FROM [uas_central].dbo.РегистрСведений_ПериодическиеРеквизитыТочекДоставки AS TradeChanel
													WHERE TradeChanel.ТочкаДоставки = RegSales.ТочкаДоставки
															AND TradeChanel._Период <= RegSales._Период
													ORDER BY TradeChanel._Период DESC
												) AS Реквизиты ON Реквизиты.ISISКанал = CSKUStates.КаналПродаж
									WHERE CSKUStates._Период <= RegSales._Период
										AND CSKUStates.Активна = 0x01
									ORDER BY CSKUStates._Период DESC
									) AS InitiativesTypes ON InitiativesTypes.InitiativesType = UID_1C

				) AS InitiativesTypeID
				,RegSales.Количество AS QuantityBase					-- Количество в базовых единицах измерения
				,RegSales.Количество * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.Коэффициент
													END
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																													AND Class.Код = '796'	-- [шт]
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0) AS QuantityUnit						-- Количество в [шт]
				,RegSales.Количество * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.Коэффициент
													END
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit	-- Справочник.ЕдиницыИзмерения
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																													AND Class.Код = '384'	-- [кор]
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0) AS QuantityBox						-- Количество в [кор]
				,RegSales.Количество * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.Коэффициент
													END
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit	-- Справочник.ЕдиницыИзмерения
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																													AND Class.Код = '888'-- [уп]
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0) AS QuantityPack						-- Количество в [уп]
				,RegSales.Количество * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.Коэффициент
													END
												FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit	-- Справочник.ЕдиницыИзмерения
												INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																													AND Class.Код = '384'	-- [кор]
												WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0) * Goods.MSU / 1000 AS QuantityMSU	-- Количество в [MSU]
				,ISNULL(MeasuresBase.Объем, 0) * RegSales.Количество AS Value					-- Объем
				,ISNULL(MeasuresBase.ВесБрутто, 0) * RegSales.Количество AS WeightGross			-- Вес брутто
				,ISNULL(MeasuresBase.ВесНетто, 0) * RegSales.Количество AS WeightNet			-- Вес брутто
				,RegSales.СуммаНДС AS AmountVAT													-- Сумма НДС
				,RegSales.СуммаБезСкидки AS AmountWithoutDiscount								-- Сумма без скидки
				,RegSales.Сумма AS Amount														-- Сумма
				,ISNULL(	(	SELECT TOP 1
									Cost.Сумма AS Ammount
								FROM [uas_central].dbo.РегистрСведений_Срезы AS Cost
								WHERE Cost.Активность = 0x01
									AND Cost.Номенклатура = RegSales.Номенклатура
									AND Cost._Период <= RegSales._Период
								ORDER BY Cost._Период DESC)
						, 0) * RegSales.Количество AS AmountInCost						-- Сумма себестоимости
				,ISNULL(	(	SELECT TOP 1
										Price.Цена AS InputPrice
								FROM [uas_central].dbo.РегистрСведений_ЦеныНоменклатуры AS Price
								INNER JOIN [uas_central].dbo.Справочник_ТипыЦенНоменклатуры AS PriceType ON PriceType.Ссылка = Price.ТипЦены
																								AND PriceType.ИмяПредопределенныхДанных = 0x9688769FCF7C991545B04E324B1591F5
								WHERE Price.Номенклатура = RegSales.Номенклатура
									AND Price._Период <= RegSales._Период
								ORDER BY Price._Период DESC)
						, 0) * RegSales.Количество AS AmountInInputPrices				-- Сумма во входных ценах
			FROM [uas_central].dbo.РегистрНакопления_Продажи AS RegSales
			INNER JOIN dbo.t_Documents AS Documents ON Documents.UID_1C = RegSales.Регистратор
			LEFT JOIN dbo.t_SalesDocuments AS SalesDocuments ON SalesDocuments.UID_1C = RegSales.ДокументПродажи_Ссылка
			LEFT JOIN dbo.t_TransactionsType AS TransactionsType ON TransactionsType.UID_1C = RegSales.ХозяйственнаяОперация
			LEFT JOIN dbo.t_Routes AS Routes_ ON (Routes_.UID_1C = RegSales.Маршрут AND ISNULL(RegSales.Маршрут, 0x00) <> 0x00)
												OR (Routes_.ID = SalesDocuments.RouteID AND ISNULL(RegSales.Маршрут, 0x00) = 0x00)
			LEFT JOIN dbo.t_Teams AS Teams ON Teams.ID = Routes_.TeamID
			LEFT JOIN dbo.t_Staff AS Staff ON (Staff.UID_1C = RegSales.ТорговыйАгент AND ISNULL(RegSales.ТорговыйАгент, 0x00) <> 0x00)
											OR (Staff.ID = SalesDocuments.StaffID AND ISNULL(RegSales.ТорговыйАгент, 0x00) = 0x00)
			LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON (PriceTypes.UID_1C = RegSales.ТипЦены AND ISNULL(RegSales.ТипЦены, 0x00) <> 0x00)
													OR (PriceTypes.ID = SalesDocuments.PriceTypeID AND ISNULL(RegSales.ТипЦены, 0x00) = 0x00)
			LEFT JOIN dbo.t_Business AS Business ON Business.UID_1C = RegSales.НаправлениеБизнеса
			LEFT JOIN dbo.t_Organizations AS Organizations ON Organizations.UID_1C = RegSales.Организация
			LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = RegSales.Филиал
			LEFT JOIN dbo.t_Storehouses AS Storehouses ON Storehouses.UID_1C = RegSales.Склад
			LEFT JOIN dbo.t_Customers AS Customers ON Customers.UID_1C = RegSales.Контрагент
			LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.UID_1C = RegSales.ТочкаДоставки
			LEFT JOIN dbo.t_CreditLines AS CreditLines ON CreditLines.UID_1C = RegSales.КредитноеНаправление
			LEFT JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = RegSales.Номенклатура
			LEFT JOIN [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresBase ON MeasuresBase.Ссылка = Goods.MeasuresBaseUID_1C AND MeasuresBase.ПометкаУдаления = 0
			WHERE RegSales.Активность = 0x01
				AND CAST(RegSales._Период AS date) BETWEEN @StartDate AND @EndDate
			) AS From_1C
	ON ReportingTable.DocumentID = From_1C.DocumentID AND ReportingTable.DocumentRow = From_1C.DocumentRow
		WHEN MATCHED THEN
			UPDATE
			SET	TransactionDate = From_1C.TransactionDate
				,SalesDocumentID = From_1C.SalesDocumentID
				,TransactionTypeID = From_1C.TransactionTypeID
				,BusinessID = From_1C.BusinessID
				,CompanyID = From_1C.CompanyID
				,BranchID = From_1C.BranchID
				,StorehouseID = From_1C.StorehouseID
				,CustomerID = From_1C.CustomerID
				,TardeShopID = From_1C.TardeShopID
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
		WHEN NOT MATCHED BY SOURCE AND ReportingTable.TransactionDate BETWEEN @StartDate AND @EndDate THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	TransactionDate
						,DocumentID
						,DocumentRow
						,SalesDocumentID
						,TransactionTypeID
						,BusinessID
						,CompanyID
						,BranchID
						,StorehouseID
						,CustomerID
						,TardeShopID
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
			VALUES (	From_1C.TransactionDate
						,From_1C.DocumentID
						,From_1C.DocumentRow
						,From_1C.SalesDocumentID
						,From_1C.TransactionTypeID
						,From_1C.BusinessID
						,From_1C.CompanyID
						,From_1C.BranchID
						,From_1C.StorehouseID
						,From_1C.CustomerID
						,From_1C.TardeShopID
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
