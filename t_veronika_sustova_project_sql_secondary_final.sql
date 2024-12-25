/*
DROP TABLE IF EXISTS zaručuje, že script lze bez chyby spustit i v případě, že tabulka již existuje.


Script vytvoří tabulku, která obsahuje záznam pro každou kombinaci roku a HDP jednotlivých zemí.

Data se načítají primárně z tabulky zemí, do které se napojí informace o HDP z tabulky economies a následně se doplní o data o mzdách a průměrných cenách potravin v rámci každého roku.
*/

DROP TABLE IF EXISTS t_veronika_sustova_project_sql_secondary_final;

CREATE TABLE t_veronika_sustova_project_sql_secondary_final as
SELECT economies.YEAR, countries.abbreviation, countries.country, economies.gdp, cz_yearly_averages.income, cz_yearly_averages.prices
FROM countries
LEFT JOIN economies ON countries.country  = economies.country 
LEFT JOIN (
	SELECT AVG(income) income, avg(price) prices, year FROM t_veronika_sustova_project_sql_primary_final tvspspf	
	GROUP BY year
) cz_yearly_averages ON cz_yearly_averages.YEAR = economies.YEAR AND countries.abbreviation = 'CZ'
WHERE gdp IS NOT NULL
ORDER BY abbreviation, YEAR
