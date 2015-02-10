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
				,Customers.��� + ': ' + Customers.������������ AS CodeDescription		-- ���: ������������
				,Customers.������������ + ' (' + Customers.��� + ')' AS DescriptionCode	-- ������������ (���)
				,Customers.��� + ': ' + Customers.������������ AS INNDescription		-- ���: ������������
				,Customers.������������ + ' (' + Customers.��� + ')' AS DescriptionINN	-- ������������ (���)
				,CastomerLegalAddress.������������� AS LegalAddress						-- ����������� �����
				,CastomerFactAddress.������������� AS FactAddress						-- ����������� �����
				,ISNULL(CustomersTypes.ID, 0) AS CustomerTypeID							-- ID ���� ����������
				,Customers.���������� AS IsBuyer										-- ������� ����������
				,Customers.��������� AS IsContractor									-- ������� ����������
				,Customers.��������������� AS IsDeleted									-- ������� �� ��������
			FROM [uas_central].dbo.����������_����������� AS Customers																										-- ����������.�����������
			LEFT JOIN [uas_central].dbo.����������_�����������_�������������������� AS CastomerLegalAddress ON CastomerLegalAddress.�������� = Customers.������				-- ����������.�����������_��������������������
			INNER JOIN [uas_central].dbo.����������_������������������������ AS ContactTypeLegalAddress ON ContactTypeLegalAddress.������ = CastomerLegalAddress.���		-- ����������.������������������������
																				AND ContactTypeLegalAddress.������������������������� = 0xA581F8724C86FD9C4E1AA1B9D95035D6	-- ����������� �����
			LEFT JOIN [uas_central].dbo.����������_�����������_�������������������� AS CastomerFactAddress ON CastomerFactAddress.�������� = Customers.������				-- ����������.�����������_��������������������
			INNER JOIN [uas_central].dbo.����������_������������������������ AS ContactTypeFactAddress ON ContactTypeFactAddress.������ = CastomerFactAddress.���			-- ����������.������������������������
																				AND ContactTypeFactAddress.������������������������� = 0x9F0111DE9B2A95ED4087A3968FFB5332	-- ���������� �����
			LEFT JOIN dbo.t_CustomersTypes AS CustomersTypes ON CustomersTypes.UID_1C = Customers.��������������
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Code = From_1C.Code
				,INN = From_1C.INN
				,Description = From_1C.Description
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
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Code
						,INN
						,Description
						,CodeDescription
						,DescriptionCode
						,INNDescription
						,DescriptionINN
						,LegalAddress
						,FactAddress
						,CustomerTypeID
						,IsBuyer
						,IsContractor
						,IsDeleted)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.INN
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.INNDescription
						,From_1C.DescriptionINN
						,From_1C.LegalAddress
						,From_1C.FactAddress
						,From_1C.CustomerTypeID
						,From_1C.IsBuyer
						,From_1C.IsContractor
						,From_1C.IsDeleted);

END
GO