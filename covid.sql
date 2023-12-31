  #1  Looking at Total Cases vs Total Deaths
  -- What is the likelihood of dying if you contracted Covid on a given date in your country?
SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS DeathPercent
FROM
  `Covid.DeathsTable`
ORDER BY
  location,
  total_cases;
  #2 Looking at Total Cases vs Population
  -- What is the percentage of the population of a country that has caught Covid ?
SELECT
  location,
  date,
  total_cases,
  population,
  (total_cases/population )*100 AS InfectionRate
FROM
  `Covid.DeathsTable`
ORDER BY
  location,
  total_cases;
  #3 Looking at Countries with Highest Infection Rate compared to Population
SELECT
  location,
  population,
  MAX(total_cases) AS HighestInfectCount,
  MAX((total_cases/population))*100 AS InfectionRate
FROM
  `Covid.DeathsTable`
GROUP BY
  location,
  population
ORDER BY
  InfectionRate DESC;
  #4 Showing Countries with Highest Death Count per Population
SELECT
  location,
  MAX(total_deaths) AS HighestDeathCount,
FROM
  `Covid.DeathsTable`
WHERE
  continent IS NOT NULL
GROUP BY
  location
ORDER BY
  HighestDeathCount DESC;
  -- LET'S BREAK DOWN BY CONTINENT
  #5 Showing Continents with Highest Death Count
SELECT
  continent,
  MAX(total_deaths) AS HighestDeathCount,
FROM
  `Covid.DeathsTable`
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
  HighestDeathCount DESC;
  -- GLOBAL NUMBERS
  #6 Looking at the Cases vs Deaths
  --How many people that actually died from Covid in the world?
  --What is the likelihood of dying if you contract Covid from anywhere in the world?

  SELECT sum(new_cases) as total_cases,
  sum(new_deaths) as total_deaths, 
  (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage from `Covid.DeathsTable` where continent is not null;

  #7 Looking at Total Population vs Vaccinations
  --How many people in each country that have been vaccinated?
SELECT
  death.continent,
  death.location,
  death.date,
  population,
  new_vaccinations,
  SUM(new_vaccinations) OVER(PARTITION BY death.location ORDER BY death.date) AS RollingPeopleVaccinated
FROM
  `Covid.DeathsTable` death
JOIN
  `Covid.VaxTable` vax
ON
  death.date = vax.date
  AND death.location = vax.location
WHERE
  death.continent IS NOT NULL
ORDER BY
  2,
  3;
  #8 What is the percentage of people in each country that have been vaccinated?
  --USE CTE
WITH
  PopvsVax AS (
  SELECT
    death.continent,
    death.location,
    death.date,
    population,
    new_vaccinations,
    SUM(new_vaccinations) OVER(PARTITION BY death.location ORDER BY death.date) AS RollingPeopleVaccinated
  FROM
    `Covid.DeathsTable` death
  JOIN
    `Covid.VaxTable` vax
  ON
    death.date = vax.date
    AND death.location = vax.location
  WHERE
    death.continent IS NOT NULL
  ORDER BY
    2,
    3 )
SELECT
  continent,
  location,
  date,
  population,
  new_vaccinations,
  RollingPeopleVaccinated,
  (RollingPeopleVaccinated/population)*100 AS PercentPopulationVaccinated
FROM
  PopvsVax;

#9 Creating View to store data for later visualizations in Tableau

Create view `Covid.HighestDeathCount`  as  SELECT
  continent,
  MAX(total_deaths) AS TotalDeathCount,
FROM
  `Covid.DeathsTable`
WHERE
  continent IS NOT NULL
GROUP BY
  continent
ORDER BY
TotalDeathCount desc;

select * from `Covid.HighestDeathCount`;



