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
				CAST(ISISTable.DUE_PERD AS int) AS TransactionDateID	-- ���� ��������
				,Documents.ID AS DocumentID								-- ID ���������
				,ROW_NUMBER() OVER (ORDER BY Documents.ID, Goods.ID, ISISTable.NIV) AS DocumentRow						-- ����� ������ ���������
				,SalesDocuments.ID AS SalesDocumentID					-- ID ��������� �������
				,TransactionsType.ID AS TransactionTypeID				-- ID ���� ��������
				,CASE
					WHEN Business.ID <> Teams.BusinessID THEN ISNULL(Teams.BusinessID, Business.ID)
					ELSE Business.ID
				END AS BusinessID										-- ID ����������� �������
				,Organizations.ID AS CompanyID							-- ID �����������
				,Branches.ID AS BranchID								-- ID �������
				,BranchesISIS.ID AS BranchISISID						-- ID ������� �� ISIS
				,pg_filial.filial
				,Storehouses.ID AS StorehouseID							-- ID ������
				,Customers.ID AS CustomerID								-- ID �����������
				,CustomersISIS.ID AS CustomerISISID						-- ID ����������� �� ISIS
				,DeliveryPoints.ID AS TardeShopID						-- ID ����� �������� (�������)
				,DeliveryPointsISIS.ID AS TardeShopISISID				-- ID ����� �������� (�������) �� ISIS
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
									WHERE TradeChanel.������������� = ISISTable._client_id_new
											AND TradeChanel._������ <= CAST(ISISTable.DUE_PERD AS date)
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
																								AND Good.������������ = ISISTable._tovar_id_new
									INNER JOIN (	SELECT TOP 1
														TradeChanel.ISIS�����
													FROM [uas_central].dbo.���������������_����������������������������������� AS TradeChanel
													WHERE TradeChanel.������������� = ISISTable._client_id_new
															AND TradeChanel._������ <= CAST(ISISTable.DUE_PERD AS date)
													ORDER BY TradeChanel._������ DESC
												) AS ��������� ON ���������.ISIS����� = CSKUStates.�����������
									WHERE CSKUStates._������ <= CAST(ISISTable.DUE_PERD AS date)
										AND CSKUStates.������� = 0x01
									ORDER BY CSKUStates._������ DESC
									) AS InitiativesTypes ON InitiativesTypes.InitiativesType = UID_1C

				) AS InitiativesTypeID
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0) AS QuantityBase					-- ���������� � ������� �������� ���������
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									/ Goods.FactorUnit AS QuantityUnit						-- ���������� � [��]
				,ISISTable.Volume AS QuantityBox						-- ���������� � [���]
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									/ Goods.FactorPack AS QuantityPack						-- ���������� � [��]
				,ISISTable.Volume	* Goods.MSU / 1000 AS QuantityMSU							-- ���������� � [MSU]
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									* ISNULL(MeasuresBase.�����, 0) AS Value					-- �����
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									* ISNULL(MeasuresBase.���������, 0) AS WeightGross			-- ��� ������
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									* ISNULL(MeasuresBase.��������, 0) AS WeightNet				-- ��� �����
				,0 AS AmountVAT																	-- ����� ���
				,ISISTable.GIV AS AmountWithoutDiscount											-- ����� ��� ������
				,ISISTable.NIV AS Amount														-- �����
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									* ISNULL ((	
												SELECT TOP 1
													Cost.����� AS Ammount
												FROM [uas_central].dbo.���������������_����� AS Cost
												WHERE Cost.���������� = 0x01
													AND Cost.������������ = ISISTable._tovar_id_new
													AND Cost._������ <= CAST(ISISTable.DUE_PERD AS date)
												ORDER BY Cost._������ DESC)
											, 0) AS AmountInCost								-- ����� �������������
				,ISISTable.Volume	* ISNULL ((
												SELECT TOP 1
													ISNULL(MeasuresUnit.�����������, 0)
												FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
												INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON Class.������ = MeasuresBase.��������������
												WHERE MeasuresUnit.�������� = Goods.UID_1C), 0)
									* ISNULL ((
												SELECT TOP 1
														Price.���� AS InputPrice
												FROM [uas_central].dbo.���������������_���������������� AS Price
												INNER JOIN [uas_central].dbo.����������_������������������� AS PriceType ON PriceType.������ = Price.�������
																												AND PriceType.������������������������� = 0x9688769FCF7C991545B04E324B1591F5
												WHERE Price.������������ = ISISTable._tovar_id_new
													AND Price._������ <= CAST(ISISTable.DUE_PERD AS date)
												ORDER BY Price._������ DESC)
											, 0) AS AmountInInputPrices							-- ����� �� ������� �����
			FROM [pg_reports].dbo.isis_work_table AS ISISTable
			INNER JOIN dbo.t_Documents AS Documents ON Documents.UID_1C = ISISTable._iddoc
			LEFT JOIN dbo.t_SalesDocuments AS SalesDocuments ON SalesDocuments.UID_1C = ISISTable._rashod_iddoc
			LEFT JOIN [uas_central].dbo.��������_����������������� AS SalesDoc_1C ON SalesDoc_1C.������ = ISISTable._rashod_iddoc
			LEFT JOIN dbo.t_TransactionsType AS TransactionsType ON TransactionsType.UID_1C = IIF(ISISTable.Volume >= 0, 0xAFFBA27C585D82A441142E9FD4A14101, 0xAC3B38E4640B29B34E8A850E3E15B6D4)
			LEFT JOIN dbo.t_Routes AS Routes_ ON Routes_.ID = SalesDocuments.RouteID
			LEFT JOIN dbo.t_Teams AS Teams ON Teams.ID = Routes_.TeamID
			LEFT JOIN dbo.t_Staff AS Staff ON Staff.ID = SalesDocuments.StaffID
			LEFT JOIN dbo.t_PriceTypes AS PriceTypes ON PriceTypes.ID = SalesDocuments.PriceTypeID
			LEFT JOIN dbo.t_Business AS Business ON Business.UID_1C = SalesDoc_1C.������������������
			LEFT JOIN dbo.t_Organizations AS Organizations ON Organizations.UID_1C = SalesDoc_1C.�����������
			LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = SalesDoc_1C.������
			LEFT JOIN [pg_reports].dbo.pg_filial_codes AS pg_filial ON pg_filial.pg_code = ISISTable.DIST_ID
			LEFT JOIN dbo.t_Branches AS BranchesISIS ON BranchesISIS.UID_1C = pg_filial.UID_1C
			LEFT JOIN dbo.t_Storehouses AS Storehouses ON Storehouses.UID_1C = SalesDoc_1C.�����
			LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPoints ON DeliveryPoints.UID_1C = SalesDoc_1C.�������������
			LEFT JOIN dbo.t_Customers AS Customers ON Customers.UID_1C = SalesDoc_1C.����������
			LEFT JOIN dbo.t_DeliveryPoints AS DeliveryPointsISIS ON DeliveryPointsISIS.UID_1C = ISISTable._client_id_new
			LEFT JOIN dbo.t_Customers AS CustomersISIS ON CustomersISIS.UID_1C = (SELECT TOP 1 �������� FROM [uas_central].dbo.����������_������������� WHERE ������ = ISISTable._client_id_new)
			LEFT JOIN dbo.t_CreditLines AS CreditLines ON CreditLines.UID_1C = SalesDoc_1C.��������������������
			LEFT JOIN dbo.t_Goods AS Goods ON Goods.UID_1C = ISISTable._tovar_id_new
			LEFT JOIN [uas_central].dbo.����������_���������������� AS MeasuresBase ON MeasuresBase.������ = Goods.MeasuresBaseUID_1C AND MeasuresBase.��������������� = 0
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
