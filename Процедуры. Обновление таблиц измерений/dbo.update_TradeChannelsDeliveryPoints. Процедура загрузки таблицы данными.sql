SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TradeChannelsDeliveryPoints]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TradeChannelsDeliveryPoints]
GO

CREATE PROCEDURE [dbo].[update_TradeChannelsDeliveryPoints]
AS
BEGIN

	MERGE INTO dbo.t_TradeChannelsDeliveryPoints AS ReportingTable
		USING (	
			SELECT
				TradeChannels.ID AS TradeChannelID
				,DeliveryPoints.ID AS DeliveryPointID
			FROM dbo.t_TradeChanels AS TradeChannels
			INNER JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.TradeChannelID = TradeChannels.ID
			) AS From_1C
		ON ReportingTable.TradeChannelID = From_1C.TradeChannelID
			AND ReportingTable.DeliveryPointID = From_1C.DeliveryPointID
		WHEN MATCHED THEN
			UPDATE
				SET	TradeChannelID = From_1C.TradeChannelID
					,DeliveryPointID = From_1C.DeliveryPointID
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	TradeChannelID
						,DeliveryPointID)
			VALUES (	From_1C.TradeChannelID
						,From_1C.DeliveryPointID);

END
GO



