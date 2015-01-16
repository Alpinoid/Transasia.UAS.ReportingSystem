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
				Parent0.������ AS UID_1C							-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
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
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
			UNION
			SELECT
				Parent1.������ AS UID_1C							-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
				,Parent1.��� AS Parent1_Code						-- ��� �������� ������� ������� 1
				,Parent1.������������ AS Parent1_Description		-- ������������ �������� ������� 1
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
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent1 ON Parent1.�������� = Parent0.������ AND Parent1.��������� = 0x00
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
			UNION
			SELECT
				Parent2.������ AS UID_1C										-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
				,Parent1.��� AS Parent1_Code						-- ��� �������� ������� ������� 1
				,Parent1.������������ AS Parent1_Description		-- ������������ �������� ������� 1
				,Parent2.��� AS Parent2_Code						-- ��� �������� ������� ������� 2
				,Parent2.������������ AS Parent2_Description		-- ������������ �������� ������� 2
				,NULL AS Parent3_Code
				,NULL AS Parent3_Description
				,NULL AS Parent4_Code
				,NULL AS Parent4_Description
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent1 ON Parent1.�������� = Parent0.������ AND Parent1.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent2 ON Parent2.�������� = Parent1.������ AND Parent2.��������� = 0x00
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
			UNION
			SELECT
				Parent3.������ AS UID_1C							-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
				,Parent1.��� AS Parent1_Code						-- ��� �������� ������� ������� 1
				,Parent1.������������ AS Parent1_Description		-- ������������ �������� ������� 1
				,Parent2.��� AS Parent2_Code						-- ��� �������� ������� ������� 2
				,Parent2.������������ AS Parent2_Description		-- ������������ �������� ������� 2
				,Parent3.��� AS Parent3_Code						-- ��� �������� ������� ������� 3
				,Parent3.������������ AS Parent3_Description		-- ������������ �������� ������� 3
				,NULL AS Parent4_Code
				,NULL AS Parent4_Description
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent1 ON Parent1.�������� = Parent0.������ AND Parent1.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent2 ON Parent2.�������� = Parent1.������ AND Parent2.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent3 ON Parent3.�������� = Parent2.������ AND Parent3.��������� = 0x00
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
			UNION
			SELECT
				Parent4.������ AS UID_1C							-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
				,Parent1.��� AS Parent1_Code						-- ��� �������� ������� ������� 1
				,Parent1.������������ AS Parent1_Description		-- ������������ �������� ������� 1
				,Parent2.��� AS Parent2_Code						-- ��� �������� ������� ������� 2
				,Parent2.������������ AS Parent2_Description		-- ������������ �������� ������� 2
				,Parent3.��� AS Parent3_Code						-- ��� �������� ������� ������� 3
				,Parent3.������������ AS Parent3_Description		-- ������������ �������� ������� 3
				,Parent4.��� AS Parent4_Code						-- ��� �������� ������� ������� 4
				,Parent4.������������ AS Parent4_Description		-- ������������ �������� ������� 4
				,NULL AS Parent5_Code
				,NULL AS Parent5_Description
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent1 ON Parent1.�������� = Parent0.������ AND Parent1.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent2 ON Parent2.�������� = Parent1.������ AND Parent2.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent3 ON Parent3.�������� = Parent2.������ AND Parent3.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent4 ON Parent4.�������� = Parent3.������ AND Parent4.��������� = 0x00
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
			UNION
			SELECT
				Parent5.������ AS UID_1C							-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
				,Parent1.��� AS Parent1_Code						-- ��� �������� ������� ������� 1
				,Parent1.������������ AS Parent1_Description		-- ������������ �������� ������� 1
				,Parent2.��� AS Parent2_Code						-- ��� �������� ������� ������� 2
				,Parent2.������������ AS Parent2_Description		-- ������������ �������� ������� 2
				,Parent3.��� AS Parent3_Code						-- ��� �������� ������� ������� 3
				,Parent3.������������ AS Parent3_Description		-- ������������ �������� ������� 3
				,Parent4.��� AS Parent4_Code						-- ��� �������� ������� ������� 4
				,Parent4.������������ AS Parent4_Description		-- ������������ �������� ������� 4
				,Parent5.��� AS Parent5_Code						-- ��� �������� ������� ������� 5
				,Parent5.������������ AS Parent5_Description		-- ������������ �������� ������� 5
				,NULL AS Parent6_Code
				,NULL AS Parent6_Description
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent1 ON Parent1.�������� = Parent0.������ AND Parent1.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent2 ON Parent2.�������� = Parent1.������ AND Parent2.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent3 ON Parent3.�������� = Parent2.������ AND Parent3.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent4 ON Parent4.�������� = Parent3.������ AND Parent4.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent5 ON Parent5.�������� = Parent4.������ AND Parent5.��������� = 0x00
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
			UNION
			SELECT
				Parent6.������ AS UID_1C							-- ID �������� CSKU
				,Parent0.��� AS Parent0_Code						-- ��� �������� ������� 0
				,Parent0.������������ AS Parent0_Description		-- ������������ �������� ������� 0
				,Parent1.��� AS Parent1_Code						-- ��� �������� ������� ������� 1
				,Parent1.������������ AS Parent1_Description		-- ������������ �������� ������� 1
				,Parent2.��� AS Parent2_Code						-- ��� �������� ������� ������� 2
				,Parent2.������������ AS Parent2_Description		-- ������������ �������� ������� 2
				,Parent3.��� AS Parent3_Code						-- ��� �������� ������� ������� 3
				,Parent3.������������ AS Parent3_Description		-- ������������ �������� ������� 3
				,Parent4.��� AS Parent4_Code						-- ��� �������� ������� ������� 4
				,Parent4.������������ AS Parent4_Description		-- ������������ �������� ������� 4
				,Parent5.��� AS Parent5_Code						-- ��� �������� ������� ������� 5
				,Parent5.������������ AS Parent5_Description		-- ������������ �������� ������� 5
				,Parent6.��� AS Parent6_Code						-- ��� �������� ������� ������� 6
				,Parent6.������������ AS Parent6_Description		-- ������������ �������� ������� 6
			FROM [uas_central].dbo.����������_CSKU AS Parent0	-- ����������.����������_CSKU
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent1 ON Parent1.�������� = Parent0.������ AND Parent1.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent2 ON Parent2.�������� = Parent1.������ AND Parent2.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent3 ON Parent3.�������� = Parent2.������ AND Parent3.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent4 ON Parent4.�������� = Parent3.������ AND Parent4.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent5 ON Parent5.�������� = Parent4.������ AND Parent5.��������� = 0x00
			INNER JOIN [uas_central].dbo.����������_CSKU AS Parent6 ON Parent6.�������� = Parent5.������ AND Parent6.��������� = 0x00
			WHERE Parent0.�������� = 0x00 AND Parent0.��������� = 0x00
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
