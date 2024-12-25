-- dulezity je, ze specifikovali, ze chteji narust

WITH pricesToPaychecksRatioTrend AS (
	SELECT 
	source_data.year,
	AVG(source_data.price) price,
	AVG(source_data.income) income,
	LAG(AVG(source_data.price), 1, 0) OVER (ORDER BY source_data.year) AS previous_year_price,
	LAG(AVG(source_data.income), 1, 0) OVER (ORDER BY source_data.year) AS previous_year_income,
	(100 * (AVG(source_data.price) - LAG(AVG(source_data.price), 1, 0) OVER (ORDER BY source_data.year)) / AVG(source_data.price)) AS price_year_difference,
	(100 * (AVG(source_data.income) - LAG(AVG(source_data.income), 1, 0) OVER (ORDER BY source_data.year)) / AVG(source_data.income)) AS income_year_difference
	FROM t_veronika_sustova_project_sql_primary_final source_data
	WHERE source_data.category IS NOT NULL
	GROUP BY source_data.year
	ORDER BY source_data.year
)
SELECT *, (price_year_difference - income_year_difference) > 10 "výrazný nárůst"  FROM pricesToPaychecksRatioTrend 