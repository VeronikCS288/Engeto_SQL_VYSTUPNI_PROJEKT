WITH pricesToIncomeRatio AS (
SELECT 
	source_data.industry_branch_name,
	source_data.year,
	source_data.income,
	source_data.price  AS milk_price,
	bread_data.price  AS bread_price,
	floor(source_data.income / source_data.price) AS milk,
	floor(bread_data.income / bread_data.price) AS bread
	FROM t_veronika_sustova_project_sql_primary_final source_data
	LEFT JOIN t_veronika_sustova_project_sql_primary_final bread_data ON source_data.YEAR = bread_data.YEAR AND source_data.industry_branch_code = bread_data.industry_branch_code AND bread_data.category = 111301
	where source_data.category = 114201
) SELECT 

	pricesToIncomeRatio.industry_branch_name AS "odvětví",
	pricesToIncomeRatio.YEAR AS "rok",
	pricesToIncomeRatio.income AS "příjem",
	pricesToIncomeRatio.milk_price  AS "cena_mléka",
	pricesToIncomeRatio.bread_price AS "cena_chleba",
	pricesToIncomeRatio.milk AS "dostupných_jednotek_mléka",
	pricesToIncomeRatio.bread AS "dostupných_jednotek_chleba"
FROM pricesToIncomeRatio WHERE year IN ( (SELECT MIN(year) FROM pricesToIncomeRatio), (SELECT MAX(year) FROM pricesToIncomeRatio) )