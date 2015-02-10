SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[t_Sales]','U') IS NOT NULL
	BEGIN

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_TransactionsType]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_TradeChanels]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Storehouses]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Staff]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_SalesDocuments]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Routes]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_PriceTypes]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Organizations]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Goods]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_InitiativesTypes]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Documents]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_DeliveryPoints]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Customers]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_CreditLines]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Calendar]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Business]

		ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Branches]

		DROP TABLE [dbo].[t_Sales]

	END
GO

CREATE TABLE [dbo].[t_Sales](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionDate] [date] NOT NULL,
	[DocumentID] [int] NOT NULL,
	[DocumentRow] [int] NOT NULL,
	[SalesDocumentID] [int] NULL,
	[TransactionTypeID] [int] NOT NULL,
	[BusinessID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
	[BranchID] [int] NULL,
	[StorehouseID] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[TardeShopID] [int] NULL,
	[CreditLineID] [int] NULL,
	[RouteID] [int] NULL,
	[AgentID] [int] NULL,
	[TypePriceID] [int] NULL,
	[TradeChanelID] [int] NULL,
	[GoodID] [int] NOT NULL,
	[InitiativesTypeID] [int] NULL,
	[QuantityBase] [numeric](30, 15) NOT NULL,
	[QuantityUnit] [numeric](30, 15) NOT NULL,
	[QuantityBox] [numeric](30, 15) NOT NULL,
	[QuantityPack] [numeric](30, 15) NOT NULL,
	[QuantityMSU] [numeric](30, 15) NOT NULL,
	[Value] [numeric](30, 15) NOT NULL,
	[WeightGross] [numeric](30, 15) NOT NULL,
	[WeightNet] [numeric](30, 15) NOT NULL,
	[AmountVAT] [numeric](15, 2) NOT NULL,
	[AmountWithoutDiscount] [numeric](15, 2) NOT NULL,
	[Amount] [numeric](15, 2) NOT NULL,
	[AmountInCost] [numeric](15, 2) NOT NULL,
	[AmountInInputPrices] [numeric](15, 2) NOT NULL,
 CONSTRAINT [PK_Sales_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE NONCLUSTERED INDEX [t_Sales_DocumentIDAndRow] ON [dbo].[t_Sales]
(
	[DocumentID] ASC,
	[DocumentRow] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Branches] FOREIGN KEY([BranchID])
REFERENCES [dbo].[t_Branches] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Branches]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Business] FOREIGN KEY([BusinessID])
REFERENCES [dbo].[t_Business] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Business]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Calendar] FOREIGN KEY([TransactionDate])
REFERENCES [dbo].[t_Calendar] ([Date])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Calendar]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_CreditLines] FOREIGN KEY([CreditLineID])
REFERENCES [dbo].[t_CreditLines] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_CreditLines]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[t_Customers] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Customers]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_DeliveryPoints] FOREIGN KEY([TardeShopID])
REFERENCES [dbo].[t_DeliveryPoints] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_DeliveryPoints]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Documents] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[t_Documents] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Documents]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD CONSTRAINT [FK_t_Sales_t_Goods] FOREIGN KEY([GoodID])
REFERENCES [dbo].[t_Goods] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Goods]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Organizations] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[t_Organizations] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Organizations]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_PriceTypes] FOREIGN KEY([TypePriceID])
REFERENCES [dbo].[t_PriceTypes] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_PriceTypes]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Routes] FOREIGN KEY([RouteID])
REFERENCES [dbo].[t_Routes] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Routes]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_SalesDocuments] FOREIGN KEY([SalesDocumentID])
REFERENCES [dbo].[t_SalesDocuments] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_SalesDocuments]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Staff] FOREIGN KEY([AgentID])
REFERENCES [dbo].[t_Staff] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Staff]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Storehouses] FOREIGN KEY([StorehouseID])
REFERENCES [dbo].[t_Storehouses] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Storehouses]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_TradeChanels] FOREIGN KEY([TradeChanelID])
REFERENCES [dbo].[t_TradeChanels] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_TradeChanels]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_InitiativesTypes] FOREIGN KEY([InitiativesTypeID])
REFERENCES [dbo].[t_InitiativesTypes] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_InitiativesTypes]
GO

ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_TransactionsType] FOREIGN KEY([TransactionTypeID])
REFERENCES [dbo].[t_TransactionsType] ([ID])
GO

ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_TransactionsType]
GO