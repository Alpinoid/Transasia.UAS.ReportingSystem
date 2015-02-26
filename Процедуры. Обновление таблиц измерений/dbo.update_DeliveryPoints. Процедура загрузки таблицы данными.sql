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
				Element.������ AS UID_1C																		-- UID ����� ��������
				,Customer.ID AS CustomerID																		-- ID �����������-���������
				,Element.��� AS Code																			-- ���
				,Element.������������ AS Description															-- ������������
				,Element.��� + ': ' + Element.������������ AS CodeDescription									-- ���: ������������
				,Element.������������ + ' (' + Element.��� + ')' AS DescriptionCode								-- ������������ (���)
				,ISNULL(Branch.Description, '��� �������') AS Branch											-- ������
				,ISNULL([uas_central].dbo.get_tt_gold_status(Element.������, GETDATE()), 0) AS GoldStoreType	-- ������ �������� ��������
				,FactAddress.������������� AS FactAddress														-- ����������� �����
				,ISNULL([uas_central].dbo.get_tt_cbd(Element.������, GETDATE()), 0) AS IsKBD					-- ������ ���
				,(	SELECT
						ID
					FROM t_TradeChanels
					INNER JOIN (	SELECT TOP 1
										TradeChanel.ISIS�����
									FROM [uas_central].dbo.���������������_����������������������������������� AS TradeChanel
									WHERE TradeChanel.������������� = Element.������
											AND TradeChanel._������ <= GETDATE()
									ORDER BY TradeChanel._������ DESC) AS ��������� ON ���������.ISIS����� = UID_1C
				) AS TradeChannelID										-- ID ������ ��������
			FROM [uas_central].dbo.����������_������������� AS Element												-- ����������.�������������
			INNER JOIN [uas_central].dbo.����������_����������� AS Customers ON Customers.������ = Element.��������	-- ����������.�����������
														AND Customers.���������� = 1								-- ����������
			LEFT JOIN dbo.t_Branches AS Branch ON Branch.UID_1C = Element.������									-- ����������.�������
			LEFT JOIN dbo.t_Customers AS Customer ON Customer.UID_1C = Element.��������
			LEFT JOIN (	SELECT
							ElementFactAddress.�������� AS ��������
							,ElementFactAddress.������������� AS �������������
						FROM [uas_central].dbo.����������_�������������_�������������������� AS ElementFactAddress																-- ����������.����������_�������������_��������������������
						INNER JOIN [uas_central].dbo.����������_������������������������ AS ElementTypeFactAddress ON ElementTypeFactAddress.������ = ElementFactAddress.���	-- ����������.������������������������
																				AND ElementTypeFactAddress.������������������������� = 0xA8E1D29ACE15A60446FA7B1246B7EF5A		-- ���������� �����
					) AS FactAddress ON FactAddress.�������� = Element.������
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
