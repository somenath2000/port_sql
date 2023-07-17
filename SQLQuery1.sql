Select * From [portfolio project]..CovidDeaths$
where continent is not null
order by 3,4;
Select Location, date, total_cases, new_cases, total_deaths, population
From [portfolio project]..CovidDeaths$
Where continent is not null 
order by 1,2;

select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from [portfolio project]..CovidDeaths$
where location like 'India'
order by 1,2;

select Location, date, total_cases, population, (total_cases/population)*100 as covid_ratio 
from [portfolio project]..CovidDeaths$
where location like 'India'
order by 1,2;
select Location, population, MAX(total_cases) as Highest_covidratio, MAX(total_cases/population)*100 as covid_ratio 
from [portfolio project]..CovidDeaths$
group by location, population
order by covid_ratio desc;

select location, MAX(cast(total_deaths as int)) as totaldeathnumber 
from [portfolio project]..CovidDeaths$
where continent is not null
group by location 
order by totaldeathnumber desc;

select continent, MAX(cast(total_deaths as int)) as totaldeathnumber 
from [portfolio project]..CovidDeaths$
where continent is not null
group by continent 
order by totaldeathnumber desc;

select sum(new_cases) as total_cases, sum(Cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100  as Death_percentage
from [portfolio project]..CovidDeaths$
where continent is not null
order by 1,2;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date

	Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio project]..CovidDeaths$ dea
Join [portfolio project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
