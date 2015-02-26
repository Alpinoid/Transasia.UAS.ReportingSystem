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
				CAST(RegSales._������ AS date) AS TransactionDate		-- ���� ��������
				,Documents.ID AS DocumentID								-- ID ���������
				,RegSales.����������� AS DocumentRow					-- ����� ������ ���������
				,SalesDocuments.ID AS SalesDocumentID					-- ID ��������� �������
				,TransactionsType.ID AS TransactionTypeID				-- ID ���� ��������
				,CASE
					WHEN Business.ID <> Teams.BusinessID THEN ISNULL(Teams.BusinessID, Business.ID)
					ELSE Business.ID
				END AS BusinessID										-- ID ����������� �������
				,Organizations.ID AS CompanyID							-- ID �����������
				,Branches.ID AS BranchID								-- ID �������
				,Storehouses.ID AS StorehouseID							-- ID ������
				,Customers.ID AS CustomerID								-- ID �����������
				,DeliveryPoints.ID AS TardeShopID						-- ID ����� �������� (�������)
				,CreditLines.ID AS CreditLineID							-- ID ���������� �����������
				,Routes_.ID AS RouteID									-- ID �������� (��������� �������������)
				,Staff.ID AS AgentID									-- ID ��������� ������ (����������)
				,PriceTypes.ID AS TypePriceID							-- ID ���� ����
				,(	SELECT
						ID
					FROM t_TradeChanels
					INNER JOIN (	SELECT TOP 1
										TradeChanel.ISIS�����
									FROM [uas_central].dbo.���������������_����������������������������������� AS TradeChanel
									WHERE TradeChanel.������������� = RegSales.�������������
											AND TradeChanel._������ <= RegSales._������
									ORDER BY TradeChanel._������ DESC) AS ��������� ON ���������.ISIS����� = UID_1C
				) AS TradeChanelID										-- ID ������ ��������
				,Goods.ID AS GoodID										-- ID ������������
				,(	SELECT
						ID
					FROM t_InitiativesTypes
					INNER JOIN (	SELECT TOP 1
										CSKUStates.������������� AS InitiativesType
									FROM [uas_central].dbo.���������������_������������������������ AS CSKUStates
									INNER JOIN [uas_central].dbo.���������������_����CSKU AS Good ON Good.CSKU = CSKUStates.CSKU
																								AND Good.������������ = RegSales.������������
									INNER JOIN (	SELECT TOP 1
														TradeChanel.ISIS�����
													FROM [uas_central].dbo.���������������_����������������������������������� AS TradeChanel
													WHERE TradeChanel.������������� = RegSales.�������������
															AND TradeChanel._������ <= RegSales._������
													ORDER BY TradeChanel._������ DESC
												) AS ��������� ON ���������.ISIS����� = CSKUStates.�����������
									WHERE CSKUStates._������ <= RegSales._������
										AND CSKUStates.������� = 0x01
									ORDER BY CSKUStates._������ DESC
									) AS InitiativesTypes ON InitiativesTypes.InitiativesType = UID_1C

				) AS InitiativesTypeID
				,RegSales.���������� AS QuantityBase					-- ���������� � ������� �������� ���������
				,RegSales.���������� * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.�����������
													END
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																													AND Class.��� = '796'	-- [��]
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0) AS QuantityUnit						-- ���������� � [��]
				,RegSales.���������� * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.�����������
													END
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit	-- ����������.����������������
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																													AND Class.��� = '384'	-- [���]
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0) AS QuantityBox						-- ���������� � [���]
				,RegSales.���������� * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.�����������
													END
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit	-- ����������.����������������
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																													AND Class.��� = '888'-- [��]
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0) AS QuantityPack						-- ���������� � [��]
				,RegSales.���������� * ISNULL ((
												SELECT TOP 1
													CASE
														WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
														ELSE 1 / MeasuresUnit.�����������
													END
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit	-- ����������.����������������
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																													AND Class.��� = '384'	-- [���]
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0) * Goods.MSU / 1000 AS QuantityMSU	-- ���������� � [MSU]
				,ISNULL(MeasuresBase.�����, 0) * RegSales.���������� AS Value					-- �����
				,ISNULL(MeasuresBase.���������, 0) * RegSales.���������� AS WeightGross			-- ��� ������
				,ISNULL(MeasuresBase.��������, 0) * RegSales.���������� AS WeightNet			-- ��� ������
				,RegSales.�������� AS AmountVAT													-- ����� ���
				,RegSales.�������������� AS AmountWithoutDiscount								-- ����� ��� ������
				,RegSales.����� AS Amount														-- �����
				,ISNULL(	(	SELECT TOP 1
									Cost.����� AS Ammount
								FROM [uas_central].dbo.���������������_����� AS Cost
								WHERE Cost.���������� = 0x01
									AND Cost.������������ = RegSales.������������
									AND Cost._������ <= RegSales._������
								ORDER BY Cost._������ DESC)
						, 0) * RegSales.���������� AS AmountInCost						-- ����� �������������
				,ISNULL(	(	SELECT TOP 1
										Price.���� AS InputPrice
								FROM [uas_central].dbo.���������������_���������������� AS Price
								INNER JOIN [uas_central].dbo.����������_������������������� AS PriceType ON PriceType.������ = Price.�������
																								AND PriceType.������������������������� = 0x9688769FCF7C991545B04E324B1591F5
								WHERE Price.������������ = RegSales.������������
									AND Price._������ <= RegSales._������
								ORDER BY Price._������ DESC)
						, 0) * RegSales.���������� AS AmountInInputPrices				-- ����� �� ������� �����
			FROM [uas_central].dbo.�����������������_������� AS RegSales
			INNER JOIN dbo.t_Documents AS Documents ON Documents.UID_1C = RegSales.�����������
			LEFT JOIN dbo.t_SalesDocuments AS SalesDocuments ON SalesDocuments.UID_1C = RegSales.���������������_������
			LEFT JOIN dbo.t_TransactionsType AS TransactionsType ON TransactionsType.UID_1C = RegSales.���������������������
			LEFT JOIN dbo.t_Routes AS Routes_ ON (Routes_.UID_1C = RegSales.������� AND ISNULL(RegSales.�������, 0x00) <> 0x00)
												OR (Routes_.ID = SalesDocuments.RouteID AND ISNULL(RegSales.�������, 0x00) = 0x00)
			LEFT JOIN dbo.t_Teams AS Teams ON Teams.ID = Routes_.TeamID
			LEFT JOIN dbo.t_Staff AS Staff ON (Staff.UID_1C = RegSales.������������� AND ISNULL(RegSales.�������������, 0x00) <> 0x00)
											OR (Staff.ID = SalesDocuments.StaffID AND ISNULL(RegSales.�������������, 0x00) = 0x00)
			LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON (PriceTypes.UID_1C = RegSales.������� AND ISNULL(RegSales.�������, 0x00) <> 0x00)
													OR (PriceTypes.ID = SalesDocuments.PriceTypeID AND ISNULL(RegSales.�������, 0x00) = 0x00)
			LEFT JOIN dbo.t_Business AS Business ON Business.UID_1C = RegSales.������������������
			LEFT JOIN dbo.t_Organizations AS Organizations ON Organizations.UID_1C = RegSales.�����������
			LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = RegSales.������
			LEFT JOIN dbo.t_Storehouses AS Storehouses ON Storehouses.UID_1C = RegSales.�����
			LEFT JOIN dbo.t_Customers AS Customers ON Customers.UID_1C = RegSales.����������
			LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.UID_1C = RegSales.�������������
			LEFT JOIN dbo.t_CreditLines AS CreditLines ON CreditLines.UID_1C = RegSales.��������������������
			LEFT JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = RegSales.������������
			LEFT JOIN [uas_central].dbo.����������_���������������� AS MeasuresBase ON MeasuresBase.������ = Goods.MeasuresBaseUID_1C AND MeasuresBase.��������������� = 0
			WHERE RegSales.���������� = 0x01
				AND CAST(RegSales._������ AS date) BETWEEN @StartDate AND @EndDate
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
