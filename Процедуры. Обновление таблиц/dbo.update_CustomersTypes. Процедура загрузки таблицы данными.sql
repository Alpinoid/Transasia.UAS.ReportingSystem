SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CustomersTypes]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CustomersTypes]
GO

CREATE PROCEDURE [dbo].[update_CustomersTypes]
AS
BEGIN

	SET IDENTITY_INSERT [dbo].[t_CustomersTypes] ON

	MERGE INTO [dbo].[t_CustomersTypes] AS ReportingTable
	USING (	
			SELECT
				0 AS ID
				,0x00 AS UID_1C
				,'Переведен в СБ' AS Description
			UNION ALL
			SELECT
				Код AS ID
				,Ссылка AS UID_1C
				,Наименование AS Description
			FROM [uas_central].dbo.Справочник_ТипыКонтрагента
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description	= From_1C.Description
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,UID_1C
						,Description)
			VALUES (	From_1C.ID
						,From_1C.UID_1C
						,From_1C.Description);

END
GO
