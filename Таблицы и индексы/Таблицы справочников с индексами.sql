SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- ���������
BEGIN

	IF OBJECT_ID('[dbo].[t_Calendar]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Calendar]

	CREATE TABLE [dbo].[t_Calendar](
		[Date] [date] NOT NULL,
		[Year] [smallint] NOT NULL,
		[Quarter] [tinyint] NOT NULL,
		[NameQuarter] [nvarchar](16) NOT NULL,
		[Month] [smallint] NOT NULL,
		[NameOfMonth] [nvarchar](16) NOT NULL,
		[Week] [tinyint] NOT NULL,
		[DayOfYear] [smallint] NOT NULL,
		[DayOfMonth] [tinyint] NOT NULL,
		[Weekday] [tinyint] NOT NULL,
		[WeekdayName] [nvarchar](16) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Date] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ������ �������
BEGIN

	IF OBJECT_ID('[dbo].[t_Reports]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Reports]

	CREATE TABLE [dbo].[t_Reports](
		[ID] [int] NOT NULL,
		[Report] [varchar](64) NOT NULL,
	 CONSTRAINT [PK_Reports_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ���� �������
BEGIN

	IF OBJECT_ID('[dbo].[t_ReportsTypes]','U') IS NOT NULL
		DROP TABLE [dbo].[t_ReportsTypes]

	CREATE TABLE [dbo].[t_ReportsTypes](
		[ID] [int] NOT NULL,
		[ReportID] [int] NOT NULL,
		[ReportsTypes] [varchar](256) NOT NULL,
	 CONSTRAINT [PK_ReportsTypes_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ����� ������������ ������ ������
BEGIN

	IF OBJECT_ID('[dbo].[t_RelevanceTimeOfReportData]','U') IS NOT NULL
		DROP TABLE [dbo].[t_RelevanceTimeOfReportData]

	CREATE TABLE [dbo].[t_RelevanceTimeOfReportData](
		[ReportDate] [date] NOT NULL,
		[ReportID] [int] NOT NULL,
		[RelevanceTime] [datetime] NOT NULL,
	 CONSTRAINT [PK_RelevanceTimeOfReportData_ID] PRIMARY KEY CLUSTERED 
	(
		[ReportDate] ASC
		,[ReportID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ���� �������������
BEGIN

	IF OBJECT_ID('[dbo].[t_TypesOfDebt]','U') IS NOT NULL
		DROP TABLE [dbo].[t_TypesOfDebt]

	CREATE TABLE [dbo].[t_TypesOfDebt](
		[ID] [int] NOT NULL,
		[��������] [varchar](64) NOT NULL,
	 CONSTRAINT [PK_t_TOD_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ���� ��������
BEGIN

	IF OBJECT_ID('[dbo].[t_TypesOfDelay]','U') IS NOT NULL
		DROP TABLE [dbo].[t_TypesOfDelay]

	CREATE TABLE [dbo].[t_TypesOfDelay](
		[ID] [int] NOT NULL,
		[������������] [varchar](64) NOT NULL,
		[MinDay] [int] NOT NULL,
		[MaxDay] [int] NOT NULL,
	 CONSTRAINT [PK_t_TODel_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ����������.������������������
BEGIN

	IF OBJECT_ID('[dbo].[t_Business]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Business]

	CREATE TABLE [dbo].[t_Business](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](50) NOT NULL,
		[OrderBy] [int],
	 CONSTRAINT [PK_Business_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Business_UID] ON [dbo].[t_Business]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.�������
BEGIN

	IF OBJECT_ID('[dbo].[t_Branches]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Branches]

	CREATE TABLE [dbo].[t_Branches](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[ParentDescription] [varchar](100),
		[ChildDescription] [varchar](100),
		[OrderBy] [int],
		[ParentOrderBy] [int],
	 CONSTRAINT [PK_Branches_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Branches_UID] ON [dbo].[t_Branches]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.����������.�����������
BEGIN

	IF OBJECT_ID('[dbo].[t_Organizations]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Organizations]

	CREATE TABLE [dbo].[t_Organizations](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](50) NOT NULL
	 CONSTRAINT [PK_Organizations_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Organizations_UID] ON [dbo].[t_Organizations]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

BEGIN
	
	-- ����������.���������������

	IF OBJECT_ID('[dbo].[t_CustomersTypes]','U') IS NOT NULL
		BEGIN
			ALTER TABLE [dbo].[t_Customers] DROP CONSTRAINT [FK_t_Customers_t_CustomersTypes]
			DROP TABLE [dbo].[t_CustomersTypes]
		END

	CREATE TABLE [dbo].[t_CustomersTypes](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](100) NOT NULL
	 CONSTRAINT [PK_CustomersTypes_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_CustomersTypes_UID] ON [dbo].[t_CustomersTypes]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	-- ����������.�����������

	IF OBJECT_ID('[dbo].[t_Customers]','U') IS NOT NULL
		BEGIN
			ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Customers]
			DROP TABLE [dbo].[t_Customers]
		END

	CREATE TABLE [dbo].[t_Customers](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Code] [varchar](11) NOT NULL,
		[INN] [varchar](12) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[CodeDescription] [varchar](128) NOT NULL,
		[DescriptionCode] [varchar](128) NOT NULL,
		[INNDescription] [varchar](128) NOT NULL,
		[DescriptionINN] [varchar](128) NOT NULL,
		[LegalAddress] [varchar](500),
		[FactAddress] [varchar](500),
		[CustomerTypeID] [int] NOT NULL,
		[IsBuyer] [bit] NOT NULL,
		[IsContractor] [bit] NOT NULL,
		[IsDeleted] [bit] NOT NULL
	 CONSTRAINT [PK_Customers_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Customers_UID] ON [dbo].[t_Customers]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	ALTER TABLE [dbo].[t_Customers]  WITH CHECK ADD  CONSTRAINT [FK_t_Customers_t_CustomersTypes] FOREIGN KEY([CustomerTypeID])
	REFERENCES [dbo].[t_CustomersTypes] ([ID])

	ALTER TABLE [dbo].[t_Customers] CHECK CONSTRAINT [FK_t_Customers_t_CustomersTypes]

END

-- ���� ������� ���������
BEGIN

	IF OBJECT_ID('[dbo].[t_TypesOfGoldStore]','U') IS NOT NULL
		DROP TABLE [dbo].[t_TypesOfGoldStore]

	CREATE TABLE [dbo].[t_TypesOfGoldStore](
		[ID] [smallint] IDENTITY(0,1) NOT NULL,
		[Description] [varchar](128) NOT NULL,
	 CONSTRAINT [PK_TypesOfGoldStore_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

-- ����������.�������������
BEGIN

	IF OBJECT_ID('[dbo].[t_DeliveryPoints]','U') IS NOT NULL
		BEGIN
			--ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_DeliveryPoints]
			DROP TABLE [dbo].[t_DeliveryPoints]
		END

	CREATE TABLE [dbo].[t_DeliveryPoints](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Code] [varchar](11) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[CodeDescription] [varchar](128) NOT NULL,
		[DescriptionCode] [varchar](128) NOT NULL,
		[Branch] [varchar](50),
		[GoldStoreType] [smallint] NOT NULL,
		[FactAddress] [varchar](500),
	 CONSTRAINT [PK_DeliveryPoints_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_DeliveryPoints_UID] ON [dbo].[t_DeliveryPoints]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	ALTER TABLE [dbo].[t_DeliveryPoints]  WITH CHECK ADD  CONSTRAINT [FK_t_DeliveryPoints_t_TypesOfGoldStore] FOREIGN KEY([GoldStoreType])
	REFERENCES [dbo].[t_TypesOfGoldStore] ([ID])

	ALTER TABLE [dbo].[t_DeliveryPoints] CHECK CONSTRAINT [FK_t_DeliveryPoints_t_TypesOfGoldStore]

END

-- ����������.��������
BEGIN

	IF OBJECT_ID('[dbo].[t_Routes]','U') IS NOT NULL
		BEGIN
			ALTER TABLE [dbo].[t_Routes] DROP CONSTRAINT [FK_t_Routes_t_Teams]
			ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Routes]
			DROP TABLE [dbo].[t_Routes]
		END

	CREATE TABLE [dbo].[t_Routes](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[TeamID] [int] NOT NULL,
		[ManagerID] [int] NULL,
		[Description] [varchar](100) NOT NULL,
		[Branch] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_Routes_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Routes_UID] ON [dbo].[t_Routes]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	ALTER TABLE [dbo].[t_Routes]  WITH CHECK ADD  CONSTRAINT [FK_t_Routes_t_Teams] FOREIGN KEY([TeamID])
	REFERENCES [dbo].[t_Teams] ([ID])
	
	ALTER TABLE [dbo].[t_Routes] CHECK CONSTRAINT [FK_t_Routes_t_Teams]

	ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_Routes] FOREIGN KEY([RouteID])
	REFERENCES [dbo].[t_Routes] ([ID])

	ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_Routes]

END

-- ����������.����������������������
BEGIN

	IF OBJECT_ID('[dbo].[t_Teams]','U') IS NOT NULL
		BEGIN
			ALTER TABLE [dbo].[t_Routes] DROP CONSTRAINT [FK_t_Routes_t_Teams]
			DROP TABLE [dbo].[t_Teams]
		END

	CREATE TABLE [dbo].[t_Teams](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](25) NOT NULL,
		[SMT_ID] [int] NULL,
		[BusinessID] [int] NULL,
	 CONSTRAINT [PK_Teams_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Teams_UID] ON [dbo].[t_Teams]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	ALTER TABLE [dbo].[t_Routes]  WITH CHECK ADD  CONSTRAINT [FK_t_Routes_t_Teams] FOREIGN KEY([TeamID])
	REFERENCES [dbo].[t_Teams] ([ID])
	
	ALTER TABLE [dbo].[t_Routes] CHECK CONSTRAINT [FK_t_Routes_t_Teams]

END

-- ����������.����������������������
BEGIN

	IF OBJECT_ID('[dbo].[t_SystemsMobileTrade]','U') IS NOT NULL
		DROP TABLE [dbo].[t_SystemsMobileTrade]

	CREATE TABLE [dbo].[t_SystemsMobileTrade](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](25) NOT NULL,
	 CONSTRAINT [PK_SystemsMobileTrade_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_SystemsMobileTrade_UID] ON [dbo].[t_SystemsMobileTrade]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.��������������������
BEGIN

	IF OBJECT_ID('[dbo].[t_CreditLines]','U') IS NOT NULL
		DROP TABLE [dbo].[t_CreditLines]

	CREATE TABLE [dbo].[t_CreditLines](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[Business] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_CreditLines_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_CreditLines_UID] ON [dbo].[t_CreditLines]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.������
BEGIN

	IF OBJECT_ID('[dbo].[t_Storehouses]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Storehouses]

	CREATE TABLE [dbo].[t_Storehouses](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[Branch] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_Storehouses_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Storehouses_UID] ON [dbo].[t_Storehouses]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.�������������������
BEGIN

	IF OBJECT_ID('[dbo].[t_PriceTypes]','U') IS NOT NULL
		DROP TABLE [dbo].[t_PriceTypes]

	CREATE TABLE [dbo].[t_PriceTypes](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](25) NOT NULL,
		[Business] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_PriceTypes_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_PriceTypes_UID] ON [dbo].[t_PriceTypes]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.����������
BEGIN

	IF OBJECT_ID('[dbo].[t_Staff]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Staff]

	CREATE TABLE [dbo].[t_Staff](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_Staf_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Staff_UID] ON [dbo].[t_Staff]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ������������.���������������������
BEGIN

	IF OBJECT_ID('[dbo].[t_BusinessTransactions]','U') IS NOT NULL
		DROP TABLE [dbo].[t_BusinessTransactions]

	CREATE TABLE [dbo].[t_BusinessTransactions](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_BusinessTransactions_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_BusinessTransactions_UID] ON [dbo].[t_BusinessTransactions]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ��������.�����������������
BEGIN

	IF OBJECT_ID('[dbo].[t_SalesDocuments]','U') IS NOT NULL
		DROP TABLE [dbo].[t_SalesDocuments]

	CREATE TABLE [dbo].[t_SalesDocuments](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](128) NOT NULL,
		[DocDate] [date] NOT NULL,
		[DocNumber]  [varchar](21) NOT NULL,
		[DocumentTypeID] [int] NOT NULL,
		[PaymentMethodID] [int] NOT NULL,
		[DocDeliveryDate] [date] NULL,
		[DocPaymentDay] [date] NULL,
		[IsBonusDoc] [bit] NOT NULL,
		[RouteID] [int] NULL,
		[StaffID] [int] NULL,
	 CONSTRAINT [PK_SalesDocuments_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_SalesDocuments_UID] ON [dbo].[t_SalesDocuments]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ������������.��������������
BEGIN

	IF OBJECT_ID('[dbo].[t_SalesDocumentsType]','U') IS NOT NULL
		DROP TABLE [dbo].[t_SalesDocumentsType]

	CREATE TABLE [dbo].[t_SalesDocumentsType](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_SalesDocumentsType_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_SalesDocumentsType_UID] ON [dbo].[t_SalesDocumentsType]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ������������.�������������
BEGIN

	IF OBJECT_ID('[dbo].[t_PaymentsType]','U') IS NOT NULL
		DROP TABLE [dbo].[t_PaymentsType]

	CREATE TABLE [dbo].[t_PaymentsType](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](50) NOT NULL,
	 CONSTRAINT [PK_PaymentsType_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_PaymentsType_UID] ON [dbo].[t_PaymentsType]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END


-- ����������. ���� ���������
BEGIN

	IF OBJECT_ID('[dbo].[t_DocumentsTypes]','U') IS NOT NULL
		DROP TABLE [dbo].[t_DocumentsTypes]

	CREATE TABLE [dbo].[t_DocumentsTypes](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](4) NOT NULL,
		[Description] [varchar](150) NOT NULL,
	 CONSTRAINT [PK_DocumentsTypes_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_DocumentsTypes_UID] ON [dbo].[t_Documents]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ���������
BEGIN

	IF OBJECT_ID('[dbo].[t_Documents]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Documents]

	CREATE TABLE [dbo].[t_Documents](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](128) NOT NULL,
		[DocumentsType] [int] NOT NULL,
		[DocDate] [date] NOT NULL,
		[DocNumber]  [varchar](21) NOT NULL,
	 CONSTRAINT [PK_Documents_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Documents_UID] ON [dbo].[t_Documents]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.������������
BEGIN

	IF OBJECT_ID('[dbo].[t_TradeChanels]','U') IS NOT NULL
		BEGIN
			ALTER TABLE [dbo].[t_TradeChanels] DROP CONSTRAINT [FK_Parent_t_TradeChanels]
			ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_TradeChanels]
			DROP TABLE [dbo].[t_TradeChanels]
		END

	CREATE TABLE [dbo].[t_TradeChanels](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[ParentID] [int] NULL,
		[UID_1C] [binary](16) NOT NULL,
		[UID_Parent_1C] [binary](16) NOT NULL,
		[Description] [varchar](25) NOT NULL,
		[OfficialDescription] [varchar](70) NOT NULL,
		[CodeISIS] [numeric](19,0) NOT NULL,
		[IsKBD] [bit] NOT NULL
	 CONSTRAINT [PK_TradeChanels_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_TradeChanels_UID] ON [dbo].[t_TradeChanels]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	ALTER TABLE [dbo].[t_TradeChanels]  WITH CHECK ADD  CONSTRAINT [FK_Parent_t_TradeChanels] FOREIGN KEY([ParentID])
	REFERENCES [dbo].[t_TradeChanels] ([ID])

	ALTER TABLE [dbo].[t_TradeChanels] CHECK CONSTRAINT [FK_Parent_t_TradeChanels]

	ALTER TABLE [dbo].[t_Sales]  WITH CHECK ADD  CONSTRAINT [FK_t_Sales_t_TradeChanels] FOREIGN KEY([TradeChanelID])
	REFERENCES [dbo].[t_TradeChanels] ([ID])

	ALTER TABLE [dbo].[t_Sales] CHECK CONSTRAINT [FK_t_Sales_t_TradeChanels]

END

-- ����������.������������
BEGIN

	IF OBJECT_ID('[dbo].[t_Goods]','U') IS NOT NULL
		BEGIN
			ALTER TABLE [dbo].[t_Sales] DROP CONSTRAINT [FK_t_Sales_t_Goods]
			DROP TABLE [dbo].[t_Goods]
		END

	CREATE TABLE [dbo].[t_Goods](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[ParentID] [int] NULL,
		[UID_1C] [binary](16) NOT NULL,
		[UID_Parent_1C] [binary](16) NOT NULL,
		[Article] [varchar](25) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[ArticleDescription] [varchar](128) NOT NULL,
		[DescriptionArticle] [varchar](128) NOT NULL,
		[Business] [varchar](50) NOT NULL,
		[CSKU_ID] [int],
		[BrandID] [int],
		[VAT] [numeric](2,0) NOT NULL,
		[MeasuresBaseUID_1C] [binary](16),
		[MSU] [numeric](10,3) NOT NULL,
	 CONSTRAINT [PK_Goods_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Goods_UID] ON [dbo].[t_Goods]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

	CREATE NONCLUSTERED INDEX [t_MeasuresBase_UID] ON [dbo].[t_Goods]
	(
		[MeasuresBaseUID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.CSKU (��������)
BEGIN

	IF OBJECT_ID('[dbo].[t_CSKUElements]','U') IS NOT NULL
		DROP TABLE [dbo].[t_CSKUElements]

	CREATE TABLE [dbo].[t_CSKUElements](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[HierarchyID] [int],
		[Code] [varchar](9) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[CodeDescription] [varchar](128) NOT NULL,
		[DescriptionCode] [varchar](128) NOT NULL,
	 CONSTRAINT [PK_CSKUElements_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_CSKUElements_UID] ON [dbo].[t_CSKUElements]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END


-- ����������.CSKU (��������)
BEGIN

	IF OBJECT_ID('[dbo].[t_CSKUHierarchy]','U') IS NOT NULL
		DROP TABLE [dbo].[t_CSKUHierarchy]

	CREATE TABLE [dbo].[t_CSKUHierarchy](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Parent0_Code] [varchar](9) NOT NULL,
		[Parent0_Description] [varchar](100) NOT NULL,
		[Parent1_Code] [varchar](9),
		[Parent1_Description] [varchar](100),
		[Parent2_Code] [varchar](9),
		[Parent2_Description] [varchar](100),
		[Parent3_Code] [varchar](9),
		[Parent3_Description] [varchar](100),
		[Parent4_Code] [varchar](9),
		[Parent4_Description] [varchar](100),
		[Parent5_Code] [varchar](9),
		[Parent5_Description] [varchar](100),
		[Parent6_Code] [varchar](9),
		[Parent6_Description] [varchar](100),
	 CONSTRAINT [PK_CSKUHierarchy_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_CSKUHierarchy_UID] ON [dbo].[t_CSKUHierarchy]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.������
BEGIN

	IF OBJECT_ID('[dbo].[t_Brands]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Brands]

	CREATE TABLE [dbo].[t_Brands](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](100) NOT NULL
	 CONSTRAINT [PK_Brands_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Brands_UID] ON [dbo].[t_Brands]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.�������������
BEGIN

	IF OBJECT_ID('[dbo].[t_InitiativesTypes]','U') IS NOT NULL
		DROP TABLE [dbo].[t_InitiativesTypes]

	CREATE TABLE [dbo].[t_InitiativesTypes](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Description] [varchar](25) NOT NULL
	 CONSTRAINT [PK_InitiativesTypes_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_InitiativesTypes_UID] ON [dbo].[t_InitiativesTypes]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ����������.����������� (����������)
BEGIN

	IF OBJECT_ID('[dbo].[t_Vendors]','U') IS NOT NULL
		DROP TABLE [dbo].[t_Vendors]

	CREATE TABLE [dbo].[t_Vendors](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UID_1C] [binary](16) NOT NULL,
		[Code] [varchar](11) NOT NULL,
		[INN] [varchar](12) NOT NULL,
		[Description] [varchar](100) NOT NULL,
		[CodeDescription] [varchar](128) NOT NULL,
		[DescriptionCode] [varchar](128) NOT NULL,
		[INNDescription] [varchar](128) NOT NULL,
		[DescriptionINN] [varchar](128) NOT NULL,
		[LegalAddress] [varchar](500),
		[FactAddress] [varchar](500),
	 CONSTRAINT [PK_Vendors_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [t_Vendors_UID] ON [dbo].[t_Vendors]
	(
		[UID_1C] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

END

-- ������������� ���������
BEGIN

	IF OBJECT_ID('[dbo].[t_MarketingPrograms]','U') IS NOT NULL
		DROP TABLE [dbo].[t_MarketingPrograms]

	CREATE TABLE [dbo].[t_MarketingPrograms](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[VendorID] [int] NOT NULL,
		[Description] [varchar](25) NOT NULL
	 CONSTRAINT [PK_MarketingPrograms_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[t_MarketingPrograms]  WITH CHECK ADD  CONSTRAINT [FK_t_MarketingPrograms_t_Vendors] FOREIGN KEY([VendorID])
	REFERENCES [dbo].[t_Vendors] ([ID])

	ALTER TABLE [dbo].[t_MarketingPrograms] CHECK CONSTRAINT [FK_t_MarketingPrograms_t_Vendors]

END

-- ������� �� ������������� ����������
BEGIN

	IF OBJECT_ID('[dbo].[t_SalesMarketingPrograms]','U') IS NOT NULL
		DROP TABLE [dbo].[t_SalesMarketingPrograms]

	CREATE TABLE [dbo].[t_SalesMarketingPrograms](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[SalesID] [bigint] NOT NULL,
		[MarketingProgramID] [int] NOT NULL
	 CONSTRAINT [PK_SalesMarketingPrograms_ID] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[t_SalesMarketingPrograms]  WITH CHECK ADD  CONSTRAINT [FK_t_SalesMarketingPrograms_t_MarketingPrograms] FOREIGN KEY([MarketingProgramID])
	REFERENCES [dbo].[t_MarketingPrograms] ([ID])

	ALTER TABLE [dbo].[t_SalesMarketingPrograms] CHECK CONSTRAINT [FK_t_SalesMarketingPrograms_t_MarketingPrograms]

	ALTER TABLE [dbo].[t_SalesMarketingPrograms]  WITH CHECK ADD  CONSTRAINT [FK_t_SalesMarketingPrograms_t_Sales] FOREIGN KEY([SalesID])
	REFERENCES [dbo].[t_Sales] ([ID])

	ALTER TABLE [dbo].[t_SalesMarketingPrograms] CHECK CONSTRAINT [FK_t_SalesMarketingPrograms_t_Sales]

END

SET ANSI_PADDING OFF
GO
