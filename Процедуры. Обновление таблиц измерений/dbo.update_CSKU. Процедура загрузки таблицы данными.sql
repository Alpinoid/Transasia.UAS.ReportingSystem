SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CSKU]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CSKU]
GO

CREATE PROCEDURE [dbo].[update_CSKU]
AS
BEGIN

	MERGE INTO dbo.t_CSKU AS ReportingTable
	USING (	
			SELECT
				Element.������ AS UID_1C
				,ISNULL(Element.��������, 0) AS UID_Parent_1C
				,Element.��� AS Code
				,Element.������������ AS Description
				,Element.��� + ': ' + Element.������������ AS CodeDescription
				,Element.������������ + ' (' + Element.��� + ')' AS DescriptionCode
			FROM  [uas_central].dbo.����������_CSKU AS Element
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	UID_Parent_1C = From_1C.UID_Parent_1C
				,Code = From_1C.Code
				,Description = From_1C.Description
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,UID_Parent_1C
						,Code
						,Description
						,CodeDescription
						,DescriptionCode)
			VALUES (	From_1C.UID_1C
						,From_1C.UID_Parent_1C
						,From_1C.Code
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode);

	UPDATE dbo.t_CSKU
		SET dbo.t_CSKU.ParentID = Parent.ID
	FROM dbo.t_CSKU
	LEFT JOIN dbo.t_CSKU AS Parent ON Parent.UID_1C = dbo.t_CSKU.UID_Parent_1C

END
GO
