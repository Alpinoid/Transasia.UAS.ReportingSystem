SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TradeChanels]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TradeChanels]
GO

CREATE PROCEDURE [dbo].[update_TradeChanels]
AS
BEGIN

	MERGE INTO [dbo].[t_TradeChanels] AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C
				,Element.������������ AS Description
				,CASE
					WHEN SUM(1) OVER (PARTITION BY Parent.������������) <=1 THEN Element.������������
					ELSE Parent.������������
				END AS ParentDescription
				
				,Element.������������������������ AS OfficialDescription
				,Element.���ISIS AS CodeISIS
				,Element.��� AS IsKBD
			FROM [uas_central].dbo.����������_������������ AS Element											-- ����������.������������
			LEFT JOIN [uas_central].dbo.����������_������������ AS Parent ON Parent.������ = Element.��������	-- ����������.������������ (��������)
										OR (Parent.������ = Element.������ AND Element.�������� = 0)
			WHERE Element.�������� <> 0x00  AND Element.��������������� = 0x00
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,ParentDescription = From_1C.ParentDescription
				,OfficialDescription = From_1C.OfficialDescription
				,CodeISIS = From_1C.CodeISIS
				,IsKBD = From_1C.IsKBD
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,ParentDescription
						,Description
						,OfficialDescription
						,CodeISIS
						,IsKBD)
			VALUES (	From_1C.UID_1C
						,From_1C.ParentDescription
						,From_1C.Description
						,From_1C.OfficialDescription
						,From_1C.CodeISIS
						,From_1C.IsKBD);

END
GO
