SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_MarketingPrograms]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_MarketingPrograms]
GO

CREATE PROCEDURE [dbo].[update_MarketingPrograms]
AS
BEGIN

	SET IDENTITY_INSERT dbo.t_MarketingPrograms ON

	MERGE INTO dbo.t_MarketingPrograms AS ReportingTable
	USING (	
			SELECT
				1 AS ID
				,ID AS VendorID
				,'Золотая программа'AS Description
			FROM dbo.t_Vendors
			WHERE INN = '7701639976'
			) AS From_1C
	ON ReportingTable.ID = From_1C.ID
		WHEN MATCHED THEN
			UPDATE
			SET	VendorID = From_1C.VendorID
				,Description = From_1C.Description
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	ID
						,VendorID
						,Description)
			VALUES (	From_1C.ID
						,From_1C.VendorID
						,From_1C.Description);

END
GO
