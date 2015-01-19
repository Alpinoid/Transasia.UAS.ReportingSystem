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

	DELETE
		FROM dbo.t_Sales
		WHERE TransactionDate BETWEEN @StartDate AND @EndDate

	INSERT INTO dbo.t_Sales
			(TransactionDate
			,DocumentID
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
		SELECT
			CAST(RegSales._Период AS date) AS TransactionDate	-- Дата операции
			,Documents.ID AS DocumentID							-- ID документа
			,SalesDocuments.ID AS SalesDocumentID				-- ID документа продажи
			,TransactionsType.ID AS TransactionTypeID		-- ID типа операции
			,Business.ID AS BusinessID							-- ID направления бизнеса
			,Organizations.ID AS CompanyID						-- ID организации
			,Branches.ID AS BranchID							-- ID филиала
			,Storehouses.ID AS StorehouseID						-- ID склада
			,Customers.ID AS CustomerID							-- ID контрагента
			,DeliveryPoints.ID AS TardeShopID					-- ID точки доставки (продажи)
			,CreditLines.ID AS CreditLineID						-- ID кредитного направления
			,Routes_.ID AS RouteID								-- ID марушрта (торгового представителя)
			,Staff.ID AS AgentID								-- ID торгового агента (сотрудника)
			,PriceTypes.ID AS TypePriceID						-- ID типа цены
			,(	SELECT
					ID
				FROM t_TradeChanels
				INNER JOIN (	SELECT TOP 1
									TradeChanel.ISISКанал
								FROM [uas_central].dbo.РегистрСведений_ПериодическиеРеквизитыТочекДоставки AS TradeChanel
								WHERE TradeChanel.ТочкаДоставки = RegSales.ТочкаДоставки
										AND TradeChanel._Период <= RegSales._Период
								ORDER BY TradeChanel._Период DESC) AS Реквизиты ON Реквизиты.ISISКанал = UID_1C
			) AS TradeChanelID									-- ID канала торговли
			,Goods.ID AS GoodID									-- ID номенклатуры
			,RegSales.Количество AS QuantityBase				-- Количество в базовых единицах измерения
			,ROUND(RegSales.Количество * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.Коэффициент
														END
													FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
													INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																														AND Class.Код = '796'	-- [шт]
													WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
		 										, 0, 1) AS QuantityUnit						-- Количество в [шт]
			,ROUND(RegSales.Количество * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.Коэффициент
														END
													FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit	-- Справочник.ЕдиницыИзмерения
													INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																														AND Class.Код = '384'	-- [кор]
													WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
												, 0, 1)  AS QuantityBox						-- Количество в [кор]
			,ROUND(RegSales.Количество * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.Коэффициент
														END
													FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit	-- Справочник.ЕдиницыИзмерения
													INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																														AND Class.Код = '888'-- [уп]
													WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
												, 0, 1)  AS QuantityPack					-- Количество в [уп]
			,ROUND(RegSales.Количество * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.Коэффициент, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.Коэффициент
														END
													FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit	-- Справочник.ЕдиницыИзмерения
													INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																														AND Class.Код = '384'	-- [кор]
													WHERE MeasuresUnit.Владелец = Goods.UID_1C), 0)
												, 0, 1) * Goods.MSU / 1000 AS QuantityMSU	-- Количество в [MSU]
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
					, 0) * RegSales.Количество AS Cost						-- Сумма себестоимости
			,ISNULL(	(	SELECT TOP 1
									Price.Цена AS InputPrice
							FROM [uas_central].dbo.РегистрСведений_ЦеныНоменклатуры AS Price
							INNER JOIN [uas_central].dbo.Справочник_ТипыЦенНоменклатуры AS PriceType ON PriceType.Ссылка = Price.ТипЦены
																							AND PriceType.ИмяПредопределенныхДанных = 0x9688769FCF7C991545B04E324B1591F5
							WHERE Price.Номенклатура = RegSales.Номенклатура
								AND Price._Период <= RegSales._Период
							ORDER BY Price._Период DESC)
					, 0) * RegSales.Количество AS AmountInInputPrices		-- Сумма во входных ценах
		FROM [uas_central].dbo.РегистрНакопления_Продажи AS RegSales
		INNER JOIN dbo.t_Documents AS Documents ON Documents.UID_1C = RegSales.Регистратор
		LEFT JOIN dbo.t_SalesDocuments AS SalesDocuments ON SalesDocuments.UID_1C = RegSales.ДокументПродажи
		LEFT JOIN dbo.t_TransactionsType AS TransactionsType ON TransactionsType.UID_1C = RegSales.ХозяйственнаяОперация
		LEFT JOIN dbo.t_Business AS Business ON Business.UID_1C = RegSales.НаправлениеБизнеса
		LEFT JOIN dbo.t_Organizations AS Organizations ON Organizations.UID_1C = RegSales.Организация
		LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = RegSales.Филиал
		LEFT JOIN dbo.t_Storehouses AS Storehouses ON Storehouses.UID_1C = RegSales.Склад
		LEFT JOIN dbo.t_Customers AS Customers ON Customers.UID_1C = RegSales.Контрагент
		LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.UID_1C = RegSales.ТочкаДоставки
		LEFT JOIN dbo.t_CreditLines AS CreditLines ON CreditLines.UID_1C = RegSales.КредитноеНаправление
		LEFT JOIN dbo.t_Routes AS Routes_ ON Routes_.UID_1C = RegSales.Маршрут
		LEFT JOIN dbo.t_Staff AS Staff ON Staff.UID_1C = RegSales.ТорговыйАгент
		LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON PriceTypes.UID_1C = RegSales.ТипЦены
		LEFT JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = RegSales.Номенклатура
		LEFT JOIN [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresBase ON MeasuresBase.Ссылка = Goods.MeasuresBaseUID_1C AND MeasuresBase.ПометкаУдаления = 0
		WHERE RegSales.Активность = 0x01
			AND CAST(RegSales._Период AS date) BETWEEN @StartDate AND @EndDate

END
GO
