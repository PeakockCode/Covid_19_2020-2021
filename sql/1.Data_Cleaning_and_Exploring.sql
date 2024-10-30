-- Covid 19 Data Vizualization and Exploration Project 
-- Part 1: Exploration
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types and some cleaning and standardizing skills


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ##COVID DEATHS TABLE##
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) DATA CLEANING, STANDARDIZING AND DEAL WITH NULL VALUES 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Because this is mainly exploration project (all vizualizations going to be done in Tableau) we are going to deal just some main issues like standardizing some data and dealing with blank values

-- a) DATA TYPE ISSUES

-- population data type issue - change real to BIGINT
UPDATE Covid_analyse..CovidDeaths
SET population = CAST(population AS BIGINT);
ALTER TABLE Covid_analyse..CovidDeaths
ALTER COLUMN population BIGINT;

-- total_cases data type issue - change real to BIGINT
UPDATE Covid_analyse..CovidDeaths
SET total_cases = CAST(total_cases AS BIGINT);
ALTER TABLE Covid_analyse..CovidDeaths
ALTER COLUMN total_cases BIGINT;

-- b) BLANK VALUES AND ZERO ISSUE - SET ALL TO NULL VALUE TO PREVENT ERRORS

-- continent
UPDATE Covid_analyse..CovidDeaths
SET continent = NULL
WHERE continent = '';

-- population
UPDATE Covid_analyse..CovidDeaths
SET population = NULL
WHERE population = ''  OR population = 0;

-- total_deaths
UPDATE Covid_analyse..CovidDeaths
SET total_deaths = NULL
WHERE total_deaths = '' OR total_deaths = 0;

-- new_cases
UPDATE Covid_analyse..CovidDeaths
SET new_cases = NULL
WHERE new_cases = '' OR new_cases = 0;

-- new_deaths
UPDATE Covid_analyse..CovidDeaths
SET new_deaths = NULL
WHERE new_deaths = '' OR new_deaths = 0;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2 ) DATA EXPLORATION
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Basic queries to check the data
-- Table 1
SELECT *
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4;

-- Table 2
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1,2;


---------------------------------------------------------------------------------------------------------------------------------------
-- Covid in USA, Europe and in the Czech Republic
---------------------------------------------------------------------------------------------------------------------------------------



-- Total deaths vs total cases
  -----------------------------

-- The probability of death upon contracting COVID-19 in USA
-- Table 3
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%states%'
-- AND continent IS NOT NULL
ORDER BY 2;

-- The probability of death upon contracting COVID-19 in the Czech Republic
-- Table 4
SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%czech%'
-- AND continent IS NOT NULL
ORDER BY 2;

-- Max death percentage in the Czech Republic because of covid between focused years (2020 - 2021) in the Czech Republic
-- Table 5
WITH death_percentage AS
(
SELECT location, date, total_cases,total_deaths, ((total_deaths/total_cases)*100)  AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%czech%'
)
SELECT MAX(Death_Percentage) AS Max_Death_Percentage
FROM death_percentage;

-- Worst 10 days because of covid during covid times (highest percentage of death based on covid 19) in the Czech Republic
-- Table 6
SELECT TOP 10 date, total_cases,total_deaths, ((total_deaths/total_cases)*100)  AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%czech%'
ORDER BY Death_Percentage DESC;


-- The probability of death upon contracting COVID-19 in European Unino
-- Table 7
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%european%'
ORDER BY 2;

-- Worst 10 days because of covid during covid times (highest percentage of death based on covid 19) in European Union
-- Table 8
SELECT TOP 10 date, total_cases,total_deaths, ((total_deaths/total_cases)*100)  AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%european%'
ORDER BY Death_Percentage DESC;


-- Worst 10 days because of covid during covid times (highest percentage of death based on covid 19) in USA
-- Table 9
SELECT date, total_cases,total_deaths, ((total_deaths/total_cases)*100)  AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY Death_Percentage DESC;

--> Worst 10 days because of covid during covid times (highest percentage of death based on covid 19) in USA 
-- (Skipped the first 4 rows to show better results – the number of infected persons was too low in the first few days, which led to misrepresented results in previous query)
-- Table 10
SELECT date, total_cases,total_deaths, ((total_deaths/total_cases)*100)  AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY Death_Percentage DESC
OFFSET 4 ROWS FETCH NEXT 10 ROWS ONLY;

-- Total Cases vs Population
  ---------------------------

-- Percentage of population infected with COVID-19 in USA
-- Table 11
SELECT location, date, population, total_cases,  (CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS Percentage_Of_Infected_Population
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2;

-- Percentage of population infected with COVID-19 in the Czech Republic - The rapid increase in the percentage of infected individuals after reaching one percent on October 9, 2020, is interesting.
-- Table 12
SELECT location, date, population, total_cases,  (CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS Percentage_Of_Infected_Population
FROM Covid_analyse..CovidDeaths
WHERE location LIKE '%czech%'
ORDER BY 1,2;

-- Maximum percentage of the population infected with COVID-19 divided by continents (Note: I don't think the data for Asia, especially China, are accurate).
-- Table 13
SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 as Percentage_Of_Infected_Population
FROM Covid_analyse..CovidDeaths
WHERE continent IS NULL
GROUP BY location, population
ORDER BY 1,2;

-- Highest infection rate of the data set compared to population of countries/unions/continents 
-- Max Percentage of infected population from dataset -> 1) Andorra, 2) Montenegro, 3) The Czech Republic
-- Max Percentage of infected population of the big countries -> 1) United States!
-- Table 14
SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 as Percentage_Of_Infected_Population
FROM Covid_analyse..CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC;

-- Continents with Highest Death Count per Population
-- query 1 for All Continents and European union with Highest Death Count per Population
-- Table 15
SELECT location, MAX(total_deaths) as Total_Death_Count
FROM Covid_analyse..CovidDeaths
GROUP BY location, continent
HAVING continent IS NULL
ORDER BY 2 DESC;
-- query 2 for All Continents and European union with Highest Death Count per Population - just different query to reach the same goal like query above
-- Table 16
SELECT location, MAX(total_deaths) as Total_Death_Count
FROM Covid_analyse..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY 2 DESC;

-- query 3 - Sum of the  Death Count for All Continents (without EU or other non valid informations to this comparison)
-- Table 17
SELECT continent,  SUM(new_deaths) AS Sum_Deaths
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

-- TOP 10 Countries with Highest Death Count per Population
-- Table 18
SELECT TOP 10 location, MAX(total_deaths) as Total_Death_Count
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC;


-- Global Numbers
  ----------------

-- Data across the world about new cases vs new deaths to compare the timeline
-- Table 19
SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- Sum of the data across the world about new cases vs new deaths to see total cases vs total deaths as the death percentage
-- Table 20
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS INT)) AS Total_Deaths, (SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS Death_Percentage
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Adding ##COVID VACCINATIONS TABLE##
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Checked the data at first to realize if there are similar issues like in the COVID DEATHS TABLE  - same string and nulls problem with new test, total test, etc. 

SELECT * 
FROM Covid_analyse..CovidVaccinations;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1) DATA CLEANING, STANDARDIZING AND DEAL WITH NULL VALUES 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- BLANK VALUES AND ZERO ISSUE - SET ALL TO NULL VALUE TO PREVENT ERRORS

-- continent
UPDATE Covid_analyse..CovidVaccinations
SET continent = NULL
WHERE continent = '';

-- new_tests
UPDATE Covid_analyse..CovidVaccinations
SET new_tests = NULL
WHERE new_tests = '' OR  new_tests = 0;

-- total_tests
UPDATE Covid_analyse..CovidVaccinations
SET total_tests = NULL
WHERE total_tests = '' OR  new_tests = 0;

-- people_fully_vaccinated
UPDATE Covid_analyse..CovidVaccinations
SET people_fully_vaccinated = NULL
WHERE people_fully_vaccinated = '' OR  people_fully_vaccinated = 0;

-- More columns to edit at the same time/simultaneously (code in transaction due to complexity)
-- total_tests_per_thousand, new_vaccinations, total_vaccinations
BEGIN TRANSACTION;

UPDATE Covid_analyse..CovidVaccinations
SET 
	total_tests_per_thousand =	CASE
						WHEN total_tests_per_thousand = '' OR total_tests_per_thousand = 0 THEN NULL
						ELSE total_tests_per_thousand
					END,

	new_vaccinations =		CASE
						WHEN new_vaccinations = '' OR new_vaccinations = 0 THEN NULL
						ELSE new_vaccinations
					END,

	total_vaccinations =		CASE
						WHEN total_vaccinations = '' OR new_vaccinations = 0 THEN NULL
						ELSE total_vaccinations
					END
WHERE
	total_tests_per_thousand = '' OR total_tests_per_thousand = 0
	OR new_vaccinations = '' OR new_vaccinations = 0
	OR total_vaccinations = '' OR total_vaccinations = 0;

COMMIT;


-- Vaccinations vs Population
  ----------------------------

-- code to show population vs new vaccinations devided by time and location based on join between both tables
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, 
vacc.new_vaccinations
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
ORDER BY 2, 3;


-- Rolling Sum to show population vs new vaccinations vs total_vaccinations by date and location
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, 
vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date) AS rolling_total_vaccinations,
(SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date)/deaths.population * 100) AS percentage_of_vaccinated
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
ORDER BY 2, 3;


-- Rolling Sum to show population vs new vaccinations and total_vaccinations by date for the Czech Republic
-- Table 21
SELECT deaths.location, deaths.date, deaths.population, 
vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date) AS rolling_total_vaccinations
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
AND deaths.location LIKE '%Czech%'
ORDER BY 2, 3;



-- CTE to find percentage of total vaccinated in population over the world

WITH CTE_rolling_numbers (Continent, Location, Date, Population, New_Vaccinations, Total_Vaccinations) AS
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, 
vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date)
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
)
SELECT *,
((CAST(Total_Vaccinations AS FLOAT)/CAST(Population AS FLOAT))*100) AS Percentage_of_Vaccinated
FROM CTE_rolling_numbers
;


-- 2. CTE to find percentage of total vaccinated in population of the Czech Republic
-- Table 22
WITH CTE_rolling_numbers (Continent, Location, Date, Population, New_Vaccinations, Total_Vaccinations) AS
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, 
vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.date)
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
)
SELECT *,
((CAST(Total_Vaccinations AS FLOAT)/CAST(Population AS FLOAT))*100) AS Percentage_of_Vaccinated
FROM CTE_rolling_numbers
WHERE Location LIKE '%Czech%'
;

-- 3. CTE to find max percentage of vaccinated by country (over the world) - I actually used column with Fully Vaccinated people to show numbers of real vaccinated, not just numbers about vaccinations
-- Table shows top 10 countries
-- Table 23
WITH CTE_rolling_numbers (Location, Continent, Population, Sum_New_Vaccinations, Max_Total_vaccinations, Max_Fully_Vaccinated) AS
(
SELECT deaths.location, deaths.continent, deaths.population, SUM(vacc.new_vaccinations), MAX(vacc.total_vaccinations), MAX(vacc.people_fully_vaccinated)
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
GROUP BY deaths.location, deaths.continent, deaths.population
)
SELECT TOP 10 *,
((CAST(Max_Fully_Vaccinated AS FLOAT)/CAST(Population AS FLOAT))*100) AS Percentage_of_Vaccinated
FROM CTE_rolling_numbers
ORDER BY 7 DESC
;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TEMP TABLE to show percentage of vaccinated vs Percentage Of Fully Vaccinated
DROP TABLE IF EXISTS #VaccinatedPopulation;
CREATE TABLE #VaccinatedPopulation
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_vaccinations NUMERIC,
Rolling_people_vaccinated NUMERIC,
Total_vaccinations NUMERIC,
Fully_vaccinated NUMERIC
)
INSERT INTO #VaccinatedPopulation
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date),
vacc.total_vaccinations, vacc.people_fully_vaccinated
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
;

-- SELECT to show numbers for the Czech Republic
SELECT *,
(Rolling_people_vaccinated/Population)*100 AS Percentage_Of_Vaccinated_People,
(Fully_vaccinated/Population)*100 AS Percentage_Of_Fully_Vaccinated_People
FROM #VaccinatedPopulation
WHERE Location LIKE 'Czech%';

-- SELECT top 10 countries from TEMP table above -> interesting is to compare the precentage of fully vaccinated vs percentage of total Vaccinations 
-- (we can see that there is no reason to use new vaccinations for this because we don't really know what was the concrete vaccine and how many vaccine's should people have to be fully vaccinated)
SELECT TOP 10 Continent, Location, Population, SUM(New_vaccinations) AS sum_new_vaccinations, MAX(Total_vaccinations) AS max_total_vaccinations, MAX(Fully_vaccinated) max_fully_vaccinated,
(SUM(New_vaccinations)/Population)*100 AS Percentage_Of_Vaccinated_People,
(MAX(Total_vaccinations)/Population)*100 AS Percentage_Total_Vaccinations,
(MAX(Fully_vaccinated)/Population)*100 AS Percentage_Of_Fully_Vaccinated_People
FROM #VaccinatedPopulation
GROUP BY Location, Population, Continent
ORDER BY 9 DESC;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATING VIEW - to store data for later Visualizations
-- Almost the same table like Temp table above, just stored for permanent usage
DROP VIEW IF EXISTS PercentageOfVaccinated;
Create VIEW PercentageOfVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) AS RollingPeopleVaccinated,
vacc.total_vaccinations, vacc.people_fully_vaccinated, 
(CAST(people_fully_vaccinated AS FLOAT)/CAST(population AS FLOAT))*100 AS Percentage_of_Fully_Vaccinated
FROM Covid_analyse..CovidDeaths AS deaths
JOIN Covid_analyse..CovidVaccinations AS vacc
	ON deaths.location = vacc.location 
	AND deaths.date = vacc.date
WHERE deaths.continent IS NOT NULL
;

SELECT *
FROM PercentageOfVaccinated;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- EXPLORATION DONE!
