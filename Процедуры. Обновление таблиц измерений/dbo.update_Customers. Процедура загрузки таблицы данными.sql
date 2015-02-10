SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Customers]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Customers]
GO

CREATE PROCEDURE [dbo].[update_Customers]
AS
BEGIN

	MERGE INTO [dbo].[t_Customers] AS ReportingTable
	USING (	
			SELECT
				Customers.Ссылка AS UID_1C												-- ID контрагента
				,Customers.Код AS Code													-- Код
				,Customers.ИНН AS INN													-- ИНН
				,Customers.Наименование AS Description									-- Наименовнаие		
				,Customers.Код + ': ' + Customers.Наименование AS CodeDescription		-- Код: Наименовнаие
				,Customers.Наименование + ' (' + Customers.Код + ')' AS DescriptionCode	-- Наименование (Код)
				,Customers.ИНН + ': ' + Customers.Наименование AS INNDescription		-- ИНН: Наименование
				,Customers.Наименование + ' (' + Customers.ИНН + ')' AS DescriptionINN	-- Наименование (ИНН)
				,CastomerLegalAddress.Представление AS LegalAddress						-- Юридический адрес
				,CastomerFactAddress.Представление AS FactAddress						-- Фактический адрес
				,ISNULL(CustomersTypes.ID, 0) AS CustomerTypeID							-- ID типа котрагента
				,Customers.Покупатель AS IsBuyer										-- Признак покупателя
				,Customers.Поставщик AS IsContractor									-- Признак поставщика
				,Customers.ПометкаУдаления AS IsDeleted									-- Пометка на удаление
			FROM [uas_central].dbo.Справочник_Контрагенты AS Customers																										-- Справочник.Контрагенты
			LEFT JOIN [uas_central].dbo.Справочник_Контрагенты_КонтактнаяИнформация AS CastomerLegalAddress ON CastomerLegalAddress.Владелец = Customers.Ссылка				-- Справочник.Контрагенты_КонтактнаяИнформация
			INNER JOIN [uas_central].dbo.Справочник_ВидыКонтактнойИнформации AS ContactTypeLegalAddress ON ContactTypeLegalAddress.Ссылка = CastomerLegalAddress.Вид		-- Справочник.ВидыКонтактнойИнформации
																				AND ContactTypeLegalAddress.ИмяПредопределенныхДанных = 0xA581F8724C86FD9C4E1AA1B9D95035D6	-- Юридический адрес
			LEFT JOIN [uas_central].dbo.Справочник_Контрагенты_КонтактнаяИнформация AS CastomerFactAddress ON CastomerFactAddress.Владелец = Customers.Ссылка				-- Справочник.Контрагенты_КонтактнаяИнформация
			INNER JOIN [uas_central].dbo.Справочник_ВидыКонтактнойИнформации AS ContactTypeFactAddress ON ContactTypeFactAddress.Ссылка = CastomerFactAddress.Вид			-- Справочник.ВидыКонтактнойИнформации
																				AND ContactTypeFactAddress.ИмяПредопределенныхДанных = 0x9F0111DE9B2A95ED4087A3968FFB5332	-- Фактически адрес
			LEFT JOIN dbo.t_CustomersTypes AS CustomersTypes ON CustomersTypes.UID_1C = Customers.ТипКонтрагента
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
				,CustomerTypeID = From_1C.CustomerTypeID
				,IsBuyer = From_1C.IsBuyer
				,IsContractor = From_1C.IsContractor
				,IsDeleted = From_1C.IsDeleted
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
						,FactAddress
						,CustomerTypeID
						,IsBuyer
						,IsContractor
						,IsDeleted)
			VALUES (	From_1C.UID_1C
						,From_1C.Code
						,From_1C.INN
						,From_1C.Description
						,From_1C.CodeDescription
						,From_1C.DescriptionCode
						,From_1C.INNDescription
						,From_1C.DescriptionINN
						,From_1C.LegalAddress
						,From_1C.FactAddress
						,From_1C.CustomerTypeID
						,From_1C.IsBuyer
						,From_1C.IsContractor
						,From_1C.IsDeleted);

END
GO