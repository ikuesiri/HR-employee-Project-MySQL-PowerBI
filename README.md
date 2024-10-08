# HR-employee-Project-MySQL-PowerBI
![HR-Report ](https://raw.githubusercontent.com/ikuesiri/HR-employee-Project-MySQL-PowerBI/4876c5bcb5b4cb74a948ff525af386bb9749865c/HR-report.PNG)

## Data Used

**Data** - HR Data with over 22000 rows from 2000 to 2020.

**Data Cleaning & Exploratory Data Analysis** - MySQL 

**Data Visualization** - PowerBI

## Questions

1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company? (Bonus: also group by gender)
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate? (i.e. This is the total number of ex-staffs/ no of total (both current & ex) staffs.)
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time, based on hire and term dates?
11. What is the tenure distribution for each department? (i.e. the average time employees stay in a dept b4 being fired or they quit.)

## Summary of Findings
 - There are more male employees
 - White race is the most dominant while Native Hawaiian and American Indians are the least dominant.
 - The youngest employee is 22 years old and the oldest is 58 years old
 - 5 age groups were created in these ranges (18-24, 25-34, 35-44, 45-54, 55-64). A large percentage of employees were between the ages of 34-44, while the smallest group was 55-64.
 - A large number of employees work at the headquarters versus remotely.
 - The average length of employment for terminated employees is around 8 years.
 - The gender distribution across departments is fairly balanced but there are generally more male than female employees.
 - The Marketing department has the lowest turnover rate followed by Training. The highest turnover rate is  in the `Sales` departments.
 - A large number of employees come from the state of Ohio and the Lowest from the State of `Wisconsin`.
 - The net change in employees has been on an upward trend over the years.
   ![change line chart](https://github.com/ikuesiri/HR-employee-Project-MySQL-PowerBI/blob/main/chart.PNG?raw=true)
- The average tenure for each department ranges between 7-9 years, with LSales having the highest.

## Limitations

- Some records had negative ages and these were excluded during querying(967 records). The ages used were 18 years and above.
- Some `termdates` were far into the future and were not included in the analysis(1338 records). The only term dates used were those less than or equal to the current date.
