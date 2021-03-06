SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_AllDimensionTables]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_AllDimensionTables]
GO

CREATE PROCEDURE [dbo].[update_AllDimensionTables]
AS
BEGIN

	EXEC dbo.update_Calendar
	EXEC dbo.update_Reports
	EXEC.dbo.update_ReportsTypes
	EXEC dbo.update_TypesOfDebt
	EXEC dbo.update_TypesOfDelay
	EXEC dbo.update_Business
	EXEC dbo.update_Branches
	EXEC dbo.update_Organizations
	EXEC dbo.update_Staff
	EXEC dbo.update_TradeChanels
	EXEC dbo.update_CustomersTypes
	EXEC dbo.update_Customers
	EXEC dbo.update_TypesOfGoldStore
	EXEC dbo.update_DeliveryPoints
	EXEC dbo.update_SystemsMobileTrade
	EXEC dbo.update_Teams
	EXEC dbo.update_Routes
	EXEC dbo.update_CreditLines
	EXEC dbo.update_Storehouses
	EXEC dbo.update_PriceTypes
	EXEC dbo.update_TransactionsType
	EXEC dbo.update_SalesDocumentsType
	EXEC dbo.update_SalesDocumentsStates
	EXEC dbo.update_PaymentsType
	EXEC dbo.update_DocumentsTypes
	EXEC dbo.update_SalesDocuments
	EXEC dbo.update_Documents
	EXEC dbo.update_CSKU
	EXEC dbo.update_Brands
	EXEC dbo.update_Goods
	EXEC dbo.update_InitiativesTypes
	EXEC dbo.update_Vendors
	EXEC dbo.update_MarketingPrograms
	EXEC dbo.update_InitiativesTradeChannelsGoods
	EXEC dbo.update_TradeChannelsDeliveryPoints
	EXEC dbo.update_PeriodsOfTPR
	EXEC dbo.update_CSKUPeriodsOfTPR

END
GO
