SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_TransactionsType]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_TransactionsType]
GO

CREATE PROCEDURE [dbo].[update_TransactionsType]
AS
BEGIN

	MERGE INTO [dbo].[t_TransactionsType] AS ReportingTable
	USING (	
			SELECT
				«начение AS UID_1C
				,—иноним AS Description
			FROM [uas_central].dbo.ѕеречисление_’оз€йственныеќперации	-- ѕеречисление.’оз€йственныеќперации
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