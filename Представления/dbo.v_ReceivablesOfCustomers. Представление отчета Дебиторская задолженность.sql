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
	,ISNULL(Route.������������, '���') AS �������									-- ������� (�������� �������������)
	,CASE
		WHEN Business.������������ = 'Food' THEN	CASE
														WHEN Team.������������������� = 0x01 THEN ISNULL(RouteForFood.������������, '���')
														ELSE ISNULL(Route.������������, '���')
													END
		ELSE ''
	END AS �������Food																-- �������� ��� FOOD (�������� �������������)
	,ISNULL(Docs.������������, '�����') AS ������������								-- ��� ���������
	,ISNULL(SalesDocumentsType.Description, '�� ���������') AS �������������������	-- ��� ��������� �������
	,ISNULL(PaymentsType.Description, '�� ���������') AS ������������������			-- ��� ������ ��������� �������
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
				,������������ AS ������������
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
				,������������ AS ������������
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
				,������������ AS ������������
			FROM [uas_central].dbo.��������_����������������������������������
		) AS Docs ON Docs.������ = Receivables.���������������������
LEFT JOIN [uas_central].dbo.����������_�������������������� AS CreditLine ON CreditLine.������ = Docs.��������������������
LEFT JOIN [uas_central].dbo.����������_�������� AS Route ON Route.������ = Docs.�������
LEFT JOIN [uas_central].dbo.����������_���������������������� AS Team ON Team.������ = Route.��������
LEFT JOIN [uas_central].dbo.����������_������������� AS TradeShop ON TradeShop.������ = Docs.�������������
LEFT JOIN (
			SELECT
				MAX(Route.������������) AS ������������
				,��������.������������� AS �������������
			FROM [uas_central].dbo.����������_��������_������������������������� AS ��������
			LEFT JOIN [uas_central].dbo.����������_�������� AS Route ON Route.������ = ��������.��������
			INNER JOIN [uas_central].dbo.����������_���������������������� AS Team ON Team.������ = Route.��������
																					AND Team.������������������ = 0x829508606E88610311E4843B1F21A0A6
																					AND Team.������������������� = 0x00
			GROUP BY ��������.�������������
		) AS RouteForFood ON RouteForFood.������������� =  Docs.�������������
LEFT JOIN [uas_central].dbo.���������������_������������������������������������� AS OldBase ON OldBase.������_������ = TradeShop.������
LEFT JOIN dbo.t_PaymentsType AS PaymentsType ON PaymentsType.UID_1C = Docs.������������

GO