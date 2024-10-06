CREATE DATABASE project_hr;
USE project_hr;

SELECT * FROM hr;

 
SELECT * FROM hr;

DESCRIBE hr;

-- ------------------------------------------------DATA CLEANING ---
-- 	Fix 'id' column name
select ï»¿id FROM hr;

ALTER TABLE hr
CHANGE ï»¿id id VARCHAR(20);

-- FIX Date: unify and change date formats
-- -------------------------------------------------for birhdate-------------------------------------
UPDATE hr
SET birthdate = CASE 
	WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
    
    ALTER TABLE hr
    MODIFY COLUMN birthdate DATE;
    

-- -------------------------------------------------for hire_date----------------------------------------
UPDATE hr
SET hire_date =  CASE 
	WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- -------------------------------------------TERMDATE--------------------------------------------------

SELECT * FROM hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate !='', DATE(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00');

SELECT termdate
FROM hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- ----------------------------------STANDARDIZE DATA--------------------------------------------------
-- add an age column
ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

SELECT MAX(age), MIN(age) FROM hr;

SELECT * from hr
WHERE age <18; #age issues "-ve ages"


-- EDA Data: Analysis & Business Key Problems & Anwsers---


-- Q1. What is the gender breakdown of employees in the company?----------------------------------

SELECT 
	gender, 
	COUNT(gender) total_count
FROM
	hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY
	gender;


-- Q2.What is the race/ethnicity breakdown of employees in the company?-------------------------------

SELECT 
	race, 
	COUNT(*) total_count
FROM
	hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY
	race
ORDER BY
	total_count DESC;

-- Q3. What is the age distribution of employees in the company?9bonus: also group by gender)----------------------------

SELECT 
	MAX(age),
    MIN(age)
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
;
-- let's create an age range distribution 18-24, 25- 34, 35-44, 45-54, 55-64, 65+


SELECT
CASE 
	WHEN age >=18 AND age <= 24 THEN '18-24'
	WHEN age >=25 AND age <= 34 THEN '25-34'
	WHEN age >=35 AND age <= 44 THEN '35-44'
	WHEN age >=45 AND age <= 54 THEN '45-54'
	WHEN age >=55 AND age <= 64 THEN '55-64'
	ELSE '65+'
END age_groups, 
gender,
COUNT(*) count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_groups, gender
ORDER BY age_groups, gender;


-- Q4. How many employees work at headquarters versus remote locations?------------------

SELECT DISTINCT location FROM hr;

SELECT 
	location,
	COUNT(location) total_employees
FROM
	hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY
	location;

-- Q5. What is the average length of employment for employees who have been terminated?-------------------

SELECT 
	round(AVG(datediff(termdate, hire_date))/365, 0) average_employment_YEARS
FROM hr
WHERE age >= 18 AND termdate != '0000-00-00' AND  termdate <= curdate()
;
-- Q6. How does the gender distribution vary across departments and job titles?---------------------

SELECT * FROM hr;

SELECT department, jobtitle, gender, count(*) count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, jobtitle, gender
ORDER BY department;

-- Q7. What is the distribution of job titles across the company (should be department)?--------------------------------------

SELECT * FROM hr;
SELECT jobtitle, count(*) employees_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY employees_count DESC;

-- Q8. Which department has the highest turnover rate?------------------------
-- (i.e: This is the total number of ex-staffs/ no of total (both current & ex) staffs.)
SELECT * FROM hr;
SELECT
	department,
	total_count,
    total_ex_staffs,
    total_ex_staffs/total_count AS turnover_rate
FROM(
	SELECT
		department,
		COUNT(*) total_count,
        SUM(CASE  WHEN termdate != '0000-00-00' AND termdate <= CURDATE() THEN 1  ELSE 0 END) total_ex_staffs
	FROM hr
    WHERE age >= 18
    GROUP BY department
    ) staff_query
ORDER BY turnover_rate DESC
;
    

-- Q9. What is the distribution of employees across locations by state?--------------

SELECT distinct location_state FROM hr;
DESCRIBE hr;

SELECT location_state state, COUNT(*) no_of_employees
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY state
ORDER BY no_of_employees DESC;

-- Q10. How has the company's employee count changed over time based on hire and term dates?--------
SELECT 
     `year`,
     hires,
     terminations,
     hires - terminations AS net_change,
     round((hires - terminations)/hires * 100, 2) AS net_change_percentage
FROM (
	 SELECT 
		year(hire_date) `year`,
        SUM(CASE WHEN hire_date IS NOT NULL THEN 1 ELSE 0 END) AS hires, -- or -- COUNT(*) hires,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
	FROM hr
    WHERE age >= 18
    GROUP BY `year`
        
	) AS emp_count_change
ORDER BY `year`
;
     
     
-- Q11. What is the tenure distribution for each department? (the average time employees stayin a dept b4 being fired or quit)

SELECT * FROM hr;

SELECT 
	department,
	total_sum_of_tenure,
	total_count_of_ex_staff,
	round((total_sum_of_tenure/total_count_of_ex_staff)/365, 0) avg_tenure_in_years
FROM
	(
    SELECT
		department,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN datediff(termdate, hire_date) ELSE 0 END) total_sum_of_tenure,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) total_count_of_ex_staff
	FROM hr
    WHERE age >= 18
	GROUP BY department
    ) subquery
ORDER BY 
	department
;


-- ORRRR

SELECT department, ROUND(avg(datediff(termdate, hire_date)/365), 0) as avg_staff_tenure
FROM hr
WHERE age >= 18 AND termdate <> '0000-00-00' AND termdate <= CURDATE()
GROUP BY department
ORDER BY department
;


