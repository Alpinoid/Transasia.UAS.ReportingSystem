SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Vendors]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Vendors]
GO

CREATE PROCEDURE [dbo].[update_Vendors]
AS
BEGIN

	MERGE INTO [dbo].[t_Vendors] AS ReportingTable
	USING (	
			SELECT
				Vendors.������ AS UID_1C											-- ID �����������
				,Vendors.��� AS Code												-- ���
				,Vendors.��� AS INN													-- ���
				,Vendors.������������ AS Description								-- ������������		
				,Vendors.��� + ': ' + Vendors.������������ AS CodeDescription		-- ���: ������������
				,Vendors.������������ + ' (' + Vendors.��� + ')' AS DescriptionCode	-- ������������ (���)
				,Vendors.��� + ': ' + Vendors.������������ AS INNDescription		-- ���: ������������
				,Vendors.������������ + ' (' + Vendors.��� + ')' AS DescriptionINN	-- ������������ (���)
				,VendorsLegalAddress.������������� AS LegalAddress					-- ����������� �����
				,VendorsFactAddress.������������� AS FactAddress					-- ����������� �����
			FROM [uas_central].dbo.����������_����������� AS Vendors																										-- ����������.�����������
			LEFT JOIN [uas_central].dbo.����������_�����������_�������������������� AS VendorsLegalAddress ON VendorsLegalAddress.�������� = Vendors.������					-- ����������.�����������_��������������������
			INNER JOIN [uas_central].dbo.����������_������������������������ AS VendorsTypeLegalAddress ON VendorsTypeLegalAddress.������ = VendorsLegalAddress.���			-- ����������.������������������������
																				AND VendorsTypeLegalAddress.������������������������� = 0xA581F8724C86FD9C4E1AA1B9D95035D6	-- ����������� �����
			LEFT JOIN [uas_central].dbo.����������_�����������_�������������������� AS VendorsFactAddress ON VendorsFactAddress.�������� = Vendors.������					-- ����������.�����������_��������������������
			INNER JOIN [uas_central].dbo.����������_������������������������ AS VendorsTypeFactAddress ON VendorsTypeFactAddress.������ = VendorsFactAddress.���			-- ����������.������������������������
																				AND VendorsTypeFactAddress.������������������������� = 0x9F0111DE9B2A95ED4087A3968FFB5332	-- ���������� �����
			WHERE Vendors.��������� = 0x01	-- ���������
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
						,FactAddress)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.INN
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.INNDescription
						,From_1C.DescriptionINN
						,From_1C.LegalAddress
						,From_1C.FactAddress);

END
GO