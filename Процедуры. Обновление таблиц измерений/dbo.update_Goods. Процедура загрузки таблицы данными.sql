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
				Element.������ AS UID_1C																-- UID ������������
				,ISNULL(Element.��������, 0) AS UID_Parent_1C											-- UID ��������
				,ISNULL(Element.�������, '') AS Article													-- �������
				,Element.������������ AS Description													-- ������������
				,ISNULL(Element.�������, '')  + ': ' + Element.������������ AS ArticleDescription		-- �������: ������������
				,Element.������������ + ' (' + ISNULL(Element.�������, '')  + ')' AS DescriptionArticle	-- ������������ (�������)
				,CSKU.ID AS CSKU_ID																-- ID CSKU
				,Brands.ID AS BrandID																	-- ID ������
				,ISNULL (
						(	SELECT TOP 1
								IIF(PATINDEX('%[%]%',VATValue.�������) = 0, 0, LEFT(VATValue.�������, PATINDEX('%[%]%',VATValue.�������)-1))
							FROM [uas_central].dbo.���������������_���������
							LEFT JOIN [uas_central].dbo.������������_��������� AS VATValue ON VATValue.�������� = [uas_central].dbo.���������������_���������.���
							WHERE [uas_central].dbo.���������������_���������.������������ = Element.������
							ORDER BY [uas_central].dbo.���������������_���������._������ DESC)
						, 0) AS VAT																		-- ����� ���
				,MeasuresBase.������ AS MeasuresBaseUID_1C												-- ID � 1� ������� ������� ���������
				,ISNULL(Element.MSU, 0) AS MSU															-- SU ������
				,Bussiness.ID  AS BusinessID															-- ID ����������� �������
				,ISNULL ((
							SELECT TOP 1
								IIF(MeasuresUnit.����������� = 0, 1, MeasuresUnit.�����������) AS �����������
							FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
							INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																								AND Class.��� = '796'	-- [��]
							WHERE MeasuresUnit.�������� = Element.������), 1) AS FactorUnit				-- ����������� ��������� � �����
				,ISNULL ((
							SELECT TOP 1
								IIF(MeasuresUnit.����������� = 0, 1, MeasuresUnit.�����������) AS �����������
							FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
							INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																								AND Class.��� = '384'	-- [���]
							WHERE MeasuresUnit.�������� = Element.������), 1) AS FactorBox				-- ����������� ��������� � �������
				,ISNULL ((
							SELECT TOP 1
								IIF(MeasuresUnit.����������� = 0, 1, MeasuresUnit.�����������) AS �����������
							FROM [uas_central].dbo.����������_���������������� AS MeasuresUnit
							INNER JOIN [uas_central].dbo.����������_���������������������������� AS Class ON MeasuresUnit.�������������� = Class.������
																								AND Class.��� = '888'	-- [��]
							WHERE MeasuresUnit.�������� = Element.������), 1) AS FactorPack				-- ����������� ��������� � ��������
			FROM [uas_central].dbo.����������_������������ AS Element		-- ����������.������������
			LEFT JOIN dbo.t_Business AS Bussiness ON Bussiness.UID_1C = Element.������������������
			LEFT JOIN dbo.t_Brands AS Brands ON Brands.UID_1C = Element.�����
			LEFT JOIN uas_central.dbo.���������������_����CSKU AS ����CSKU ON ����CSKU.������������ = Element.������
			LEFT JOIN dbo.t_CSKU AS CSKU ON CSKU.UID_1C = ����CSKU.CSKU
			LEFT JOIN [uas_central].dbo.����������_���������������� AS MeasuresBase ON MeasuresBase.������ = Element.�����������������������
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
