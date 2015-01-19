SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_DeliveryPoints]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_DeliveryPoints]
GO

CREATE PROCEDURE [dbo].[update_DeliveryPoints]
AS
BEGIN

	MERGE INTO [dbo].[t_DeliveryPoints] AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C												-- ID ����� ��������
				,Element.��� AS Code													-- ���
				,Element.������������ AS Description									-- ������������
				,Element.��� + ': ' + Element.������������ AS CodeDescription			-- ���: ������������
				,Element.������������ + ' (' + Element.��� + ')' AS DescriptionCode		-- ������������ (���)
				,ISNULL(Branch.Description, '��� �������') AS Branch							-- ������
			FROM [uas_central].dbo.����������_������������� AS Element												-- ����������.�������������
			INNER JOIN [uas_central].dbo.����������_����������� AS Customers ON Customers.������ = Element.��������	-- ����������.�����������
														AND Customers.���������� = 1								-- ����������
			LEFT JOIN dbo.t_Branches AS Branch ON Branch.UID_1C = Element.������									-- ����������.�������
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Code = From_1C.Code
				,Description = From_1C.Description
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
				,Branch = From_1C.Branch
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Code
						,Description
						,CodeDescription
						,DescriptionCode
						,Branch)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.Branch);

END
GO
