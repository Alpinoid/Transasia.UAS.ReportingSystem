SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_ReportsTypes]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_ReportsTypes]
GO

CREATE PROCEDURE [dbo].[update_ReportsTypes]
AS
BEGIN

	MERGE INTO [dbo].[t_ReportsTypes] AS ReportingTable
	USING (	
			SELECT
				1 AS ID
				,2 AS ReportID
				,'јвансы свернуты до одной строки, долги контрагента остаютс€ как есть.' AS ReportsTypes
			UNION ALL
			SELECT
				2 AS ID
				,2 AS ReportID
				,'јвансы свернуты до одной строки, просрочненные долги контрагента закрываютс€ имеющимис€ авансами.' AS ReportsTypes
			UNION ALL
			SELECT
				3 AS ID
				,2 AS ReportID
				,'јвансы свернуты до одной строки, все долги контрагента закрываютс€ имеющимис€ авансами.' AS ReportsTypes
			UNION ALL
			SELECT
				4 AS ID
				,2 AS ReportID
				,'ќрганизаци€, Ќаправление бизнеса и ‘илиал не учитываютс€, все авансы свернуты до одной строки, просрочненные долги контрагента закрываютс€ имеющимис€ авансами.' AS ReportsTypes
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	ReportID = From_1C.ReportID
				,ReportsTypes = From_1C.ReportsTypes
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,ReportID
						,ReportsTypes)
			VALUES (	From_1C.ID
						,From_1C.ReportID
						,From_1C.ReportsTypes);

END
GO
