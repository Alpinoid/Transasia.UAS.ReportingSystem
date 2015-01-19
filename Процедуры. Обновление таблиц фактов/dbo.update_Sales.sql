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
			CAST(RegSales._������ AS date) AS TransactionDate	-- ���� ��������
			,Documents.ID AS DocumentID							-- ID ���������
			,SalesDocuments.ID AS SalesDocumentID				-- ID ��������� �������
			,TransactionsType.ID AS TransactionTypeID		-- ID ���� ��������
			,Business.ID AS BusinessID							-- ID ����������� �������
			,Organizations.ID AS CompanyID						-- ID �����������
			,Branches.ID AS BranchID							-- ID �������
			,Storehouses.ID AS StorehouseID						-- ID ������
			,Customers.ID AS CustomerID							-- ID �����������
			,DeliveryPoints.ID AS TardeShopID					-- ID ����� �������� (�������)
			,CreditLines.ID AS CreditLineID						-- ID ���������� �����������
			,Routes_.ID AS RouteID								-- ID �������� (��������� �������������)
			,Staff.ID AS AgentID								-- ID ��������� ������ (����������)
			,PriceTypes.ID AS TypePriceID						-- ID ���� ����
			,(	SELECT
					ID
				FROM t_TradeChanels
				INNER JOIN (	SELECT TOP 1
									TradeChanel.ISIS�����
								FROM [uas_central].dbo.���������������_����������������������������������� AS TradeChanel
								WHERE TradeChanel.������������� = RegSales.�������������
										AND TradeChanel._������ <= RegSales._������
								ORDER BY TradeChanel._������ DESC) AS ��������� ON ���������.ISIS����� = UID_1C
			) AS TradeChanelID									-- ID ������ ��������
			,Goods.ID AS GoodID									-- ID ������������
			,RegSales.���������� AS QuantityBase				-- ���������� � ������� �������� ���������
			,ROUND(RegSales.���������� * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.�����������
														END
													FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
													INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																														AND Class.��� = '796'	-- [��]
													WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
		 										, 0, 1) AS QuantityUnit						-- ���������� � [��]
			,ROUND(RegSales.���������� * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.�����������
														END
													FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit	-- ����������.����������������
													INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																														AND Class.��� = '384'	-- [���]
													WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
												, 0, 1)  AS QuantityBox						-- ���������� � [���]
			,ROUND(RegSales.���������� * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.�����������
														END
													FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit	-- ����������.����������������
													INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																														AND Class.��� = '888'-- [��]
													WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
												, 0, 1)  AS QuantityPack					-- ���������� � [��]
			,ROUND(RegSales.���������� * ISNULL ((
													SELECT TOP 1
														CASE
															WHEN ISNULL(MeasuresUnit.�����������, 0) = 0 THEN 0
															ELSE 1 / MeasuresUnit.�����������
														END
													FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit	-- ����������.����������������
													INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																														AND Class.��� = '384'	-- [���]
													WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
												, 0, 1) * Goods.MSU / 1000 AS QuantityMSU	-- ���������� � [MSU]
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
					, 0) * RegSales.���������� AS Cost						-- ����� �������������
			,ISNULL(	(	SELECT TOP 1
									Price.���� AS InputPrice
							FROM [uas_central].dbo.���������������_���������������� AS Price
							INNER JOIN [uas_central].dbo.����������_������������������� AS PriceType ON PriceType.������ = Price.�������
																							AND PriceType.������������������������� = 0x9688769FCF7C991545B04E324B1591F5
							WHERE Price.������������ = RegSales.������������
								AND Price._������ <= RegSales._������
							ORDER BY Price._������ DESC)
					, 0) * RegSales.���������� AS AmountInInputPrices		-- ����� �� ������� �����
		FROM [uas_central].dbo.�����������������_������� AS RegSales
		INNER JOIN dbo.t_Documents AS Documents ON Documents.UID_1C = RegSales.�����������
		LEFT JOIN dbo.t_SalesDocuments AS SalesDocuments ON SalesDocuments.UID_1C = RegSales.���������������
		LEFT JOIN dbo.t_TransactionsType AS TransactionsType ON TransactionsType.UID_1C = RegSales.���������������������
		LEFT JOIN dbo.t_Business AS Business ON Business.UID_1C = RegSales.������������������
		LEFT JOIN dbo.t_Organizations AS Organizations ON Organizations.UID_1C = RegSales.�����������
		LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = RegSales.������
		LEFT JOIN dbo.t_Storehouses AS Storehouses ON Storehouses.UID_1C = RegSales.�����
		LEFT JOIN dbo.t_Customers AS Customers ON Customers.UID_1C = RegSales.����������
		LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.UID_1C = RegSales.�������������
		LEFT JOIN dbo.t_CreditLines AS CreditLines ON CreditLines.UID_1C = RegSales.��������������������
		LEFT JOIN dbo.t_Routes AS Routes_ ON Routes_.UID_1C = RegSales.�������
		LEFT JOIN dbo.t_Staff AS Staff ON Staff.UID_1C = RegSales.�������������
		LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON PriceTypes.UID_1C = RegSales.�������
		LEFT JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = RegSales.������������
		LEFT JOIN [uas_central].dbo.����������_���������������� AS MeasuresBase ON MeasuresBase.������ = Goods.MeasuresBaseUID_1C AND MeasuresBase.��������������� = 0
		WHERE RegSales.���������� = 0x01
			AND CAST(RegSales._������ AS date) BETWEEN @StartDate AND @EndDate

END
GO
