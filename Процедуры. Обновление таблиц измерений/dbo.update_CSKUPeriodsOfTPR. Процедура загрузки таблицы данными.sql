SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CSKUPeriodsOfTPR]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CSKUPeriodsOfTPR]
GO

CREATE PROCEDURE [dbo].[update_CSKUPeriodsOfTPR]
AS
BEGIN

	MERGE INTO [dbo].[t_CSKUPeriodsOfTPR] AS ReportingTable
	USING (	
			SELECT 
				CSKU.ID AS CSKUID
				,PeriodsOfTPR.ID AS PeriodsOfTPRID
			FROM [uas_central].dbo.����������_����������� AS �����
			INNER JOIN dbo.t_PeriodsOfTPR AS PeriodsOfTPR ON PeriodsOfTPR.StartDate = �����.���������� AND  PeriodsOfTPR.EndDate = �����.�������������
			LEFT JOIN [uas_central].dbo.����������_�����������_�������������� AS �������������� ON ��������������.�������� = �����.������
			LEFT JOIN [uas_central].dbo.����������_������������_�������������������� AS �������������������� ON ��������������������.�������� = ��������������.�����
			INNER JOIN dbo.t_CSKU AS CSKU ON CSKU.UID_1C = ��������������������.SKU
			WHERE �����.�������� = (SELECT �������� FROM [uas_central].dbo.������������_������������� WHERE ��� = '�����_1')
			GROUP BY PeriodsOfTPR.ID, CSKU.ID
			) AS From_1C
	ON ReportingTable.CSKUID = From_1C.CSKUID AND ReportingTable.PeriodsOfTPRID = From_1C.PeriodsOfTPRID
		WHEN NOT MATCHED BY SOURCE THEN
			DELETE
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	CSKUID
						,PeriodsOfTPRID)
			VALUES (	From_1C.CSKUID
						,From_1C.PeriodsOfTPRID);

END
GO