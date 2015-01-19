SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_PaymentsType]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_PaymentsType]
GO

CREATE PROCEDURE [dbo].[update_PaymentsType]
AS
BEGIN

	MERGE INTO [dbo].[t_PaymentsType] AS ReportingTable
	USING (	
			SELECT
				Значение AS UID_1C
				,Синоним AS Description
			FROM [uas_central].dbo.Перечисление_СпособыОплаты	-- Перечисление.СпособыОплаты
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Description = From_1C.Description
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Description)
			VALUES (	From_1C.UID_1C
						,From_1C.Description);

END
GO
