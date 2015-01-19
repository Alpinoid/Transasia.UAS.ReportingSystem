SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('[dbo].[update_CSKUHierarchy]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_CSKUHierarchy]
GO

CREATE PROCEDURE [dbo].[update_CSKUHierarchy]
AS
BEGIN

	MERGE INTO [dbo].[t_CSKUHierarchy] AS ReportingTable
	USING (	
			SELECT
				Parent0.Ссылка AS UID_1C							-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,NULL AS Parent1_Code
				,NULL AS Parent1_Description
				,NULL AS Parent2_Code
				,NULL AS Parent2_Description
				,NULL AS Parent3_Code
				,NULL AS Parent3_Description
				,NULL AS Parent4_Code
				,NULL AS Parent4_Description
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			UNION
			SELECT
				Parent1.Ссылка AS UID_1C							-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,Parent1.Код AS Parent1_Code						-- Код родителя уровень уровень 1
				,Parent1.Наименование AS Parent1_Description		-- Наименование родителя уровень 1
				,NULL AS Parent2_Code
				,NULL AS Parent2_Description
				,NULL AS Parent3_Code
				,NULL AS Parent3_Description
				,NULL AS Parent4_Code
				,NULL AS Parent4_Description
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent1 ON Parent1.Родитель = Parent0.Ссылка AND Parent1.ЭтоГруппа = 0x00
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			UNION
			SELECT
				Parent2.Ссылка AS UID_1C										-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,Parent1.Код AS Parent1_Code						-- Код родителя уровень уровень 1
				,Parent1.Наименование AS Parent1_Description		-- Наименование родителя уровень 1
				,Parent2.Код AS Parent2_Code						-- Код родителя уровень уровень 2
				,Parent2.Наименование AS Parent2_Description		-- Наименование родителя уровень 2
				,NULL AS Parent3_Code
				,NULL AS Parent3_Description
				,NULL AS Parent4_Code
				,NULL AS Parent4_Description
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent1 ON Parent1.Родитель = Parent0.Ссылка AND Parent1.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent2 ON Parent2.Родитель = Parent1.Ссылка AND Parent2.ЭтоГруппа = 0x00
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			UNION
			SELECT
				Parent3.Ссылка AS UID_1C							-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,Parent1.Код AS Parent1_Code						-- Код родителя уровень уровень 1
				,Parent1.Наименование AS Parent1_Description		-- Наименование родителя уровень 1
				,Parent2.Код AS Parent2_Code						-- Код родителя уровень уровень 2
				,Parent2.Наименование AS Parent2_Description		-- Наименование родителя уровень 2
				,Parent3.Код AS Parent3_Code						-- Код родителя уровень уровень 3
				,Parent3.Наименование AS Parent3_Description		-- Наименование родителя уровень 3
				,NULL AS Parent4_Code
				,NULL AS Parent4_Description
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent1 ON Parent1.Родитель = Parent0.Ссылка AND Parent1.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent2 ON Parent2.Родитель = Parent1.Ссылка AND Parent2.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent3 ON Parent3.Родитель = Parent2.Ссылка AND Parent3.ЭтоГруппа = 0x00
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			UNION
			SELECT
				Parent4.Ссылка AS UID_1C							-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,Parent1.Код AS Parent1_Code						-- Код родителя уровень уровень 1
				,Parent1.Наименование AS Parent1_Description		-- Наименование родителя уровень 1
				,Parent2.Код AS Parent2_Code						-- Код родителя уровень уровень 2
				,Parent2.Наименование AS Parent2_Description		-- Наименование родителя уровень 2
				,Parent3.Код AS Parent3_Code						-- Код родителя уровень уровень 3
				,Parent3.Наименование AS Parent3_Description		-- Наименование родителя уровень 3
				,Parent4.Код AS Parent4_Code						-- Код родителя уровень уровень 4
				,Parent4.Наименование AS Parent4_Description		-- Наименование родителя уровень 4
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent1 ON Parent1.Родитель = Parent0.Ссылка AND Parent1.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent2 ON Parent2.Родитель = Parent1.Ссылка AND Parent2.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent3 ON Parent3.Родитель = Parent2.Ссылка AND Parent3.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent4 ON Parent4.Родитель = Parent3.Ссылка AND Parent4.ЭтоГруппа = 0x00
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			UNION
			SELECT
				Parent5.Ссылка AS UID_1C							-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,Parent1.Код AS Parent1_Code						-- Код родителя уровень уровень 1
				,Parent1.Наименование AS Parent1_Description		-- Наименование родителя уровень 1
				,Parent2.Код AS Parent2_Code						-- Код родителя уровень уровень 2
				,Parent2.Наименование AS Parent2_Description		-- Наименование родителя уровень 2
				,Parent3.Код AS Parent3_Code						-- Код родителя уровень уровень 3
				,Parent3.Наименование AS Parent3_Description		-- Наименование родителя уровень 3
				,Parent4.Код AS Parent4_Code						-- Код родителя уровень уровень 4
				,Parent4.Наименование AS Parent4_Description		-- Наименование родителя уровень 4
				,Parent5.Код AS Parent5_Code						-- Код родителя уровень уровень 5
				,Parent5.Наименование AS Parent5_Description		-- Наименование родителя уровень 5
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent1 ON Parent1.Родитель = Parent0.Ссылка AND Parent1.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent2 ON Parent2.Родитель = Parent1.Ссылка AND Parent2.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent3 ON Parent3.Родитель = Parent2.Ссылка AND Parent3.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent4 ON Parent4.Родитель = Parent3.Ссылка AND Parent4.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent5 ON Parent5.Родитель = Parent4.Ссылка AND Parent5.ЭтоГруппа = 0x00
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			UNION
			SELECT
				Parent6.Ссылка AS UID_1C							-- ID иерархии CSKU
				,Parent0.Код AS Parent0_Code						-- Код родителя уровень 0
				,Parent0.Наименование AS Parent0_Description		-- Наименование родителя уровень 0
				,Parent1.Код AS Parent1_Code						-- Код родителя уровень уровень 1
				,Parent1.Наименование AS Parent1_Description		-- Наименование родителя уровень 1
				,Parent2.Код AS Parent2_Code						-- Код родителя уровень уровень 2
				,Parent2.Наименование AS Parent2_Description		-- Наименование родителя уровень 2
				,Parent3.Код AS Parent3_Code						-- Код родителя уровень уровень 3
				,Parent3.Наименование AS Parent3_Description		-- Наименование родителя уровень 3
				,Parent4.Код AS Parent4_Code						-- Код родителя уровень уровень 4
				,Parent4.Наименование AS Parent4_Description		-- Наименование родителя уровень 4
				,Parent5.Код AS Parent5_Code						-- Код родителя уровень уровень 5
				,Parent5.Наименование AS Parent5_Description		-- Наименование родителя уровень 5
				,Parent6.Код AS Parent6_Code						-- Код родителя уровень уровень 6
				,Parent6.Наименование AS Parent6_Description		-- Наименование родителя уровень 6
			FROM [uas_central].dbo.Справочник_CSKU AS Parent0	-- Справочник.Справочник_CSKU
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent1 ON Parent1.Родитель = Parent0.Ссылка AND Parent1.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent2 ON Parent2.Родитель = Parent1.Ссылка AND Parent2.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent3 ON Parent3.Родитель = Parent2.Ссылка AND Parent3.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent4 ON Parent4.Родитель = Parent3.Ссылка AND Parent4.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent5 ON Parent5.Родитель = Parent4.Ссылка AND Parent5.ЭтоГруппа = 0x00
			INNER JOIN [uas_central].dbo.Справочник_CSKU AS Parent6 ON Parent6.Родитель = Parent5.Ссылка AND Parent6.ЭтоГруппа = 0x00
			WHERE Parent0.Родитель = 0x00 AND Parent0.ЭтоГруппа = 0x00
			) AS From_1C
	ON ReportingTable.UID_1C = From_1C.UID_1C
		WHEN MATCHED THEN
			UPDATE
			SET	Parent0_Code = From_1C.Parent0_Code
				,Parent0_Description = From_1C.Parent0_Description
				,Parent1_Code = From_1C.Parent1_Code
				,Parent1_Description = From_1C.Parent1_Description
				,Parent2_Code = From_1C.Parent2_Code
				,Parent2_Description = From_1C.Parent2_Description
				,Parent3_Code = From_1C.Parent3_Code
				,Parent3_Description = From_1C.Parent3_Description
				,Parent4_Code = From_1C.Parent4_Code
				,Parent4_Description = From_1C.Parent4_Description
				,Parent5_Code = From_1C.Parent5_Code
				,Parent5_Description = From_1C.Parent5_Description
				,Parent6_Code = From_1C.Parent6_Code
				,Parent6_Description = From_1C.Parent6_Description
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (	UID_1C
						,Parent0_Code
						,Parent0_Description
						,Parent1_Code
						,Parent1_Description
						,Parent2_Code
						,Parent2_Description
						,Parent3_Code
						,Parent3_Description
						,Parent4_Code
						,Parent4_Description
						,Parent5_Code
						,Parent5_Description
						,Parent6_Code
						,Parent6_Description)
			VALUES (	From_1C.UID_1C
						,From_1C.Parent0_Code
						,From_1C.Parent0_Description
						,From_1C.Parent1_Code
						,From_1C.Parent1_Description
						,From_1C.Parent2_Code
						,From_1C.Parent2_Description
						,From_1C.Parent3_Code
						,From_1C.Parent3_Description
						,From_1C.Parent4_Code
						,From_1C.Parent4_Description
						,From_1C.Parent5_Code
						,From_1C.Parent5_Description
						,From_1C.Parent6_Code
						,From_1C.Parent6_Description);

END
GO
