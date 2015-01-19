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
				Element.������ AS UID_1C													-- ID ������������
				,Element.������� AS Article													-- �������
				,Element.������������ AS Description										-- ������������
				,Element.������� + ': ' + Element.������������ AS ArticleDescription		-- �������: ������������
				,Element.������������ + ' (' + Element.������� + ')' AS DescriptionArticle	-- ������������ (�������)
				,ISNULL(Bussiness.Description, '��� �����������') AS Business				-- ����������� �������
				,CSKUElements.ID AS CSKU_ID													-- ID CSKU
				,Brands.ID AS BrandID														-- ID ������
				,ISNULL (
						(	SELECT TOP 1
								IIF(PATINDEX('%[%]%',VATValue.�������) = 0, 0, LEFT(VATValue.�������, PATINDEX('%[%]%',VATValue.�������)-1))
							FROM [uas_central].dbo.���������������_���������
							LEFT JOIN [uas_central].dbo.������������_��������� AS VATValue ON VATValue.�������� = [uas_central].dbo.���������������_���������.���
							WHERE [uas_central].dbo.���������������_���������.������������ = Element.������
							ORDER BY [uas_central].dbo.���������������_���������._������ DESC)
						, 0) AS VAT															-- ����� ���
				,MeasuresBase.������ AS MeasuresBaseUID_1C									-- ID � 1� ������� ������� ���������
				,Element.MSU AS MSU															-- SU ������
			FROM [uas_central].dbo.����������_������������ AS Element		-- ����������.������������
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.������������������
			LEFT JOIN dbo.t_Brands AS Brands ON Brands.UID_1C = Element.�����
			LEFT JOIN uas_central.dbo.���������������_����CSKU AS CSKU ON CSKU.������������ = Element.������
			LEFT JOIN dbo.t_CSKUElements AS CSKUElements ON CSKUElements.UID_1C = CSKU.CSKU
			LEFT JOIN [uas_central].dbo.����������_���������������� AS MeasuresBase ON MeasuresBase.������ = Element.�����������������������
			WHERE Element.��������� = 1
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
