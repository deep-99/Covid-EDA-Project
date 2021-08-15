select *
from Project1..CovidDeaths
order by 3,4

select *
from Project1..CovidVaccinations
order by 1,2

select location, date, total_cases, total_deaths, population
from Project1..CovidDeaths
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date,continent ,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Project1..CovidDeaths
where location like '%india%'
order by 2,3 desc

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location, date,total_cases,population,(total_cases/population)*100 as population_effected 
from Project1..CovidDeaths
where location like '%india%'
order by 1,5 desc

-- Countries with Highest Infection Rate compared to Population

select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from Project1..CovidDeaths
where continent is not null 
group by location
order by TotalDeathCount desc

-- showing contitents with highest deth count

select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from Project1..CovidDeaths
where continent is not null 
group by location
order by TotalDeathCount desc

--Global numbers 

select date,sum(new_cases) as total_cases, sum(CAST(new_deaths as int)) as total_death, (sum(CAST(new_deaths as int))/sum(new_cases))*100 as DeathPercentage 
from Project1..CovidDeaths
where continent is not null
group by date
order by 1,2 desc

select * 
from Project1..CovidDeaths dea
join Project1..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=dea.date

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations 
from Project1..CovidDeaths dea
join Project1..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=dea.date
where dea.continent is not null
order by 1,2

select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from Project1..CovidDeaths dea
join Project1..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=dea.date
where dea.continent is not null 
order by 2,3


--Using CTE to perform Calculation on Partition By in previous query
with PopvsVac(contitent,location, date, polpulation,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from Project1..CovidDeaths dea
join Project1..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=dea.date
where dea.continent is not null
--order by 1,2
)
select *,(RollingPeopleVaccinated/polpulation)*100
from PopvsVac


-- creat view for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations ,
SUM(CAST(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from Project1..CovidDeaths dea
join Project1..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=dea.date
where dea.continent is not null
