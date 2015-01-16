SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CSKUElements]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CSKUElements]
GO

CREATE PROCEDURE [dbo].[update_CSKUElements]
AS
BEGIN

	MERGE INTO [dbo].[t_CSKUElements] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C
				,Hierarchy.ID AS HierarchyID
				,Element.Код AS Code
				,Element.Наименование AS Description
				,Element.Код + ': ' + Element.Наименование AS CodeDescription
				,Element.Наименование + ' (' + Element.Код + ')' AS DescriptionCode
			FROM  [uas_central].dbo.Справочник_CSKU AS Element
			LEFT JOIN dbo.t_CSKUHierarchy AS Hierarchy ON Hierarchy.UID_1C = Element.Родитель
			WHERE Element.ЭтоГруппа = 0x01
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	HierarchyID = From_1C.HierarchyID
				,Code = From_1C.Code
				,Description = From_1C.Description
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,HierarchyID
						,Code
						,Description
						,CodeDescription
						,DescriptionCode)
			VALUES (	From_1C.UID_1C
						,From_1C.HierarchyID
						,From_1C.Code
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode);

END
GO
