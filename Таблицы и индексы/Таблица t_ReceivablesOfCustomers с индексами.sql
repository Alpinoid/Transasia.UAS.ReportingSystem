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
	[�����������������] [date] NOT NULL,
	[�����������] [binary](16) NOT NULL,
	[������������������] [binary](16) NOT NULL,
	[������] [binary](16) NOT NULL,
	[��������������] [int] NOT NULL,
	[����������] [binary](16) NOT NULL,
	[������������] [int] NULL,
	[�������������������] [int] NULL,
	[���������������������] [binary](16) NULL,
	[��������] [int] NOT NULL,
	[������������] [int] NOT NULL,
	[�������������] [int] NOT NULL,
	[�����_0] [numeric](15, 2) NOT NULL,
	[�����_1] [numeric](15, 2) NOT NULL,
	[�����_2] [numeric](15, 2) NOT NULL,
	[�����_3] [numeric](15, 2) NOT NULL,
 CONSTRAINT [PK_t_RC_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [t_ROC_by_����] ON [dbo].[t_ReceivablesOfCustomers]
(
	[�����������������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_�����������] ON [dbo].[t_ReceivablesOfCustomers]
(
	[�����������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_������������������] ON [dbo].[t_ReceivablesOfCustomers]
(
	[������������������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_������] ON [dbo].[t_ReceivablesOfCustomers]
(
	[������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_��������������] ON [dbo].[t_ReceivablesOfCustomers]
(
	[��������������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [t_ROC_by_����������] ON [dbo].[t_ReceivablesOfCustomers]
(
	[����������] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

SET ANSI_PADDING OFF
GO


