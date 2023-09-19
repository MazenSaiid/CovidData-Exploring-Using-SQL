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



