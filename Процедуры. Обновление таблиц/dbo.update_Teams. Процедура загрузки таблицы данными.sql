SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Teams]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Teams]
GO

CREATE PROCEDURE [dbo].[update_Teams]
AS
BEGIN

	MERGE INTO [dbo].[t_Teams] AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C										-- ID ������� �������� �������
				,Element.������������ AS Description							-- ������������
				,SystemsMobileTrade.ID AS SMT_ID								-- ID ������� ��������� ������
				,ISNULL(Bussiness.Description, '��� �����������') AS Business	-- ����������� �������
			FROM [uas_central].dbo.����������_���������������������� AS Element														-- ����������.����������������������
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.������������������									-- ����������.������������������
			LEFT JOIN dbo.t_SystemsMobileTrade AS SystemsMobileTrade ON SystemsMobileTrade.UID_1C  = Element.����������������������	-- ����������������������
			WHERE Element.��������� = 0x01
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description	= From_1C.Description
				,SMT_ID = From_1C.SMT_ID
				,Business = From_1C.Business
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,SMT_ID
						,Business)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.SMT_ID
						,From_1C.Business);

END
GO