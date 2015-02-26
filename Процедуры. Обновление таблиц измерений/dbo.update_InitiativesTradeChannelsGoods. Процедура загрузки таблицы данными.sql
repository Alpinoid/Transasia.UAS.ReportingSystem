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
						,CSKUStates.������������� AS InitiativesType
						,CSKUStates.����������� AS TradeChannel
					FROM [uas_central].dbo.���������������_������������������������ AS CSKUStates
					INNER JOIN (	SELECT
										CSKUStates.CSKU AS CSKU
										,CSKUStates.������������� AS InitiativesType
										,CSKUStates.����������� AS TradeChannel
										,MAX(CSKUStates._������) AS Period
									FROM [uas_central].dbo.���������������_������������������������ AS CSKUStates				
									WHERE CSKUStates._������ <= GETDATE()
									GROUP BY CSKUStates.CSKU, CSKUStates.�������������, CSKUStates.�����������
								) AS MaxCSKUStates ON MaxCSKUStates.CSKU = CSKUStates.CSKU
													AND MaxCSKUStates.InitiativesType = CSKUStates.�������������
													AND MaxCSKUStates.TradeChannel = CSKUStates.�����������
													AND MaxCSKUStates.Period = CSKUStates._������
					WHERE CSKUStates.������� = 0x01
					UNION
					SELECT
						Initiatives.SKU AS CSKU
						,Initiatives.������������� AS InitiativesType
						,Initiatives.����������� AS TradeChannel
					FROM [uas_central].dbo.���������������_����������PG AS Initiatives
					WHERE GETDATE() BETWEEN Initiatives.���������� AND Initiatives.�������������
						AND Initiatives.���������� =  0x01
				) AS Initiatives
			INNER JOIN [uas_central].dbo.���������������_����CSKU AS ������������ ON ������������.CSKU = Initiatives.CSKU
			INNER JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = ������������.������������
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



