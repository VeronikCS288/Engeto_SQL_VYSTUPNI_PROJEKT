/* Výsledek dotazu zobrazuje pro každý rok kategorii potravin s nejnižším nárůstem cen oproti roku předchozímu. */

WITH priceTrend AS (
	SELECT 
	source_data.category_name,
	source_data.year,
	AVG(source_data.price) price,
	LAG(AVG(source_data.price), 1, 0) OVER (PARTITION BY source_data.category_name ORDER BY source_data.year) AS previous_year_price,
	(100 * (AVG(source_data.price) - LAG(AVG(source_data.price), 1, 0) OVER (PARTITION BY source_data.category_name ORDER BY source_data.year)) / AVG(source_data.price)) AS year_difference
	FROM t_veronika_sustova_project_sql_primary_final source_data
	WHERE source_data.category IS NOT NULL
	GROUP BY source_data.year, source_data.category_name
	ORDER BY source_data.category_name, source_data.year
)
SELECT 
YEAR AS rok,
(SELECT category_name FROM priceTrend WHERE YEAR = year AND year_difference = min_diff ORDER BY category_name LIMIT 1) kategorie,
min_diff AS "nárůst"
FROM (
	SELECT 
	year,
	MIN(year_difference) min_diff
	FROM priceTrend
	WHERE year_difference > 0 AND year_difference < 100
	GROUP BY YEAR
) yearly_differences
ORDER BY year
