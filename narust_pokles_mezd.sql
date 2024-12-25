WITH paycheckTrend AS (
	SELECT 
	source_data.industry_branch_code,
	source_data.year,
	AVG(source_data.income) paycheck_avg,
	LAG(AVG(source_data.income), 1, 0) OVER (PARTITION BY source_data.industry_branch_code ORDER BY source_data.year) AS previous_year_paycheck
	FROM t_veronika_sustova_project_sql_primary_final source_data
	GROUP BY source_data.year, source_data.industry_branch_code
	ORDER BY source_data.year, source_data.industry_branch_code
)
SELECT 
	industry_branch_code AS kod_odvetvi,
	year AS rok,
	paycheck_avg AS prumer_daneho_roku,
	previous_year_paycheck AS  prumer_predchoziho_roku,
	CASE WHEN paycheck_avg > previous_year_paycheck THEN 'narust' WHEN paycheck_avg < previous_year_paycheck THEN 'pokles' ELSE 'beze zmeny' end
	FROM paycheckTrend
	ORDER BY industry_branch_code, year;
