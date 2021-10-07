-- Will Queries

SELECT 
	year, 
    sum(mail), 
    sum(freight), 
    sum(passengers), 
    sum(distance)
FROM flight
GROUP BY year;

SELECT 
	domestic, 
    year, 
    sum(mail), 
    sum(freight), 
    sum(passengers), 
    sum(distance)
FROM flight
GROUP BY year, domestic;

SELECT 
	a.state_id, 
	count(f.flight_id)
FROM airport a JOIN flight f ON (airport_id = f.departure_airport_id)
WHERE f.passengers != 0 and state_id not in ('TT', 'PR', 'VI') and domestic = 0
GROUP BY a.state_id
ORDER BY count(flight_id) desc, a.state_id;

SELECT
	a.country_id,
    sum(f.passengers)
FROM airport a JOIN flight f ON (airport_id = f.arrival_airport_id)
WHERE f.passengers != 0 and a.country_id != 'US'
GROUP BY a.country_id
ORDER BY sum(f.passengers) desc, a.country_id;


SELECT a.country_id, a.airport_name, sum(f.passengers)
FROM airport a JOIN flight f ON (airport_id = f.arrival_airport_id)
WHERE f.passengers != 0
GROUP BY a.airport_id
ORDER BY country_id, sum(f.passengers) desc;



SELECT *
FROM (
	SELECT
		a.country_id,
		a.airport_name,
		sum(f.passengers),
		ROW_NUMBER() OVER (
			PARTITION BY country_id
			ORDER BY sum(f.passengers) DESC) row_num
	FROM airport a JOIN flight f ON (airport_id = f.arrival_airport_id)
	GROUP BY a.airport_name
	ORDER BY a.country_id, sum(f.passengers) desc) as derived
WHERE row_num <= 5;

SELECT c.country_id, f.year, c.population, sum(passengers), sum(cs.total_cases), sum(cs.total_deaths)
FROM flight f 
	JOIN airport a ON (f.arrival_airport_id = a.airport_id)
    JOIN country c USING (country_id)
    LEFT JOIN covid_stats cs ON cs.country_id = c.country_id and cs.year = f.year
GROUP BY c.country_id, f.year
ORDER BY c.country_id, f.year;


SELECT year, month, country_id, total_cases/population * 1000
FROM covid_stats JOIN country USING(country_id)
WHERE country_id is not Null and year != 2021 and month = 12 and country_id not in ('US', 'BQ', 'ML', 'NC', 'TW', 'CM', 'GL', 'TN', 'SB', 'SD', 'IQ', 'AO', 'BA', 'BF', 'BG', 'AM', 'AF', 'BH', 'BY', 'CG', 'CY', 'DJ', 'EE', 'GE', 'GI', 'KV', 'KZ', 'LB', 'LK', 'LR', 'LT', 'LU', 'LV', 'ME', 'MD', 'MF', 'MK', 'MN', 'MO', 'MR', 'MT', 'MY', 'MZ', 'NE', 'OM', 'PG', 'PK', 'PY', 'SI', 'SR', 'TD', 'TH', 'TM','TM', 'VN', 'VU', 'ZW')
ORDER BY country_id;

SELECT year, country_id, sum(passengers)
FROM flight f RIGHT JOIN airport a ON (f.arrival_airport_id = a.airport_id)
WHERE domestic = 0 and country_id not in ('US', 'BQ', 'TN', 'AO', 'BA', 'BF', 'GL', 'BG', 'ML', 'AM', 'TW', 'AF', 'NC', 'BH', 'IQ', 'CM', 'BY', 'SB', 'SD', 'CG', 'CY', 'DJ', 'EE', 'GE', 'GI', 'KV', 'KZ', 'LB', 'LK', 'LR', 'LT', 'LU', 'LV', 'ME', 'MD', 'MF', 'MK', 'MN', 'MO', 'MR', 'MT', 'MY', 'MZ', 'NE', 'OM', 'PG', 'PK', 'PY', 'SI', 'SR', 'TD', 'TH', 'TM','TM', 'VN', 'VU', 'ZW')
GROUP BY country_id, year
ORDER BY year, country_id;

SELECT 
	airline_name, 
    year, 
    sum(passengers),
    sum(distance), 
    sum(passengers) - LAG(sum(passengers)) OVER (ORDER BY airline_name, year) as 'Diff'
FROM airline a JOIN flight f ON a.airline_id = f.airline
GROUP BY airline_name, year
ORDER BY Diff desc, airline_name, year;

SELECT airline_name, count(country_id)
FROM airline a JOIN flight f ON (a.airline_id = f.airline)
JOIN airport ap ON (ap.airport_id = f.arrival_airport_id)
WHERE country_id != 'US'
GROUP BY airline_name
HAVING count(country_id) <=1
ORDER BY airline_name, country_id;

SELECT state_id, total_cases / population
FROM state JOIN covid_stats USING (state_id)
WHERE year = 2021 and month = 5
ORDER BY total_cases / population desc;

-- Laura Queries

select 
A.airline_name,
Sum(Case when f.year = 2019 Then f.passengers Else 0 End) 2019_Passengers,
Sum(Case when f.year = 2020 Then f.passengers Else 0 End) 2020_Passengers,
Sum(Case when f.year = 2020 Then f.passengers Else 0 End) - 
Sum(Case when f.year = 2019 Then f.passengers Else 0 End) Difference,
	round(100 * (Sum(CASE WHEN f.year = 2020 then f.passengers else 0 end) - 
		Sum(CASE WHEN f.year = 2019 then f.passengers else 0 end)) / 
		ABS(Sum(CASE WHEN f.year = 2019 then f.passengers else 0 end)), 2) Percentage_decrease
from airline a
left join flight f  on a.airline_id = f.airline
group by airline_name
order by Sum(Case when f.year = 2019 Then f.passengers Else 0 End) desc
limit 10;

select 
c.name as "Country",
f.departure_airport_id, 
A.airport_name,
count(CASE WHEN year = 2019 then flight_id else null end) 2019_Total_Departures,
count(CASE WHEN year = 2020 then flight_id else null end) 2020_Total_Departures,
	round(100 * (count(CASE WHEN year = 2020 then flight_id else null end) - 
		count(CASE WHEN year = 2019 then flight_id else null end)) / 
			ABS(count(CASE WHEN year = 2019 then flight_id else null end)), 2) Percentage_decrease
from flight f 
join airport a on f.departure_airport_id = a.airport_id
join country c using(country_id)
GROUP BY f.departure_airport_id
order by count(CASE WHEN year = 2019 then flight_id else null end) desc
limit 10;

select distinct 
c.name, 
cs.total_deaths 
from covid_stats cs join country c using(country_id)
where year = 2020 and month = 12 and country_id != 'US'
order by cs.total_deaths desc
limit 20;

select 
c.name, 
	f.departure_airport_id, 
	a.airport_name,
	count(*)
from flight f 
join airport a on f.departure_airport_id = a.airport_id
join country c using(country_id)
where f.passengers = 0 and c.name != 'United States'
group by f.departure_airport_id
order by count(*) desc;

select 
	count(CASE WHEN month = 3 and year = 2020 then flight_id else null end) March_2020_Flights,
	count(CASE WHEN month = 4 and year = 2020 then flight_id else null end) April_2020_Flights,
	round(100 * (count(CASE WHEN month = 4 and year = 2020 then flight_id else null end) - count(CASE WHEN month = 3 and year = 2020 then flight_id else null end)) / 
	ABS(count(CASE WHEN month = 3 and year = 2020 then flight_id else null end)), 2) Percentage_decrease
from flight f
join airport a on f.departure_airport_id = a.airport_id
join country c using(country_id);

-- Dustin Queries

select distinct state_id
from
(select state_id
from (
select s.state_id, f.year, f.month, sum(f.passengers) as 'total_passengers'
from flight f
join airport a on (f.departure_airport_id = a.airport_id or f.arrival_airport_id = a.airport_id)
join state s on (s.state_id = a.state_id)
where f.service_class = 'F'
group by s.state_id, f.year, f.month
order by s.state_id, f.year, f.month) sub_table
where year = 2019
group by state_id, year
order by year, sum(total_passengers) desc
limit 5) table1
union
(select state_id
from (
select s.state_id, f.year, f.month, sum(f.passengers) as 'total_passengers'
from flight f
join airport a on (f.departure_airport_id = a.airport_id or f.arrival_airport_id = a.airport_id)
join state s on (s.state_id = a.state_id)
where f.service_class = 'F'
group by s.state_id, f.year, f.month
order by s.state_id, f.year, f.month) sub_table
where year = 2020
group by state_id, year
order by year, sum(total_passengers) desc
limit 5);

select s.state_id, f.year, f.month, sum(f.passengers) as 'total_passengers'
from flight f
join airport a on (f.departure_airport_id = a.airport_id or f.arrival_airport_id = a.airport_id)
join state s on (s.state_id = a.state_id)
where s.state_id in ('CA','FL','TX','NY','GA','IL') and f.service_class = 'F'
group by s.state_id, f.year, f.month
order by s.state_id, f.year, f.month;

select c.state_id, c.year, c.month, sum(monthly_cases) as 'monthly_cases'
from covid_stats c
where c.state_id in ('CA','FL','TX','NY','GA','IL')
group by c.state_id, c.year, c.month
order by c.state_id, c.year, c.month;

select service_class, f.year, f.month, count(*) as 'num_flights'
from flight f
join airport a on (f.departure_airport_id = a.airport_id or f.arrival_airport_id = a.airport_id)
where a.country_id = 'US'
group by service_class, f.year, f.month
order by service_class, f.year, f.month;

select a.airline_name, round(count(*)/12) as 'monthly_avg_flights'
from flight f
join airline a on (f.airline = a.airline_id)
where f.service_class = 'F' and f.year = 2019
group by a.airline_name
order by count(*)/12 desc;

select a.airline_name, round(count(*)/12) as 'monthly_avg_flights'
from flight f
join airline a on (f.airline = a.airline_id)
where f.service_class = 'F' and f.year = 2020
group by a.airline_name
order by count(*)/12 desc;

-- Ngoc Queries

select distinct xx.state_id, sum(xx.monthly_cases) as 'total_cases_345' from 
	(select distinct x.state_id, x.monthly_cases, x.year from
		(select state_id, monthly_cases, year
		from covid_stats
		where month = 3 or month = 4 or month = 5) x
	where year = 2020
	group by x.state_id) xx
where state_id = 'CA' OR state_id = 'TX' OR state_id = 'FL' OR state_id = 'NY' OR state_id = 'GA'
group by xx.state_id;

select distinct xx.state_id, sum(xx.monthly_cases) as 'total_cases_101112' from 
	(select distinct x.state_id, x.monthly_cases, x.year from
		(select state_id, monthly_cases, year
		from covid_stats
		where month = 10 or month = 11 or month = 12) x
	where year = 2020
	group by x.state_id) xx
where state_id = 'CA' OR state_id = 'TX' OR state_id = 'FL' OR state_id = 'NY' OR state_id = 'GA'
group by xx.state_id;

-- Triet Queries

select c.name, sum(f.freight),f.month, f.year
from country c
join airport a using (country_id)
join flight f on (f.arrival_airport_id = a.airport_id)
where f.arrival_airport_id in
	(select airport_id
     from airport a
	 join country c using (country_id)
     where c.name not like 'United States')
group by c.name, f.month, f.year
order by sum(f.freight) desc;

select c_dept.name, sum(f.freight) / 2000 as 'Freight (US Tons)', f.month, f.year
from flight f
join airport a_dept on (f.departure_airport_id = a_dept.airport_id)
join country c_dept on (a_dept.country_id = c_dept.country_id)
join airport a_arrv on (f.arrival_airport_id = a_arrv.airport_id)
join country c_arrv on (a_arrv.country_id = c_arrv.country_id)
where c_dept.name not like 'United States'
group by c_dept.name, f.month, f.year;

select s.state_id, 
	   sum(f.passengers) as 'total_passengers', 
       f.month, 
       f.year
from flight f
join airport a on (f.departure_airport_id = a.airport_id)
join state s on (s.state_id = a.state_id)
group by s.state_id, f.year, f.month
order by sum(f.passengers) desc;

select state_id,
	   monthly_cases, 
       monthly_deaths, 
       month, 
       year 
from covid_stats
where state_id in ('CA','FL','TX','GA','IL');
