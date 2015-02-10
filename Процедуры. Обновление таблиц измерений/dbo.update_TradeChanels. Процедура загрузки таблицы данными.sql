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

	MERGE INTO dbo.t_TradeChanels AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C
				,ISNULL(Element.Родитель, 0) AS UID_Parent_1C
				,Element.Наименование AS Description
				,Element.РегламентноеНаименование AS OfficialDescription
				,Element.КодISIS AS CodeISIS
				,Element.КБД AS IsKBD
			FROM [uas_central].dbo.Справочник_КаналыПродаж AS Element											-- Справочник.КаналыПродаж
			WHERE Element.ПометкаУдаления = 0x00
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
				,UID_Parent_1C = From_1C.UID_Parent_1C
				,OfficialDescription = From_1C.OfficialDescription
				,CodeISIS = From_1C.CodeISIS
				,IsKBD = From_1C.IsKBD
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,UID_Parent_1C
						,Description
						,OfficialDescription
						,CodeISIS
						,IsKBD)
			VALUES (	From_1C.UID_1C
						,From_1C.UID_Parent_1C
						,From_1C.Description
						,From_1C.OfficialDescription
						,From_1C.CodeISIS
						,From_1C.IsKBD);

	UPDATE dbo.t_TradeChanels
		SET dbo.t_TradeChanels.ParentID = Parent.ID
	FROM dbo.t_TradeChanels
	LEFT JOIN dbo.t_TradeChanels AS Parent ON Parent.UID_1C = dbo.t_TradeChanels.UID_Parent_1C

END
GO
