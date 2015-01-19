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
				Element.Ссылка AS UID_1C													-- ID номенклатуры
				,Element.Артикул AS Article													-- Артикул
				,Element.Наименование AS Description										-- Наименование
				,Element.Артикул + ': ' + Element.Наименование AS ArticleDescription		-- Артикул: Наименовнаие
				,Element.Наименование + ' (' + Element.Артикул + ')' AS DescriptionArticle	-- Наименовнаие (Артикул)
				,ISNULL(Bussiness.Description, 'Без направления') AS Business				-- Направление бизнеса
				,CSKUElements.ID AS CSKU_ID													-- ID CSKU
				,Brands.ID AS BrandID														-- ID бренда
				,ISNULL (
						(	SELECT TOP 1
								IIF(PATINDEX('%[%]%',VATValue.Синоним) = 0, 0, LEFT(VATValue.Синоним, PATINDEX('%[%]%',VATValue.Синоним)-1))
							FROM [uas_central].dbo.РегистрСведений_СтавкиНДС
							LEFT JOIN [uas_central].dbo.Перечисление_СтавкиНДС AS VATValue ON VATValue.Значение = [uas_central].dbo.РегистрСведений_СтавкиНДС.НДС
							WHERE [uas_central].dbo.РегистрСведений_СтавкиНДС.Номенклатура = Element.Ссылка
							ORDER BY [uas_central].dbo.РегистрСведений_СтавкиНДС._Период DESC)
						, 0) AS VAT															-- Става НДС
				,MeasuresBase.Ссылка AS MeasuresBaseUID_1C									-- ID в 1С базовой единиуы измерения
				,Element.MSU AS MSU															-- SU фактор
			FROM [uas_central].dbo.Справочник_Номенклатура AS Element		-- Справочник.Номенклатура
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.НаправлениеБизнеса
			LEFT JOIN dbo.t_Brands AS Brands ON Brands.UID_1C = Element.Бренд
			LEFT JOIN uas_central.dbo.РегистрСведений_КодыCSKU AS CSKU ON CSKU.Номенклатура = Element.Ссылка
			LEFT JOIN dbo.t_CSKUElements AS CSKUElements ON CSKUElements.UID_1C = CSKU.CSKU
			LEFT JOIN [uas_central].dbo.Справочник_ЕдиницыИзмерения AS MeasuresBase ON MeasuresBase.Ссылка = Element.БазоваяЕдиницаИзмерения
			WHERE Element.ЭтоГруппа = 1
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Article = From_1C.Article
				,Description = From_1C.Description
				,ArticleDescription = From_1C.ArticleDescription
				,DescriptionArticle = From_1C.DescriptionArticle
				,Business = From_1C.Business
				,CSKU_ID = From_1C.CSKU_ID
				,BrandID = From_1C.BrandID
				,VAT = From_1C.VAT
				,MeasuresBaseUID_1C = From_1C.MeasuresBaseUID_1C
				,MSU = From_1C.MSU
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Article
						,Description
						,ArticleDescription
						,DescriptionArticle
						,Business
						,CSKU_ID
						,BrandID
						,VAT
						,MeasuresBaseUID_1C
						,MSU)
			VALUES (	From_1C.UID_1C
						,From_1C.Article
						,From_1C.Description
						,From_1C.ArticleDescription
						,From_1C.DescriptionArticle
						,From_1C.Business
						,From_1C.CSKU_ID
						,From_1C.BrandID
						,From_1C.VAT
						,From_1C.MeasuresBaseUID_1C
						,From_1C.MSU);

END
GO
