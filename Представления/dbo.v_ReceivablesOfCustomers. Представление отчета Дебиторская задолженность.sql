SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[v_ReceivablesOfCustomers]','V') IS NOT NULL
	DROP VIEW [dbo].[v_ReceivablesOfCustomers]
GO

CREATE VIEW [dbo].[v_ReceivablesOfCustomers]
AS

SELECT
	Receivables.����������������� AS �����������������								-- ���� �������������
	,TypesOfDebt.�������� AS ��������												-- ��� �����
	,TypesOfDelay.������������ AS ������������										-- ��� ���������
	,CustomersTypes.Description AS ��������������									-- ��� ����������
	,Customer.��� AS ���������������												-- ��� �����������
	,Customer.������������ AS �����������������������								-- ������������ �����������
	,Customer.��� AS ��������������													-- ��� �����������
	,ISNULL(TradeShop.���, '���') AS �����������������								-- ���� ����� ��������
	,ISNULL(TradeShop.������������, '���') AS �������������							-- ������������� ����� ��������
	,Company.������������ AS �����������											-- ������������ �����������
	,Business.������������ AS ������������������									-- ����������� �������
	,Branch.������������ AS ������													-- ������������ �������
	,ISNULL(CreditLine.������������, '���') AS ��������������������					-- ��������� �����������
	,ISNULL(Route.������������, '���') AS �������									-- �������� (�������� �������������)
	,ISNULL(Docs.������������, '�����') AS ������������								-- ��� ���������
	,ISNULL(SalesDocumentsType.Description, '�� ���������') AS �������������������	-- ��� ��������� �������
	,ISNULL(Docs.��������������, '�����') AS ��������������							-- ����� ���������
	,Docs.������������� AS �������������											-- ���� ���������
	,Docs.���������� AS ����������													-- ���� ������
	,Receivables.�������������														-- ���� ���������
	,Docs.�������������� AS ��������������											-- ����� ���������
	,Receivables.�����_0 AS ����������������										-- ��� ������ �������� �� ����� ������, ����� ����������� �������� ��� ����
	,Receivables.�����_1 AS ���������������������������								-- ��� ������ �������� �� ����� ������, ������������� ����� ����������� ����������� ����������  ��������
	,Receivables.�����_2 AS �������������������										-- ��� ������ �������� �� ����� ������, ��� ����� ����������� ����������� ���������� ��������
	,Receivables.�����_3 AS ������������������������������������					-- �����������, ����������� ������� � ������ �� �����������, ��� ������ �������� �� ����� ������, ������������� ����� ����������� ����������� ����������  ��������
	,ISNULL(OldBase.�����, IIF(TradeShop.��� IS NULL, '���','�����')) AS ����������	-- ���� ������ - ��������
	,ISNULL(OldBase.���, IIF(TradeShop.��� IS NULL, '���','�����')) AS ����������	-- ���� � ����-���������
FROM [ReportingDatabase].dbo.t_ReceivablesOfCustomers AS Receivables
LEFT JOIN [ReportingDatabase].dbo.t_TypesOfDebt AS TypesOfDebt ON TypesOfDebt.ID = Receivables.��������
LEFT JOIN [ReportingDatabase].dbo.t_TypesOfDelay AS TypesOfDelay ON TypesOfDelay.ID = Receivables.������������
LEFT JOIN [ReportingDatabase].dbo.t_CustomersTypes AS CustomersTypes ON CustomersTypes.ID = Receivables.��������������
LEFT JOIN [ReportingDatabase].dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.ID = Receivables.�������������������
LEFT JOIN [uas_central].dbo.����������_����������� AS Customer ON Customer.������ = Receivables.����������
LEFT JOIN [uas_central].dbo.����������_��������������� AS CustomersType ON CustomersType.������ = Customer.��������������
LEFT JOIN [uas_central].dbo.����������_����������� AS Company ON Company.������ = Receivables.�����������
LEFT JOIN [uas_central].dbo.����������_������������������ AS Business ON Business.������ = Receivables.������������������
LEFT JOIN [uas_central].dbo.����������_������� AS Branch ON Branch.������ = Receivables.������
LEFT JOIN (	SELECT
				������ AS ������
				,������������ = '���������� �������'
				,����� AS ��������������
				,���� AS �������������
				,ISNULL(����������, ����)AS ����������
				,�������������������� AS ��������������������
				,������� AS �������
				,������������� AS �������������
				,�������������� AS ��������������
			FROM [uas_central].dbo.��������_�����������������
			UNION ALL
			SELECT	
				������ AS ������
				,������������ = '������� ������� �� ����������'
				,����� AS ��������������
				,���� AS �������������
				,ISNULL(����, 0)AS ����������
				,�������������������� AS ��������������������
				,������� AS �������
				,������������� AS �������������
				,�������������� AS ��������������
			FROM [uas_central].dbo.��������_��������������������������
			UNION ALL
			SELECT			
				������ AS ������
				,������������ = '���� ��������� ��������: ' + ������������
				,����� AS �����������������������
				,���� AS ����������������������
				,ISNULL(����������, ����������������������) AS ����������
				,�������������������� AS ��������������������
				,NULL AS �������
				,������������� AS �������������
				,����������������������� AS ��������������
			FROM [uas_central].dbo.��������_����������������������������������
		) AS Docs ON Docs.������ = Receivables.���������������������
LEFT JOIN [uas_central].dbo.����������_�������������������� AS CreditLine ON CreditLine.������ = Docs.��������������������
LEFT JOIN [uas_central].dbo.����������_�������� AS Route ON Route.������ = Docs.�������
LEFT JOIN [uas_central].dbo.����������_������������� AS TradeShop ON TradeShop.������ = Docs.�������������
LEFT JOIN [uas_central].dbo.���������������_������������������������������������� AS OldBase ON OldBase.������_������ = TradeShop.������

GO