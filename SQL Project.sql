SELECT *
FROM `SQL Project`.covid_deaths
Where continent is not null
order by 3,4;

## Selecting data that will be used

Select location, date, total_cases, new_cases, total_deaths, population
FROM `SQL Project`.covid_deaths
where continent is not null
order by 1,2;

##Total cases vs total deaths
##Chances of dying due of covid per country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM `SQL Project`.covid_deaths
where location like '%states%'
and continent is not null
order by 3;

##Total cases vs population
##Shows population infected

Select location, date, population, total_cases, (total_cases/population)*100 as Percentage_Infected
FROM `SQL Project`.covid_deaths
where location like '%states%'
and continent is not null
order by 1,2;

##Countries with highest infection rate

Select location, population, Max(total_cases) as Highest_Infection_count, Max((total_cases/population))*100 as Infection_rate
FROM `SQL Project`.covid_deaths
group by location, population
order by infection_rate desc;

##Highest Death Count per population

Select Location, Max(cast(total_deaths as decimal)) as Total_Death_Count
FROM `SQL Project`.covid_deaths
Where continent is not null
group by location
order by Total_Death_Count desc;

##Showing by continent

Select continent, Max(cast(total_deaths as decimal)) as Total_Death_Count
FROM `SQL Project`.covid_deaths
Where continent is not null
group by continent
order by Total_Death_Count desc;

##Global Numbers

Select SUM(new_cases) as Total_cases, Sum(cast(new_deaths as decimal)) as Total_deaths, SUM(Cast(new_deaths as decimal))/SUM(new_cases)*100 as Death_percentage
FROM `SQL Project`.covid_deaths
Where continent is not null
order by 1,2;

##Total Population vs Vaccinations
##Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From `SQL Project`.covid_deaths dea
Join `SQL Project`.covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

##CTE

With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From `SQL Project`.covid_deaths dea
Join `SQL Project`.covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;

## Create View for visualizations


use sys;
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as decimal)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From `SQL Project`.covid_deaths dea
Join `SQL Project`.covid_vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;
##order by 2,3


