SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_ReceivablesOfCustomers]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_ReceivablesOfCustomers]
GO

CREATE PROCEDURE [dbo].[update_ReceivablesOfCustomers]
	@StartDate date,
	@EndDate date
AS
BEGIN

	WHILE @StartDate <= @EndDate
	BEGIN

		DELETE
		FROM dbo.t_ReceivablesOfCustomers
		WHERE ДатаЗадолженности = @StartDate

		INSERT INTO dbo.t_ReceivablesOfCustomers
		SELECT
			@StartDate AS ДатаЗадолженности
			,*
		FROM dbo.get_ReceivablesFromUAS (@StartDate)

		MERGE INTO dbo.t_RelevanceTimeOfReportData AS t_Relevance
			USING(	
					SELECT
						@StartDate AS ReportDate
						,2 AS ReportID
						,GETDATE() AS RelevanceTime
					) AS Relevance
			ON t_Relevance.ReportDate = Relevance.ReportDate AND  t_Relevance.ReportID = Relevance.ReportID
				WHEN MATCHED THEN
					UPDATE
						SET	RelevanceTime = Relevance.RelevanceTime
				WHEN NOT MATCHED BY TARGET THEN
					INSERT (	ReportDate
								,ReportID
								,RelevanceTime)
					VALUES (	Relevance.ReportDate
								,Relevance.ReportID
								,Relevance.RelevanceTime);

		SET @StartDate = DATEADD(day, 1, @StartDate)
	END

END
