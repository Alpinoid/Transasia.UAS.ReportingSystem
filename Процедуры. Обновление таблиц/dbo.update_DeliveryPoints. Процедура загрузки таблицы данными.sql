SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_DeliveryPoints]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_DeliveryPoints]
GO

CREATE PROCEDURE [dbo].[update_DeliveryPoints]
AS
BEGIN

	MERGE INTO [dbo].[t_DeliveryPoints] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C												-- ID точки доставки
				,Element.Код AS Code													-- Код
				,Element.Наименование AS Description									-- Наименование
				,Element.Код + ': ' + Element.Наименование AS CodeDescription			-- Код: Наименование
				,Element.Наименование + ' (' + Element.Код + ')' AS DescriptionCode		-- Наименовнаие (Код)
				,ISNULL(Branch.Description, 'Без филиала') AS Branch							-- Филиал
			FROM [uas_central].dbo.Справочник_ТочкиДоставки AS Element												-- Справочник.ТочкиДоставки
			INNER JOIN [uas_central].dbo.Справочник_Контрагенты AS Customers ON Customers.Ссылка = Element.Владелец	-- Справочник.Контрагенты
														AND Customers.Покупатель = 1								-- Покупатель
			LEFT JOIN dbo.t_Branches AS Branch ON Branch.UID_1C = Element.Филиал									-- Справочник.Филиалы
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Code = From_1C.Code
				,Description = From_1C.Description
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
				,Branch = From_1C.Branch
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Code
						,Description
						,CodeDescription
						,DescriptionCode
						,Branch)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.Branch);

END
GO
