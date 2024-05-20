-- MENTORNESS Data Analytics Internship
-- Task 2 COVID-19 Analysis Using SQL
-- Gayo, Christian Nico
-- MIP-DA-07


-- Fixed Date formatting issue, transforming values from DD-MM-YYYY into YYYY-MM-DD using the following query:

UPDATE
	covidDS
SET
	`Date` = CONCAT(SUBSTRING(`Date`, 7, 4), '-', SUBSTRING(`Date`, 4, 2), '-', SUBSTRING(`Date`, 1, 2))
WHERE
	`Date` LIKE '__-__-____';


-- To avoid any errors, check missing value / null value 
-- Q1. Write SQL query to check for NULL values.

SELECT 
    *
FROM 
    covidDS
WHERE 
    Province IS NULL 
    OR Country_Region IS NULL 
    OR Latitude IS NULL 
    OR Longitude IS NULL 
    OR `Date` IS NULL 
    OR Confirmed IS NULL 
    OR Deaths IS NULL 
    OR Recovered IS NULL;

-- Q2. If NULL values are present, update them with zeros for all columns. 

[NULL values are not present in the dataset. However, for good measure, a query will be run to set NULL values to 0 using the COALESCE keyword.]

UPDATE
	covidDS
SET
	Province = COALESCE(Province, '0'),
	Country_Region = COALESCE(Country_Region, '0'),
	Latitude = COALESCE(Latitude, 0),
	Longitude = COALESCE(Longitude, 0),
	`Date` = COALESCE(`Date`, 0),
	Confirmed = COALESCE(Confirmed, 0),
	Deaths = COALESCE(Deaths, 0),
	Recovered = COALESCE(Recovered, 0);

-- Q3. Check for the total number of rows.

SELECT
	COUNT(*) AS TotalRows
FROM
	covidDS;

-- Q4. Check what is start_date and end_date.

SELECT 
    MIN(`Date`) AS start_date,
    MAX(`Date`) AS end_date
FROM 
    covidDS;

-- Q5. Find the number of months present in dataset.

SELECT
	EXTRACT(YEAR FROM Date) AS year,
	COUNT(DISTINCT EXTRACT(MONTH FROM Date)) AS distinct_months
FROM
	covidDS
GROUP BY
	EXTRACT(YEAR FROM Date);

-- Q6. Find the monthly average for confirmed cases, deaths, and recoveries.

SELECT
	EXTRACT(YEAR FROM Date) AS year,
	EXTRACT(MONTH FROM Date) AS month,
	AVG(Confirmed) AS avg_confirmed,
	AVG(Deaths) AS avg_deaths,
	AVG(Recovered) AS avg_recovered
FROM
	covidDS
GROUP BY
	EXTRACT(YEAR FROM Date),
	EXTRACT(MONTH FROM Date)
ORDER BY
	year,
	month;

-- Q7. Find the most frequent value for confirmed cases, deaths, and recoveries for each month.

SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    (
        SELECT Confirmed 
        FROM covidDS 
        WHERE YEAR(covidDS.Date) = YEAR(covidDS.Date) 
            AND MONTH(covidDS.Date) = MONTH(covidDS.Date) 
        GROUP BY Confirmed 
        ORDER BY COUNT(*) DESC 
        LIMIT 1
    ) AS most_frequent_confirmed,
    (
        SELECT Deaths 
        FROM covidDS 
        WHERE YEAR(covidDS.Date) = YEAR(covidDS.Date) 
            AND MONTH(covidDS.Date) = MONTH(covidDS.Date) 
        GROUP BY Deaths 
        ORDER BY COUNT(*) DESC 
        LIMIT 1
    ) AS most_frequent_deaths,
    (
        SELECT Recovered 
        FROM covidDS 
        WHERE YEAR(covidDS.Date) = YEAR(covidDS.Date) 
            AND MONTH(covidDS.Date) = MONTH(covidDS.Date) 
        GROUP BY Recovered 
        ORDER BY COUNT(*) DESC 
        LIMIT 1
    ) AS most_frequent_recovered
FROM 
    covidDS
GROUP BY 
    YEAR(Date), MONTH(Date)
ORDER BY 
    YEAR(Date), MONTH(Date);

-- Q8. Find the minimum values for confirmed cases, deaths, and recoveries per year.

SELECT
	YEAR(Date) AS year,
	MIN(Confirmed) AS min_confirmed,
	MIN(Deaths) AS min_deaths,
	MIN(Recovered) AS min_recovered
FROM
	covidDS
GROUP BY
	YEAR(Date)
ORDER BY
	YEAR(Date);

-- Q9. Find the maximum values for confirmed cases, deaths, and recoveries per year.

SELECT 
    YEAR(Date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM 
    covidDS
GROUP BY 
    YEAR(Date)
ORDER BY 
    YEAR(Date);

-- Q10. Find the total number of confirmed cases, deaths, and recoveries for each month.

SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM 
    covidDS
GROUP BY 
    YEAR(Date), MONTH(Date)
ORDER BY 
    YEAR(Date), MONTH(Date);

-- Q11. Check how the COVID-19 virus spread with respect to confirmed cases.

SELECT
    COUNT(*) AS total_cases,
    AVG(Confirmed) AS average_confirmed,
    VARIANCE(Confirmed) AS variance_confirmed,
    STDDEV(Confirmed) AS stdev_confirmed
FROM
    covidDS;

-- Q12. Check how the COVID-19 virus spread with respect to the number of deaths per month.

SELECT
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    COUNT(*) AS total_cases,
    AVG(Deaths) AS average_deaths,
    VARIANCE(Deaths) AS variance_deaths,
    STDDEV(Deaths) AS stdev_deaths
FROM
    covidDS
GROUP BY
    YEAR(Date), MONTH(Date)
ORDER BY
    YEAR(Date), MONTH(Date);

-- Q13. Check how the COVID-19 virus spread with respect to the number of recovered cases.

SELECT
    COUNT(*) AS total_cases,
    AVG(Recovered) AS average_recovered,
    VARIANCE(Recovered) AS variance_recovered,
    STDDEV(Recovered) AS stdev_recovered
FROM
    covidDS;

-- Q14. Find the country having the highest number of the confirmed cases.

SELECT 
    Country_Region,
    SUM(Confirmed) AS total_confirmed_cases
FROM 
    covidDS
GROUP BY 
    Country_Region
ORDER BY 
    total_confirmed_cases DESC
LIMIT 1;

-- Q15. Find the country having the lowest number of deaths.

SELECT 
    Country_Region,
    SUM(Deaths) AS total_death_cases
FROM 
    covidDS
GROUP BY 
    Country_Region
ORDER BY 
    total_death_cases ASC
LIMIT 1;

-- Q16. Find the top 5 countries having the highest recovered cases.

SELECT 
    Country_Region,
    SUM(Recovered) AS total_recovered_cases
FROM 
    covidDS
GROUP BY 
    Country_Region
ORDER BY 
    total_recovered_cases DESC
LIMIT 5;
