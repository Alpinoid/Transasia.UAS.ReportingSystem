SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TypesOfDebt]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TypesOfDebt]
GO

CREATE PROCEDURE [dbo].[update_TypesOfDebt]
AS
BEGIN

	MERGE INTO [dbo].[t_TypesOfDebt] AS ReportingTable
	USING (	
			SELECT
				1 AS ID
				,'�����' AS ��������
			UNION ALL
			SELECT
				2 AS ID
				,'����������' AS ��������
			UNION ALL
			SELECT
				3 AS ID
				,'�� ����������' AS ��������
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	�������� = From_1C.��������
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,��������)
			VALUES (	From_1C.ID
						,From_1C.��������);

END
GO
