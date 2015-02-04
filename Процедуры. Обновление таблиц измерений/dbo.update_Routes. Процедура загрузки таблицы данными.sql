SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Routes]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Routes]
GO

CREATE PROCEDURE [dbo].[update_Routes]
AS
BEGIN

	MERGE INTO [dbo].[t_Routes] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C
				,Teams.ID AS TeamID
				,Staff.ID AS ManagerID
				,Element.Наименование AS Description
				,ISNULL(Branches.Description, 'Без филиала') AS Branch
			FROM [uas_central].dbo.Справочник_Маршруты AS Element						-- Справочник.Маршруты
			INNER JOIN dbo.t_Teams AS Teams ON Teams.UID_1C = Element.Владелец			-- Справочник.КомандыТорговыхАгентов
			LEFT JOIN dbo.t_Branches AS Branches ON Branches.UID_1C = Element.Филиал	-- Справочник.Филиалы
			LEFT JOIN dbo.t_Staff AS Staff ON Staff.UID_1C = Element.Менеджер			-- Справочник.Сотрудники
			WHERE Element.ЭтоГруппа = 0x01
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	TeamID = From_1C.TeamID
				,ManagerID = From_1C.ManagerID
				,Description = From_1C.Description
				,Branch = From_1C.Branch
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,TeamID
						,ManagerID
						,Description
						,Branch)
			VALUES (	From_1C.UID_1C
						,From_1C.TeamID
						,From_1C.ManagerID
						,From_1C.Description
						,From_1C.Branch);

END
GO