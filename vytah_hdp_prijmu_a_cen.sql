SELECT 
source_data.YEAR rok,
AVG(source_data.gdp) AS "průměrné gdp",
AVG(source_data.income) AS "průměrný příjem",
AVG(source_data.prices) AS "průměrné ceny potravin",
(100 * (AVG(source_data.gdp) - LAG(AVG(source_data.gdp), 1, 0) OVER (ORDER BY source_data.year)) / AVG(source_data.gdp)) AS "změna HDP oproti předchozímu roku",
(100 * (AVG(source_data.income) - LAG(AVG(source_data.income), 1, 0) OVER (ORDER BY source_data.year)) / AVG(source_data.income)) AS "změna příjmů oproti předchozímu roku",
(100 * (AVG(source_data.prices) - LAG(AVG(source_data.prices), 1, 0) OVER (ORDER BY source_data.year)) / AVG(source_data.prices)) AS "změna cen oproti předchozímu roku"
FROM t_veronika_sustova_project_sql_secondary_final source_data
WHERE abbreviation = 'CZ'
AND source_data.income IS NOT NULL AND source_data.prices IS NOT NULL
GROUP BY source_data.year
ORDER BY source_data.year