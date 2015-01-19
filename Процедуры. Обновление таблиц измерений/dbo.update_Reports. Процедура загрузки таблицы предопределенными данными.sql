SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Reports]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Reports]
GO

CREATE PROCEDURE [dbo].[update_Reports]
AS
BEGIN

	MERGE INTO [dbo].[t_Reports] AS ReportingTable
	USING (	
			SELECT
				1 AS ID
				,'Продажи' AS Report
			UNION ALL
			SELECT
				2 AS ID
				,'Дебиторская задолженность' AS ТипДReportолга
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	Report = From_1C.Report
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,Report)
			VALUES (	From_1C.ID
						,From_1C.Report);

END
GO
