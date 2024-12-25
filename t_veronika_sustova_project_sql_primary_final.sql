/*
DROP TABLE IF EXISTS zaručuje, že script lze bez chyby spustit i v případě, že tabulka již existuje.


Script vytvoří tabulku, která obsahuje záznam pro každou kombinaci roku, příjmů v jednotlivých odvětvích a cen jednotlivých kategorií potravin. 

Data se načítají primárně z tabulky příjmů, která obsahuje větší data pro větší časové rozmezí. Pro každý rok se z průměrné kvartální mzdy vypočítá průměrná roční mzda v jednotlivých odvětvích.
Následně se napojí dle roku data z tabulky cen potravin. Tímto joinem vzytvoříme záznam pro každou možnou kombinaci dat se kterou potřebujeme v rámci výstupních SQL scriptů pracovat.
*/

DROP TABLE IF EXISTS t_veronika_sustova_project_sql_primary_final;

CREATE TABLE t_veronika_sustova_project_sql_primary_final as
SELECT 
yearly_income_data.YEAR,
yearly_income_data.industry_branch_code,
industry_branches.name AS industry_branch_name,
yearly_income_data.income,
prices.category AS category,
price_categories.name AS category_name,
prices.price
FROM 
(
SELECT 
	payroll.payroll_year AS year, 
	payroll.industry_branch_code, 
	sum(payroll.value * 3) AS income
	FROM czechia_payroll payroll
	WHERE payroll.value IS NOT NULL 
	AND payroll.industry_branch_code IS NOT NULL 
	AND value_type_code = 5958 
	AND calculation_code = 200
	GROUP BY payroll_year, industry_branch_code
) AS yearly_income_data 
LEFT JOIN 
(
	
	SELECT 
	prices.category_code AS category,
	avg(prices.value) AS price,
	date_part('year', prices.date_from) AS year
	FROM czechia_price prices
	WHERE prices.region_code IS NOT NULL AND prices.value IS NOT NULL 
	GROUP BY date_part('year', prices.date_from), prices.category_code
) AS prices ON prices.year = yearly_income_data.YEAR
LEFT JOIN czechia_payroll_industry_branch industry_branches ON yearly_income_data.industry_branch_code = industry_branches.code
LEFT JOIN czechia_price_category price_categories ON prices.category = price_categories.code
WHERE yearly_income_data.YEAR IS NOT NULL
ORDER BY yearly_income_data.YEAR, prices.category, yearly_income_data.industry_branch_code;
