SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_DeliveryPoints]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_DeliveryPoints]
GO

CREATE PROCEDURE [dbo].[update_DeliveryPoints]
AS
BEGIN

	MERGE INTO [dbo].[t_DeliveryPoints] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C																		-- UID точки доставки
				,Customer.ID AS CustomerID																		-- ID контрагента-владельца
				,Element.Код AS Code																			-- Код
				,Element.Наименование AS Description															-- Наименование
				,Element.Код + ': ' + Element.Наименование AS CodeDescription									-- Код: Наименование
				,Element.Наименование + ' (' + Element.Код + ')' AS DescriptionCode								-- Наименовнаие (Код)
				,ISNULL(Branch.Description, 'Без филиала') AS Branch											-- Филиал
				,ISNULL([uas_central].dbo.get_tt_gold_status(Element.Ссылка, GETDATE()), 0) AS GoldStoreType	-- Статус Золотого магазина
				,FactAddress.Представление AS FactAddress														-- Фактический адрес
				,ISNULL([uas_central].dbo.get_tt_cbd(Element.Ссылка, GETDATE()), 0) AS IsKBD					-- Статус КБД
				,(	SELECT
						ID
					FROM t_TradeChanels
					INNER JOIN (	SELECT TOP 1
										TradeChanel.ISISКанал
									FROM [uas_central].dbo.РегистрСведений_ПериодическиеРеквизитыТочекДоставки AS TradeChanel
									WHERE TradeChanel.ТочкаДоставки = Element.Ссылка
											AND TradeChanel._Период <= GETDATE()
									ORDER BY TradeChanel._Период DESC) AS Реквизиты ON Реквизиты.ISISКанал = UID_1C
				) AS TradeChannelID										-- ID канала торговли
			FROM [uas_central].dbo.Справочник_ТочкиДоставки AS Element												-- Справочник.ТочкиДоставки
			INNER JOIN [uas_central].dbo.Справочник_Контрагенты AS Customers ON Customers.Ссылка = Element.Владелец	-- Справочник.Контрагенты
														AND Customers.Покупатель = 1								-- Покупатель
			LEFT JOIN dbo.t_Branches AS Branch ON Branch.UID_1C = Element.Филиал									-- Справочник.Филиалы
			LEFT JOIN dbo.t_Customers AS Customer ON Customer.UID_1C = Element.Владелец
			LEFT JOIN (	SELECT
							ElementFactAddress.Владелец AS Владелец
							,ElementFactAddress.Представление AS Представление
						FROM [uas_central].dbo.Справочник_ТочкиДоставки_КонтактнаяИнформация AS ElementFactAddress																-- Справочник.Справочник_ТочкиДоставки_КонтактнаяИнформация
						INNER JOIN [uas_central].dbo.Справочник_ВидыКонтактнойИнформации AS ElementTypeFactAddress ON ElementTypeFactAddress.Ссылка = ElementFactAddress.Вид	-- Справочник.ВидыКонтактнойИнформации
																				AND ElementTypeFactAddress.ИмяПредопределенныхДанных = 0xA8E1D29ACE15A60446FA7B1246B7EF5A		-- Фактически адрес
					) AS FactAddress ON FactAddress.Владелец = Element.Ссылка
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	CustomerID = From_1C.CustomerID
				,Code = From_1C.Code
				,Description = From_1C.Description
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
				,Branch = From_1C.Branch
				,GoldStoreType = From_1C.GoldStoreType
				,FactAddress = From_1C.FactAddress
				,IsKBD = From_1C.IsKBD
				,TradeChannelID = From_1C.TradeChannelID
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,CustomerID
						,Code
						,Description
						,CodeDescription
						,DescriptionCode
						,Branch
						,GoldStoreType
						,FactAddress
						,IsKBD
						,TradeChannelID)
			VALUES (	From_1C.UID_1C
						,From_1C.CustomerID
						,From_1C.Code
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.Branch
						,From_1C.GoldStoreType
						,From_1C.FactAddress
						,From_1C.IsKBD
						,From_1C.TradeChannelID);

END
GO
