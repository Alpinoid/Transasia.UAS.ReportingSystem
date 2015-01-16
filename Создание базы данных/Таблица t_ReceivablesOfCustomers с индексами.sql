SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF OBJECT_ID('[dbo].[t_ReceivablesOfCustomers]','U') IS NOT NULL
	DROP TABLE [dbo].[t_ReceivablesOfCustomers]
GO

CREATE TABLE [dbo].[t_ReceivablesOfCustomers](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ДатаЗадолженности] [date] NOT NULL,
	[Организация] [binary](16) NOT NULL,
	[НаправлениеБизнеса] [binary](16) NOT NULL,
	[Филиал] [binary](16) NOT NULL,
	[ТипКонтрагента] [int] NOT NULL,
	[Контрагент] [binary](16) NOT NULL,
	[ВидДокумента] [int] NULL,
	[ТипДокументаПродажи] [int] NULL,
	[ДокументВзаиморасчета] [binary](16) NULL,
	[ВидДолга] [int] NOT NULL,
	[ВидПросрочки] [int] NOT NULL,
	[ДнейПросрочки] [int] NOT NULL,
	[Сумма_0] [numeric](15, 2) NOT NULL,
	[Сумма_1] [numeric](15, 2) NOT NULL,
	[Сумма_2] [numeric](15, 2) NOT NULL,
	[Сумма_3] [numeric](15, 2) NOT NULL,
 CONSTRAINT [PK_t_RC_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [t_ROC_by_Дата] ON [dbo].[t_ReceivablesOfCustomers]
(
	[ДатаЗадолженности] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_Организация] ON [dbo].[t_ReceivablesOfCustomers]
(
	[Организация] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_НаправлениеБизнеса] ON [dbo].[t_ReceivablesOfCustomers]
(
	[НаправлениеБизнеса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_Филиал] ON [dbo].[t_ReceivablesOfCustomers]
(
	[Филиал] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_ТипКонтрагента] ON [dbo].[t_ReceivablesOfCustomers]
(
	[ТипКонтрагента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_Контрагент] ON [dbo].[t_ReceivablesOfCustomers]
(
	[Контрагент] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

SET ANSI_PADDING OFF
GO


