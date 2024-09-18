-- QUERIES for tableau visualization

SELECT * FROM Covid_analyse..CovidDeaths;


-- Table_1 - visualization
SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL ;

-- Table_2 - visualization
-- a. version
SELECT Location, SUM(new_deaths) AS TotalDeathCount
FROM Covid_analyse..CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;
-- b. version
SELECT Continent, SUM(new_deaths) AS TotalDeathCount
FROM Covid_analyse..CovidDeaths
WHERE continent IS NOT NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Table_3 - visualization
DROP TABLE IF EXISTS #PopulationInfected;
CREATE TABLE #PopulationInfected
(
Location NVARCHAR(255),
Population NUMERIC,
HighestInfectionCount NUMERIC,
PercentPopulationInfected FLOAT
)
INSERT INTO #PopulationInfected
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS PercentPopulationInfected
FROM Covid_analyse..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

UPDATE #PopulationInfected
SET PercentPopulationInfected = 0
WHERE PercentPopulationInfected IS NULL;
UPDATE #PopulationInfected
SET Population = 0
WHERE Population IS NULL;

SELECT * 
FROM #PopulationInfected
ORDER BY PercentPopulationInfected DESC;
DROP TABLE IF EXISTS #PopulationInfected;

-- Table_4 - visualization
DROP TABLE IF EXISTS #PopulationInfected2;
CREATE TABLE #PopulationInfected2
(
Location NVARCHAR(255),
Population NUMERIC,
Date DATETIME,
HighestInfectionCount NUMERIC,
PercentPopulationInfected FLOAT
)
INSERT INTO #PopulationInfected2
SELECT  Location, Population, Date, MAX(total_cases) AS HighestInfectionCount,  MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS PercentPopulationInfected
FROM Covid_analyse..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;

UPDATE #PopulationInfected2
SET PercentPopulationInfected = 0
WHERE PercentPopulationInfected IS NULL;
UPDATE #PopulationInfected2
SET Population = 0
WHERE Population IS NULL;

SELECT * 
FROM #PopulationInfected2
ORDER BY PercentPopulationInfected DESC;

DROP TABLE IF EXISTS #PopulationInfected;

