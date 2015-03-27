SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_Goods]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Goods]
GO

CREATE PROCEDURE [dbo].[update_Goods]
AS
BEGIN

	MERGE INTO [dbo].[t_Goods] AS ReportingTable
	USING (	
			SELECT
				Element.Ссылка AS UID_1C																-- UID номенклатуры
				,ISNULL(Element.Родитель, 0) AS UID_Parent_1C											-- UID родителя
				,ISNULL(Element.Артикул, '') AS Article													-- Артикул
				,Element.Наименование AS Description													-- Наименование
				,ISNULL(Element.Артикул, '')  + ': ' + Element.Наименование AS ArticleDescription		-- Артикул: Наименовнаие
				,Element.Наименование + ' (' + ISNULL(Element.Артикул, '')  + ')' AS DescriptionArticle	-- Наименовнаие (Артикул)
				,CSKU.ID AS CSKU_ID																-- ID CSKU
				,Brands.ID AS BrandID																	-- ID бренда
				,ISNULL (
						(	SELECT TOP 1
								IIF(PATINDEX('%[%]%',VATValue.Синоним) = 0, 0, LEFT(VATValue.Синоним, PATINDEX('%[%]%',VATValue.Синоним)-1))
							FROM [uas_central].dbo.РегистрСведений_СтавкиНДС
							LEFT JOIN [uas_central].dbo.Перечисление_СтавкиНДС AS VATValue ON VATValue.Значение = [uas_central].dbo.РегистрСведений_СтавкиНДС.НДС
							WHERE [uas_central].dbo.РегистрСведений_СтавкиНДС.Номенклатура = Element.Ссылка
							ORDER BY [uas_central].dbo.РегистрСведений_СтавкиНДС._Период DESC)
						, 0) AS VAT																		-- Става НДС
				,MeasuresBase.Ссылка AS MeasuresBaseUID_1C												-- ID в 1С базовой единиуы измерения
				,ISNULL(Element.MSU, 0) AS MSU															-- SU фактор
				,Bussiness.ID  AS BusinessID															-- ID направления бизнеса
				,ISNULL ((
							SELECT TOP 1
								IIF(MeasuresUnit.Коэффициент = 0, 1, MeasuresUnit.Коэффициент) AS Коэффициент
							FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
							INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																								AND Class.Код = '796'	-- [шт]
							WHERE MeasuresUnit.Владелец = Element.Ссылка), 1) AS FactorUnit				-- Коэффициент пересчета в штуки
				,ISNULL ((
							SELECT TOP 1
								IIF(MeasuresUnit.Коэффициент = 0, 1, MeasuresUnit.Коэффициент) AS Коэффициент
							FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
							INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																								AND Class.Код = '384'	-- [кор]
							WHERE MeasuresUnit.Владелец = Element.Ссылка), 1) AS FactorBox				-- Коэффициент пересчета в коробки
				,ISNULL ((
							SELECT TOP 1
								IIF(MeasuresUnit.Коэффициент = 0, 1, MeasuresUnit.Коэффициент) AS Коэффициент
							FROM [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresUnit
							INNER JOIN [uas_central].dbo.Справочник_КлассификаторЕдиницИзмерения AS Class ON MeasuresUnit.БазоваяЕдиница = Class.Ссылка
																								AND Class.Код = '888'	-- [уп]
							WHERE MeasuresUnit.Владелец = Element.Ссылка), 1) AS FactorPack				-- Коэффициент пересчета в упаковки
			FROM [uas_central].dbo.Справочник_Номенклатура AS Element		-- Справочник.Номенклатура
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.НаправлениеБизнеса
			LEFT JOIN dbo.t_Brands AS Brands ON Brands.UID_1C = Element.Бренд
			LEFT JOIN uas_central.dbo.РегистрСведений_КодыCSKU AS КодыCSKU ON КодыCSKU.Номенклатура = Element.Ссылка
			LEFT JOIN dbo.t_CSKU AS CSKU ON CSKU.UID_1C = КодыCSKU.CSKU
			LEFT JOIN [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresBase ON MeasuresBase.Ссылка = Element.БазоваяЕдиницаИзмерения
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	UID_Parent_1C = From_1C.UID_Parent_1C
				,Article = From_1C.Article
				,Description = From_1C.Description
				,ArticleDescription = From_1C.ArticleDescription
				,DescriptionArticle = From_1C.DescriptionArticle
				,BusinessID = From_1C.BusinessID
				,CSKU_ID = From_1C.CSKU_ID
				,BrandID = From_1C.BrandID
				,VAT = From_1C.VAT
				,MeasuresBaseUID_1C = From_1C.MeasuresBaseUID_1C
				,MSU = From_1C.MSU
				,FactorUnit = From_1C.FactorUnit
				,FactorBox = From_1C.FactorBox
				,FactorPack = From_1C.FactorPack
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,UID_Parent_1C
						,Article
						,Description
						,ArticleDescription
						,DescriptionArticle
						,BusinessID
						,CSKU_ID
						,BrandID
						,VAT
						,MeasuresBaseUID_1C
						,MSU
						,FactorUnit
						,FactorBox
						,FactorPack)
			VALUES (	From_1C.UID_1C
						,From_1C.UID_Parent_1C
						,From_1C.Article
						,From_1C.Description
						,From_1C.ArticleDescription
						,From_1C.DescriptionArticle
						,From_1C.BusinessID
						,From_1C.CSKU_ID
						,From_1C.BrandID
						,From_1C.VAT
						,From_1C.MeasuresBaseUID_1C
						,From_1C.MSU
						,From_1C.FactorUnit
						,From_1C.FactorBox
						,From_1C.FactorPack);

	UPDATE dbo.t_Goods
		SET dbo.t_Goods.ParentID = Parent.ID
	FROM dbo.t_Goods
	LEFT JOIN dbo.t_Goods AS Parent ON Parent.UID_1C = dbo.t_Goods.UID_Parent_1C

END
GO
