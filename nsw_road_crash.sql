USE nsw_crash;

SELECT * FROM nsw_crash_data_clean;

-- Yearly trends in crash data

SELECT year_of_crash, COUNT(*) 
FROM nsw_crash_data_clean
GROUP BY year_of_crash
ORDER BY year_of_crash;

-- Monthly trends in crash data

SELECT crash_date, COUNT(*) AS 'No. of Crashes'
FROM nsw_crash_data_clean
GROUP BY crash_date
ORDER BY crash_date;

-- Most crash occurred in two-hours interval

SELECT two_hour_intervals, COUNT(*) AS 'No. of Crashes'
FROM nsw_crash_data_clean
GROUP BY two_hour_intervals
ORDER BY COUNT(*) DESC;

SELECT * FROM nsw_crash_data_clean;

-- LGAs with highest average number of injuries per crash

WITH CTE as (
	SELECT lga,
	AVG(CAST(no_killed+no_seriously_injured+no_moderately_injured+no_minor_other_injured AS FLOAT)) AS avg_injuries,
	SUM(no_killed+no_seriously_injured+no_moderately_injured+no_minor_other_injured) AS total_injuries
	FROM nsw_crash_data_clean
	GROUP BY lga
)
SELECT lga, total_injuries, avg_injuries
FROM CTE
ORDER BY avg_injuries DESC;

-- Weekday with highest average injuries in serious/fatal crashes

WITH CTE as (
	SELECT day_of_week_of_crash,
	AVG(CAST(no_killed+no_seriously_injured+no_moderately_injured+no_minor_other_injured AS FLOAT)) AS avg_injuries,
	COUNT(*) AS total_crash
	FROM nsw_crash_data_clean
	WHERE degree_of_crash = 'Serious Injury' OR degree_of_crash = 'Fatal'
	GROUP BY day_of_week_of_crash
)
SELECT day_of_week_of_crash, total_crash, avg_injuries
FROM CTE
ORDER BY avg_injuries DESC;

-- Number of crashes when school zone is active and inactive in school zone locations

SELECT 
	school_zone_active,
	SUM(no_killed+no_seriously_injured+no_moderately_injured+no_minor_other_injured) AS total_injuries,
	COUNT(*) AS total_crash
FROM nsw_crash_data_clean
WHERE school_zone_location = 'Yes'
GROUP BY school_zone_active;

-- Year-Over-Year Percentage changes in crashes in LGA 

DECLARE @cols AS NVARCHAR(MAX), @query  AS NVARCHAR(MAX);

SELECT @cols = STRING_AGG(QUOTENAME(year_of_crash), ', ')
FROM (SELECT DISTINCT year_of_crash FROM nsw_crash_data_clean) AS years;

SET @query = 
'WITH CTE AS (
SELECT lga,'+@cols+
'FROM (
	SELECT lga, crash_id, year_of_crash FROM nsw_crash_data_clean
) AS Source
PIVOT (
	COUNT(crash_id)
	FOR year_of_crash IN ('+@cols+')
) AS PvtTable
)
SELECT 
	lga,
	NULL AS [2019 %Change],
	ISNULL(ROUND(CAST([2020] - [2019] AS FLOAT) / NULLIF([2019], 0) * 100, 2), 100) AS [2020 %Change],
	ISNULL(ROUND(CAST([2021] - [2020] AS FLOAT) / NULLIF([2020], 0) * 100, 2), 100) AS [2021 %Change],
	ISNULL(ROUND(CAST([2022] - [2021] AS FLOAT) / NULLIF([2021], 0) * 100, 2), 100) AS [2022 %Change],
	ISNULL(ROUND(CAST([2023] - [2022] AS FLOAT) / NULLIF([2022], 0) * 100, 2), 100) AS [2023 %Change]
FROM CTE';

execute(@query);

SELECT TOP 5 street_of_crash, COUNT(*) 
FROM nsw_crash_data_clean
GROUP BY street_of_crash
ORDER BY COUNT(*) DESC;







