SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Customers]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Customers]
GO

CREATE PROCEDURE [dbo].[update_Customers]
AS
BEGIN

	MERGE INTO [dbo].[t_Customers] AS ReportingTable
	USING (	
			SELECT
				Customers.������ AS UID_1C												-- ID �����������
				,Customers.��� AS Code													-- ���
				,Customers.��� AS INN													-- ���
				,Customers.������������ AS Description									-- ������������
				,Customers.������������������ AS FullDescription						-- ������ �����������
				,Customers.��� + ': ' + Customers.������������ AS CodeDescription		-- ���: ������������
				,Customers.������������ + ' (' + Customers.��� + ')' AS DescriptionCode	-- ������������ (���)
				,Customers.��� + ': ' + Customers.������������ AS INNDescription		-- ���: ������������
				,Customers.������������ + ' (' + Customers.��� + ')' AS DescriptionINN	-- ������������ (���)
				,CustomerLegalAddress.������������� AS LegalAddress						-- ����������� �����
				,CustomerFactAddress.������������� AS FactAddress						-- ����������� �����
				,ISNULL(CustomersTypes.ID, 0) AS CustomerTypeID							-- ID ���� ����������
				,Customers.���������� AS IsBuyer										-- ������� ����������
				,Customers.��������� AS IsContractor									-- ������� ����������
				,Customers.��������������� AS IsDeleted									-- ������� �� ��������
				,Customers.���������� AS IsNonresident									-- ������� ������������
			FROM [uas_central].dbo.����������_����������� AS Customers																										-- ����������.�����������
			LEFT JOIN (	SELECT
							ElementFactAddress.�������� AS ��������
							,ElementFactAddress.������������� AS �������������
						FROM [uas_central].dbo.����������_�����������_�������������������� AS ElementFactAddress																-- ����������.�����������_��������������������
						INNER JOIN [uas_central].dbo.����������_������������������������ AS ElementTypeFactAddress ON ElementTypeFactAddress.������ = ElementFactAddress.���	-- ����������.������������������������
																				AND ElementTypeFactAddress.������������������������� = 0xA581F8724C86FD9C4E1AA1B9D95035D6		-- ����������� �����
					) AS CustomerLegalAddress ON CustomerLegalAddress.�������� = Customers.������
			LEFT JOIN (	SELECT
							ElementFactAddress.�������� AS ��������
							,ElementFactAddress.������������� AS �������������
						FROM [uas_central].dbo.����������_�����������_�������������������� AS ElementFactAddress																-- ����������.�����������_��������������������
						INNER JOIN [uas_central].dbo.����������_������������������������ AS ElementTypeFactAddress ON ElementTypeFactAddress.������ = ElementFactAddress.���	-- ����������.������������������������
																				AND ElementTypeFactAddress.������������������������� = 0x9F0111DE9B2A95ED4087A3968FFB5332		-- ����������� �����
					) AS CustomerFactAddress ON CustomerFactAddress.�������� = Customers.������
			LEFT JOIN dbo.t_CustomersTypes AS CustomersTypes ON CustomersTypes.UID_1C = Customers.��������������
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Code = From_1C.Code
				,INN = From_1C.INN
				,Description = From_1C.Description
				,FullDescription = From_1C.FullDescription
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
				,INNDescription = From_1C.INNDescription
				,DescriptionINN = From_1C.DescriptionINN
				,LegalAddress = From_1C.LegalAddress
				,FactAddress = From_1C.FactAddress
				,CustomerTypeID = From_1C.CustomerTypeID
				,IsBuyer = From_1C.IsBuyer
				,IsContractor = From_1C.IsContractor
				,IsDeleted = From_1C.IsDeleted
				,IsNonresident = From_1C.IsNonresident
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Code
						,INN
						,Description
						,FullDescription
						,CodeDescription
						,DescriptionCode
						,INNDescription
						,DescriptionINN
						,LegalAddress
						,FactAddress
						,CustomerTypeID
						,IsBuyer
						,IsContractor
						,IsDeleted
						,IsNonresident)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.INN
						,From_1C.Description
						,From_1C.FullDescription
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.INNDescription
						,From_1C.DescriptionINN
						,From_1C.LegalAddress
						,From_1C.FactAddress
						,From_1C.CustomerTypeID
						,From_1C.IsBuyer
						,From_1C.IsContractor
						,From_1C.IsDeleted
						,From_1C.IsNonresident);

END
GO