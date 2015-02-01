SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Vendors]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Vendors]
GO

CREATE PROCEDURE [dbo].[update_Vendors]
AS
BEGIN

	MERGE INTO [dbo].[t_Vendors] AS ReportingTable
	USING (	
			SELECT
				Vendors.Ссылка AS UID_1C											-- ID контрагента
				,Vendors.Код AS Code												-- Код
				,Vendors.ИНН AS INN													-- ИНН
				,Vendors.Наименование AS Description								-- Наименовнаие		
				,Vendors.Код + ': ' + Vendors.Наименование AS CodeDescription		-- Код: Наименовнаие
				,Vendors.Наименование + ' (' + Vendors.Код + ')' AS DescriptionCode	-- Наименование (Код)
				,Vendors.ИНН + ': ' + Vendors.Наименование AS INNDescription		-- ИНН: Наименование
				,Vendors.Наименование + ' (' + Vendors.ИНН + ')' AS DescriptionINN	-- Наименование (ИНН)
				,VendorsLegalAddress.Представление AS LegalAddress					-- Юридический адрес
				,VendorsFactAddress.Представление AS FactAddress					-- Фактический адрес
			FROM [uas_central].dbo.Справочник_Контрагенты AS Vendors																										-- Справочник.Контрагенты
			LEFT JOIN [uas_central].dbo.Справочник_Контрагенты_КонтактнаяИнформация AS VendorsLegalAddress ON VendorsLegalAddress.Владелец = Vendors.Ссылка					-- Справочник.Контрагенты_КонтактнаяИнформация
			INNER JOIN [uas_central].dbo.Справочник_ВидыКонтактнойИнформации AS VendorsTypeLegalAddress ON VendorsTypeLegalAddress.Ссылка = VendorsLegalAddress.Вид			-- Справочник.ВидыКонтактнойИнформации
																				AND VendorsTypeLegalAddress.ИмяПредопределенныхДанных = 0xA581F8724C86FD9C4E1AA1B9D95035D6	-- Юридический адрес
			LEFT JOIN [uas_central].dbo.Справочник_Контрагенты_КонтактнаяИнформация AS VendorsFactAddress ON VendorsFactAddress.Владелец = Vendors.Ссылка					-- Справочник.Контрагенты_КонтактнаяИнформация
			INNER JOIN [uas_central].dbo.Справочник_ВидыКонтактнойИнформации AS VendorsTypeFactAddress ON VendorsTypeFactAddress.Ссылка = VendorsFactAddress.Вид			-- Справочник.ВидыКонтактнойИнформации
																				AND VendorsTypeFactAddress.ИмяПредопределенныхДанных = 0x9F0111DE9B2A95ED4087A3968FFB5332	-- Фактически адрес
			WHERE Vendors.Поставщик = 0x01	-- Поставщик
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Code = From_1C.Code
				,INN = From_1C.INN
				,Description = From_1C.Description
				,CodeDescription = From_1C.CodeDescription
				,DescriptionCode = From_1C.DescriptionCode
				,INNDescription = From_1C.INNDescription
				,DescriptionINN = From_1C.DescriptionINN
				,LegalAddress = From_1C.LegalAddress
				,FactAddress = From_1C.FactAddress
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Code
						,INN
						,Description
						,CodeDescription
						,DescriptionCode
						,INNDescription
						,DescriptionINN
						,LegalAddress
						,FactAddress)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.INN
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.INNDescription
						,From_1C.DescriptionINN
						,From_1C.LegalAddress
						,From_1C.FactAddress);

END
GO