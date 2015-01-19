SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[v_ReceivablesOfCustomers]','V') IS NOT NULL
	DROP VIEW [dbo].[v_ReceivablesOfCustomers]
GO

CREATE VIEW [dbo].[v_ReceivablesOfCustomers]
AS

SELECT
	Receivables.ДатаЗадолженности AS ДатаЗадолженности								-- Дата задолженности
	,TypesOfDebt.ТипДолга AS ТипДолга												-- Тип долга
	,TypesOfDelay.ВидПросрочки AS ВидПросрочки										-- Вид просрочки
	,CustomersTypes.Description AS ТипКонтрагента									-- Тип котрагента
	,Customer.Код AS ШифрКонтрагента												-- Код контрагента
	,Customer.Наименование AS НаименованиеКонтрагента								-- Наименование контрагента
	,Customer.ИНН AS ИННКонтрагента													-- ИНН контрагента
	,ISNULL(TradeShop.Код, 'Нет') AS ШифрТочкиДоставки								-- Шифр точки доставки
	,ISNULL(TradeShop.Наименование, 'Нет') AS ТочкаДоставки							-- Наименоввание точки доставки
	,Company.Наименование AS Организация											-- Наименование организации
	,Business.Наименование AS НаправлениеБизнеса									-- Направление бизнеса
	,Branch.Наименование AS Филиал													-- Наименовнаие филиала
	,ISNULL(CreditLine.Наименование, 'Нет') AS КредитноеНаправление					-- Кредитное направления
	,ISNULL(Route.Наименование, 'Нет') AS Маршрут									-- Марушрта (торговый представитель)
	,ISNULL(Docs.ВидДокумента, 'Аванс') AS ВидДокумента								-- Вид документа
	,ISNULL(SalesDocumentsType.Description, 'Не определен') AS ТипДокументаПродажи	-- Тип документа продажи
	,ISNULL(Docs.НомерДокумента, 'Аванс') AS НомерДокумента							-- Номер документа
	,Docs.ДатаДокумента AS ДатаДокумента											-- Дата документа
	,Docs.ДатаОплаты AS ДатаОплаты													-- Дата оплаты
	,Receivables.ДнейПросрочки														-- Дней просрочки
	,Docs.СуммаДокумента AS СуммаДокумента											-- Сумма документа
	,Receivables.Сумма_0 AS СуммаРазвернутая										-- все авансы свернуты до одной строки, долги контрагента остаются как есть
	,Receivables.Сумма_1 AS СуммаЗакрытаяПоПросроченным								-- все авансы свернуты до одной строки, просрочненные долги контрагента закрываются имеющимися  авансами
	,Receivables.Сумма_2 AS СуммаЗакрытаяПоВсем										-- все авансы свернуты до одной строки, все долги контрагента закрываются имеющимися авансами
	,Receivables.Сумма_3 AS СуммаСвернутаяЗакрытаяПоПросроченным					-- Организация, Направление бизнеса и Филиал не учитываются, все авансы свернуты до одной строки, просрочненные долги контрагента закрываются имеющимися  авансами
	,ISNULL(OldBase.ИмяБД, IIF(TradeShop.Код IS NULL, 'Нет','Новая')) AS БазаДанных	-- База данных - источник
	,ISNULL(OldBase.Код, IIF(TradeShop.Код IS NULL, 'Нет','Новая')) AS СтарыйШифр	-- Шифр в базе-источнике
FROM [ReportingDatabase].dbo.t_ReceivablesOfCustomers AS Receivables
LEFT JOIN [ReportingDatabase].dbo.t_TypesOfDebt AS TypesOfDebt ON TypesOfDebt.ID = Receivables.ВидДолга
LEFT JOIN [ReportingDatabase].dbo.t_TypesOfDelay AS TypesOfDelay ON TypesOfDelay.ID = Receivables.ВидПросрочки
LEFT JOIN [ReportingDatabase].dbo.t_CustomersTypes AS CustomersTypes ON CustomersTypes.ID = Receivables.ТипКонтрагента
LEFT JOIN [ReportingDatabase].dbo.t_SalesDocumentsType AS SalesDocumentsType ON SalesDocumentsType.ID = Receivables.ТипДокументаПродажи
LEFT JOIN [uas_central].dbo.Справочник_Контрагенты AS Customer ON Customer.Ссылка = Receivables.Контрагент
LEFT JOIN [uas_central].dbo.Справочник_ТипыКонтрагента AS CustomersType ON CustomersType.Ссылка = Customer.ТипКонтрагента
LEFT JOIN [uas_central].dbo.Справочник_Организации AS Company ON Company.Ссылка = Receivables.Организация
LEFT JOIN [uas_central].dbo.Справочник_НаправленияБизнеса AS Business ON Business.Ссылка = Receivables.НаправлениеБизнеса
LEFT JOIN [uas_central].dbo.Справочник_Филиалы AS Branch ON Branch.Ссылка = Receivables.Филиал
LEFT JOIN (	SELECT
				Ссылка AS Ссылка
				,ВидДокумента = 'Реализация товаров'
				,Номер AS НомерДокумента
				,Дата AS ДатаДокумента
				,ISNULL(ДатаОплаты, Дата)AS ДатаОплаты
				,КредитноеНаправление AS КредитноеНаправление
				,Маршрут AS Маршрут
				,ТочкаДоставки AS ТочкаДоставки
				,СуммаДокумента AS СуммаДокумента
			FROM [uas_central].dbo.Документ_РеализацияТоваров
			UNION ALL
			SELECT	
				Ссылка AS Ссылка
				,ВидДокумента = 'Возврат товаров от покупателя'
				,Номер AS НомерДокумента
				,Дата AS ДатаДокумента
				,ISNULL(Дата, 0)AS ДатаОплаты
				,КредитноеНаправление AS КредитноеНаправление
				,Маршрут AS Маршрут
				,ТочкаДоставки AS ТочкаДоставки
				,СуммаДокумента AS СуммаДокумента
			FROM [uas_central].dbo.Документ_ВозвратТоваровОтПокупателя
			UNION ALL
			SELECT			
				Ссылка AS Ссылка
				,ВидДокумента = 'Ввод начальных остатков: ' + ВидДокумента
				,Номер AS НомерИсходногоДокумента
				,Дата AS ДатаИсходногоДокумента
				,ISNULL(ДатаОплаты, ДатаИсходногоДокумента) AS ДатаОплаты
				,КредитноеНаправление AS КредитноеНаправление
				,NULL AS Маршрут
				,ТочкаДоставки AS ТочкаДоставки
				,СуммаИсходногоДокумента AS СуммаДокумента
			FROM [uas_central].dbo.Документ_ВводНачальныхОстатковВзаиморасчета
		) AS Docs ON Docs.Ссылка = Receivables.ДокументВзаиморасчета
LEFT JOIN [uas_central].dbo.Справочник_КредитныеНаправления AS CreditLine ON CreditLine.Ссылка = Docs.КредитноеНаправление
LEFT JOIN [uas_central].dbo.Справочник_Маршруты AS Route ON Route.Ссылка = Docs.Маршрут
LEFT JOIN [uas_central].dbo.Справочник_ТочкиДоставки AS TradeShop ON TradeShop.Ссылка = Docs.ТочкаДоставки
LEFT JOIN [uas_central].dbo.РегистрСведений_СоответствиеОбъектовИнформационныхБаз AS OldBase ON OldBase.Объект_Ссылка = TradeShop.Ссылка

GO