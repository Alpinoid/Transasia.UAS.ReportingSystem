SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_InitiativesTradeChannelsGoods]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_InitiativesTradeChannelsGoods]
GO

CREATE PROCEDURE [dbo].[update_InitiativesTradeChannelsGoods]
AS
BEGIN

	MERGE INTO dbo.t_InitiativesTradeChannelsGoods AS ReportingTable
		USING (	
			SELECT
				InitiativesTypes.ID AS InitiativeID
				,TradeChannels.ID AS TradeChannelID
				,Goods.ID AS GoodID
			FROM (
					SELECT
						CSKUStates.CSKU AS CSKU
						,CSKUStates.ВидИнициативы AS InitiativesType
						,CSKUStates.КаналПродаж AS TradeChannel
					FROM [uas_central].dbo.РегистрСведений_СтатусыКодовДистрибьюции AS CSKUStates
					INNER JOIN (	SELECT
										CSKUStates.CSKU AS CSKU
										,CSKUStates.ВидИнициативы AS InitiativesType
										,CSKUStates.КаналПродаж AS TradeChannel
										,MAX(CSKUStates._Период) AS Period
									FROM [uas_central].dbo.РегистрСведений_СтатусыКодовДистрибьюции AS CSKUStates				
									WHERE CSKUStates._Период <= GETDATE()
									GROUP BY CSKUStates.CSKU, CSKUStates.ВидИнициативы, CSKUStates.КаналПродаж
								) AS MaxCSKUStates ON MaxCSKUStates.CSKU = CSKUStates.CSKU
													AND MaxCSKUStates.InitiativesType = CSKUStates.ВидИнициативы
													AND MaxCSKUStates.TradeChannel = CSKUStates.КаналПродаж
													AND MaxCSKUStates.Period = CSKUStates._Период
					WHERE CSKUStates.Активна = 0x01
					UNION
					SELECT
						Initiatives.SKU AS CSKU
						,Initiatives.ВидИнициативы AS InitiativesType
						,Initiatives.КаналПродаж AS TradeChannel
					FROM [uas_central].dbo.РегистрСведений_ИнициативыPG AS Initiatives
					WHERE GETDATE() BETWEEN Initiatives.ДатаНачала AND Initiatives.ДатаОкончания
						AND Initiatives.Активность =  0x01
				) AS Initiatives
			INNER JOIN [uas_central].dbo.РегистрСведений_КодыCSKU AS Номенклатура ON Номенклатура.CSKU = Initiatives.CSKU
			INNER JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = Номенклатура.Номенклатура
			INNER JOIN dbo.t_InitiativesTypes AS InitiativesTypes ON InitiativesTypes.UID_1C = Initiatives.InitiativesType
			INNER JOIN dbo.t_TradeChanels AS TradeChannels ON TradeChannels.UID_1C = Initiatives.TradeChannel
			) AS From_1C
		ON ReportingTable.InitiativeID = From_1C.InitiativeID
			AND ReportingTable.TradeChannelID = From_1C.TradeChannelID
			AND ReportingTable.GoodID = From_1C.GoodID
		WHEN MATCHED THEN
			UPDATE
			SET	InitiativeID = From_1C.InitiativeID
				,TradeChannelID = From_1C.TradeChannelID
				,GoodID = From_1C.GoodID
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	InitiativeID
						,TradeChannelID
						,GoodID)
			VALUES (	From_1C.InitiativeID
						,From_1C.TradeChannelID
						,From_1C.GoodID);

END
GO



