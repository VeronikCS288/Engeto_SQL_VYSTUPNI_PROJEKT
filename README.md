Průvodní listina k projektu Engeto_SQL_VYSTUPNI_PROJEKT

Projekt obsahuje 2 sql soubory, pomocí kterých se vytváří pomocné tabulky pro 5 výstupních sql scriptů.

Pomocné tabulky:

  - Tabulka t_veronika_sustova_project_sql_primary_final obsahuje záznam pro každou kombinaci roku, příjmů v jednotlivých odvětvích a cen jednotlivých kategorií potravin
  - Tabulka t_veronika_sustova_project_sql_secondary_final obsahuje záznam pro každou kombinaci roku a HDP jednotlivých zemí

Výstupní scripty:

Každý ze scriptů odpovídá na otázku ze zadání projektu. Dotazy v rámci WITH klauzulí obsahují pomocné sloupce, které nejsou relevantní v končeném výsledku scriptu, ale umožňují rozšířený náhled do zpracovaných zdrojových dat. V rámci klauzulí WITH se také často používá funkce LAG, která umožňuje nahédnout v rámci každé skupiny
na předchozí řádek dle zadaného řazení a offsetu.

  - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? (narust_pokles_mezd.sql)
  Ve scriptu se připraví data pomocí funkce WITH tak, aby každý řádek obsahoval kód odvětví, rok, průměrnou mzdu v daném roce a průměrnou mzdu v předchozím roce. Data jsou seskupena dle roku a odvětví kvůli tomu, že zdrojová tabulka obsahuje také data o cenách produktů, což by nám výstupní data v tomto případě duplikovalo.
  Při zobrazování výsledku se následně na každý řádek doplní textový výstup porovnání mzdy aktuálního a předchozího roku.
  
  - Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? (dostupnost_mleka_a_chleba.sql)
  Ve scriptu se připraví data pomocí funkce WITH tak, aby každý řádek obsahoval kód odvětví, rok, průměrnou mzdu v daném roce, cenu mléka, cenu chleba, dostupné jednotky mléka a dostupné jednotky chleba. Funkce floor zajistí, že výsledek je zaokrouhlený vždy směrem dolů, protože lze vždy koupit pouze celé jednotky.
  Při zobrazování výsledků ještě zaručíme, že se zobrazí data pouze pro první a poslední rok s dostupnými daty.
    
  - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? (nejpomalejsi_mezirocni_narust.sql)
  Ve scriptu se připraví data pomocí funkce WITH tak, aby každý řádek obsahoval kategorii produktu, rok, cenu v daném roce, cenu v předchozím roce a procentuální rozdíl aktuální ceny a ceny v předchozím roce. Při zobrazování výsledků si subselectem načteme ke každému roku minimální nárůst ceny a následně dle těchto hodnot načteme z tabulky první kategorii,
  která hodnotám odpovídá. Poklesy cen jsou ignorované.
  
    
  - Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? (vztah_rustu_cen_a_mezd.sql)
  Ve scriptu se připraví data pomocí funkce WITH tak, aby každý řádek obsahoval rok, cenu, mzdu, cenu v předchozím roce, mzdu v předchozím roce, rozdíl ceny v aktuálním roce a ceny v předchozím roce a rozdíl mzdy v aktuálním roce a mzdy v předchozím roce.
  Při zobrazování výsledku se navíc oproti zpracovaným zdrojovým datům do dynamicky vytvořeného sloupce zapíše, zda došlo k nárůstu cen oproti mzdě o více jak 10 procent.

    
  - Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
  Script načítá do každého řádku rok, průměrné gdp, průměrný příjem, průměrné ceny potravin. Pro HDP, příjem a cenu také vytvoří dynamický sloupec obsahující procentuální změnu oproti předchozímu roku.
