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
		FROM [dbo].[get_ReceivablesFromUAS] (@StartDate)

		SET @StartDate = DATEADD(dd, 1, @StartDate)
	END

END
