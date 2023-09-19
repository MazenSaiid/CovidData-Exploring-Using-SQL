Select location, date, total_cases, new_cases, total_deaths, population
 from [dbo].[covid-data-deaths]
 order by location, date

 --Looking at Total Deaths vs Total Cases

 Select top(100) location, date, total_cases, total_deaths, population,
 (convert(decimal,total_deaths)/convert(decimal,total_cases))*100 as DeathToCasesPercentage
 from [dbo].[covid-data-deaths]
 order by location, date

 
 --Looking at Total Deaths vs Total Cases in Certain location

 Select location, date, total_cases, total_deaths, population,
 (convert(decimal,total_deaths)/convert(decimal,total_cases))*100 as DeathToCasesPercentage
 from [dbo].[covid-data-deaths]
 where location like '%states'
 order by location, date


 CREATE PROCEDURE TotalDeathsvsTotalCasesinCertainLocation @location nvarchar(100) 
AS
Select location, date, total_cases, total_deaths, population,
 (convert(decimal,total_deaths)/convert(decimal,total_cases))*100 as DeathToCasesPercentage
 from [dbo].[covid-data-deaths]
 where location = @location
 order by location, date

 execute TotalDeathsvsTotalCasesinCertainLocation @location = 'egypt';

  --Looking at Total Cases vs Population in Certain location

 Select location, date, total_cases, population,
 (convert(decimal,total_cases)/convert(decimal,population))*100 as CasesToPopulationPercentage
 from [dbo].[covid-data-deaths]
 where location like 'cana%'
 order by 1, 2

 --Looking at Highest Infection Rates vs Total Cases vs Population 

 Select location, Max(total_cases) as HighestInfectionRate, population,
 Max((convert(decimal,total_cases)/convert(decimal,population)))*100 as CasesToPopulationPercentage
 from [dbo].[covid-data-deaths]
 group by location, date, population
 order by CasesToPopulationPercentage desc

 Create View HighestInfectionRates 
 as
 Select location, Max(total_cases) as HighestInfectionRate, population,
 Max((convert(decimal,total_cases)/convert(decimal,population)))*100 as CasesToPopulationPercentage
 from [dbo].[covid-data-deaths]
 group by location, population

 Select * from HighestInfectionRates
 order by CasesToPopulationPercentage desc 


 --Looking at Highest Death Rates vs Population 

 Select location, Max(cast(total_deaths as int)) as HighestDeathCount, population,
 Max((convert(decimal,total_deaths)/convert(decimal,population)))*100 as DeathsToPopulationPercentage
 from [dbo].[covid-data-deaths]
 where continent is not null 
 group by location, population
 order by HighestDeathCount desc

 Create View HighestDeathRates 
 as
  Select location, Max(cast(total_deaths as int)) as HighestDeathCount, population,
 Max((convert(decimal,total_deaths)/convert(decimal,population)))*100 as DeathsToPopulationPercentage
 from [dbo].[covid-data-deaths]
 where continent is not null 
 group by location, population

 Select * from HighestDeathRates
 order by HighestDeathCount desc 


 --Looking at Highest Death Rates By Continent

 Select location, Max(cast(total_deaths as int)) as HighestDeathCount
 from [dbo].[covid-data-deaths]
 where continent is null 
 group by location
 order by HighestDeathCount desc

 Create View HighestDeathRatesByConntinent 
 as
   Select location, Max(cast(total_deaths as int)) as HighestDeathCount
 from [dbo].[covid-data-deaths]
 where continent is null 
 group by location

 Select * from HighestDeathRatesByConntinent
 order by HighestDeathCount desc 


 
 --Globally

 Select  date, Sum(convert(int,new_cases)) as TotalCases, Sum(convert(int,new_deaths)) as TotalDeaths,
 (Sum(convert(decimal,new_deaths))/Nullif(Sum(convert(decimal,new_cases)),0))*100 as DeathToCasesPercentage
 from [dbo].[covid-data-deaths]
 where continent is not null
 group by date
 order by date

 Create View DayByDayCasesvsDeaths
 as
 Select  date, Sum(convert(int,new_cases)) as TotalCases, Sum(convert(int,new_deaths)) as TotalDeaths,
 (Sum(convert(decimal,new_deaths))/Nullif(Sum(convert(decimal,new_cases)),0))*100 as DeathToCasesPercentage
 from [dbo].[covid-data-deaths]
 where continent is not null
 group by date

 Select * from DayByDayCasesvsDeaths 
 order by date


Create View TotalCasesvsDeathsGlobally
 as
 Select  Sum(convert(int,new_cases)) as TotalCases, Sum(convert(int,new_deaths)) as TotalDeaths,
 (Sum(convert(decimal,new_deaths))/Nullif(Sum(convert(decimal,new_cases)),0))*100 as DeathToCasesPercentage
 from [dbo].[covid-data-deaths]
 where continent is not null

 Select * from TotalCasesvsDeathsGlobally 



 --Vacc Table


 Select * from 
[dbo].[covid-data-deaths] as dea
inner join [dbo].[covid-data-vacc] as vacc
on dea.location = vacc.location and 
dea.date = vacc.date


--Looking at Total Populations vs Vaccinations


Select dea.continent, dea.location, dea.date,population,new_vaccinations from 
[dbo].[covid-data-deaths] as dea
inner join [dbo].[covid-data-vacc] as vacc
on dea.location = vacc.location and 
dea.date = vacc.date
where dea.continent is not null
order by dea.location,dea.date



Select dea.continent, dea.location, dea.date, population,
new_vaccinations,SUM(cast(vacc.new_vaccinations as int)) 
OVER (Partition By dea.location order by dea.location, dea.date) as TotalVaccDayByDayConsecutively from 
[dbo].[covid-data-deaths] as dea
inner join [dbo].[covid-data-vacc] as vacc
on dea.location = vacc.location and 
dea.date = vacc.date
where dea.continent is not null
order by dea.location,dea.date


Select dea.continent, dea.location, dea.date, population,
new_vaccinations,SUM(cast(vacc.new_vaccinations as float)) 
OVER (Partition By dea.location order by dea.location, dea.date) as TotalVaccDayByDayConsecutively 
into TempTable from 
[dbo].[covid-data-deaths] as dea
inner join [dbo].[covid-data-vacc] as vacc
on dea.location = vacc.location and 
dea.date = vacc.date
where dea.continent is not null


Select *, (TotalVaccDayByDayConsecutively/population)*100
 as PercentageVaccinated  from TempTable 

Create View PercentagePopulationVaccintaed
as 
Select *, (TotalVaccDayByDayConsecutively/population)*100
 as PercentageVaccinated  from TempTable 


 Select * from PercentagePopulationVaccintaed