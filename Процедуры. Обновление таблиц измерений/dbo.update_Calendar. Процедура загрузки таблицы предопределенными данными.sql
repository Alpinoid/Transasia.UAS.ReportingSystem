SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF OBJECT_ID('[dbo].[update_Calendar]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[update_Calendar]
GO

CREATE PROCEDURE [dbo].[update_Calendar] 

AS
BEGIN

WITH Calendar AS 
(
SELECT
	CAST('2013-12-31' as date) AS [Date]
UNION ALL
SELECT
	DATEADD(DAY, 1, [Date])
FROM Calendar
WHERE [Date] <= CAST('2016-12-31' as date)
)
MERGE INTO dbo.t_Calendar AS Target
USING (
	SELECT
		CAST(CONVERT(varchar(8), [Date] ,112) AS int) AS [DateID]
		,[Date] AS [Date]
		,DATENAME(year, [Date]) AS [Year]
		,DATENAME(quarter, [Date]) AS [Quarter]
		,DATENAME(quarter, [Date])+' квартал' AS [NameQuarter]
		,DATEPART(month, [Date]) AS [Month]
		,DATENAME(month, [Date]) AS [NameOfMonth]
		,DATENAME(week, [Date]) AS [Week]
		,DATENAME(dayofyear, [Date]) AS [DayOfYear]
		,DATENAME(day, [Date]) AS [DayOfMonth]
		,DATEPART(weekday, [Date]) AS [Weekday]
		,DATENAME(weekday, [Date]) AS [WeekdayName]
		,LEFT(DATENAME(month, DATEADD(month, -2, [Date])), 1) + LEFT(DATENAME(month, DATEADD(month, -1, [Date])), 1) + LEFT(DATENAME(month, [Date]), 1) AS [CurrentMonthAndTwoPrevious]
	FROM Calendar
) AS CalendarSorce
ON Target.[Date] = CalendarSorce.[Date]
WHEN MATCHED THEN
	UPDATE SET
		[DateID] = CalendarSorce.[DateID]
		,[Date] = CalendarSorce.[Date]
		,[Year] = CalendarSorce.[Year]
		,[Quarter] = CalendarSorce.[Quarter]
		,[NameQuarter] = CalendarSorce.[NameQuarter]
		,[Month] = CalendarSorce.[Month]
		,[NameOfMonth] = CalendarSorce.[NameOfMonth]
		,[Week] = CalendarSorce.[Week]
		,[DayOfYear] = CalendarSorce.[DayOfYear]
		,[DayOfMonth] = CalendarSorce.[DayOfMonth]
		,[Weekday] = CalendarSorce.[Weekday]
		,[WeekdayName] = CalendarSorce.[WeekdayName]
		,[CurrentMonthAndTwoPrevious] = CalendarSorce.[CurrentMonthAndTwoPrevious]
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		[DateID]
		,[Date]
		,[Year]
		,[Quarter]
		,[NameQuarter]
		,[Month]
		,[NameOfMonth]
		,[Week]
		,[DayOfYear]
		,[DayOfMonth]
		,[Weekday]
		,[WeekdayName]
		,[CurrentMonthAndTwoPrevious])
	VALUES (
		CalendarSorce.[DateID]
		,CalendarSorce.[Date]
		,CalendarSorce.[Year]
		,CalendarSorce.[Quarter]
		,CalendarSorce.[NameQuarter]
		,CalendarSorce.[Month]
		,CalendarSorce.[NameOfMonth]
		,CalendarSorce.[Week]
		,CalendarSorce.[DayOfYear]
		,CalendarSorce.[DayOfMonth]
		,CalendarSorce.[Weekday]
		,CalendarSorce.[WeekdayName]
		,CalendarSorce.[CurrentMonthAndTwoPrevious])
OPTION (MAXRECURSION 7300);

END
