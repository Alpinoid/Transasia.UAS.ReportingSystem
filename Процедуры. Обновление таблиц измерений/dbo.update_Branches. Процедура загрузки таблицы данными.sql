SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Branches]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Branches]
GO

CREATE PROCEDURE [dbo].[update_Branches]
AS
BEGIN

	MERGE INTO [dbo].[t_Branches] AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C
				,Element.������������ AS Description
				,CASE
					WHEN SUM(1) OVER (PARTITION BY Parent.������������) <=1 THEN Element.������������
					ELSE Parent.������������
				END AS ParentDescription
				,CASE
					WHEN SUM(1) OVER (PARTITION BY Parent.������������) <=1 THEN NULL
					ELSE Element.������������
				END AS ChildDescription
			FROM [uas_central].dbo.����������_������� AS Element											-- ����������.�������
			LEFT JOIN [uas_central].dbo.����������_������� AS Parent ON Parent.������ = Element.��������	-- ����������.������� (��������)
										OR (Parent.������ = Element.������ AND Element.�������� = 0)
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,ParentDescription = From_1C.ParentDescription
				,ChildDescription = From_1C.ChildDescription
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description
						,ChildDescription
						,ParentDescription)
			VALUES (	From_1C.UID_1C
						,From_1C.Description
						,From_1C.ParentDescription
						,From_1C.ChildDescription);

END
GO