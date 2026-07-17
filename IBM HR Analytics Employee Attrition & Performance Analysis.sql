CREATE DATABASE IBM_hr_employee_survey;
USE IBM_hr_employee_survey;
SHOW COLUMNS FROM HR_Employee_Survey;
-- EmployeeAttrition --------- 

-- View all records 
SELECT * FROM HR_Employee_Survey;

-- Total employees 
SELECT COUNT(*) AS TotalEmployees
 FROM HR_Employee_Survey;
 
 -- Total no of attrition  ( Yes/ No)
 SELECT Attrition, COUNT(*) 
 FROM HR_Employee_Survey GROUP BY Attrition;
 
 --  Count completed surveys
SELECT COUNT(*) AS Completed
FROM HR_Employee_Survey;

 -- Attrition percentage 
 SELECT SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*) AS AttritionRate
 FROM HR_Employee_Survey;
 
 --  Average monthly income
 SELECT AVG(MonthlyIncome)
 FROM HR_Employee_Survey;

--  salary 
 -- Highest salary
 SELECT MAX(MonthlyIncome) 
 FROM HR_Employee_Survey;
 
 -- Lowest salary
 SELECT MIN(MonthlyIncome)
 FROM HR_Employee_Survey;
 
 -- Average age
 SELECT AVG(Age) 
 FROM HR_Employee_Survey;
 
-- Count departments
SELECT Department, COUNT(*) AS Responses
FROM HR_Employee_Survey
GROUP BY Department;

-- responses by sentiment
SELECT *
FROM HR_Employee_Survey
LIMIT 5;
 
 -- Employees by job role
 SELECT JobRole,COUNT(*)
 FROM HR_Employee_Survey
 GROUP BY JobRole;
 
 -- Average salary by department
 SELECT Department,
AVG(MonthlyIncome) AvgSalary
FROM HR_Employee_Survey
GROUP BY Department;

-- Average salary by gender
 SELECT Gender, 
 AVG(MonthlyIncome) 
FROM HR_Employee_Survey
GROUP BY Gender;
 
 -- Average work-life balance
 SELECT AVG(WorkLifeBalance)
 FROM HR_Employee_Survey;
 
 -- Employees working overtime 
 SELECT COUNT(*) 
 FROM HR_Employee_Survey WHERE OverTime='Yes';
 
 -- Employees without overtime
 SELECT * 
 FROM HR_Employee_Survey
 WHERE OverTime='No';
 
 -- Average income by Job Role
 SELECT JobRole, 
 AVG(MonthlyIncome) AvgIncome
 FROM HR_Employee_Survey
 GROUP BY JobRole;
 
 -- Top 10 highest salaries
 SELECT *
FROM HR_Employee_Survey
ORDER BY MonthlyIncome DESC
LIMIT 10;
 
 --  Bottom 10 salaries
 SELECT *
 FROM HR_Employee_Survey
 ORDER BY MonthlyIncome;
 LIMIT 10;
 
 --  Income greater than department average
SELECT * 
FROM HR_Employee_Survey h
WHERE MonthlyIncome >
(
 SELECT AVG(MonthlyIncome)
 FROM HR_Employee_Survey
 WHERE Department=h.Department
 );
 
 -- Rank employees by salary
 SELECT EmployeeNumber,
 MonthlyIncome, 
 RANK() OVER(ORDER BY MonthlyIncome DESC) SalaryRank 
 FROM HR_Employee_Survey;
 
 -- Dense Rank salary
 SELECT EmployeeNumber,
 MonthlyIncome,
 DENSE_RANK() OVER(ORDER BY MonthlyIncome DESC) SalaryRank
 FROM HR_Employee_Survey;
 
 -- Row Number by department
 SELECT EmployeeNumber,
 Department,
 ROW_NUMBER() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) RN
 FROM HR_Employee_Survey;
 
 -- ----------- Salary ---------------------------
 -- Top 3 earners in each department
 WITH SalaryRank AS
 (
 SELECT *,
 ROW_NUMBER() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) RN
 FROM HR_Employee_Survey
 )
 SELECT * 
 FROM SalaryRank 
 WHERE RN<=3;
 
 -- Running salary total
 SELECT EmployeeNumber,
 MonthlyIncome,
 SUM(MonthlyIncome)
 OVER(ORDER BY EmployeeNumber) RunningTotal
 FROM HR_Employee_Survey;
 
 -- Running average salary
 SELECT EmployeeNumber, 
 AVG(MonthlyIncome)
 OVER(ORDER BY EmployeeNumber) RunningAverage
 FROM HR_Employee_Survey;
 
 -- Previous employee salary  --------------------------------------------->>>
 SELECT EmployeeNumber, 
 MonthlyIncome, 
 LAG(MonthlyIncome)
 OVER(ORDER BY EmployeeNumber) 
 PreviousSalary FROM HR_Employee_Survey;
 
 -- Next employee salary
 SELECT EmployeeNumber, 
 MonthlyIncome, 
 LEAD(MonthlyIncome)
 OVER(ORDER BY EmployeeNumber) NextSalary
 FROM HR_Employee_Survey;
 
 -- Difference from department average  <<-----------------
 SELECT EmployeeNumber,
 Department, 
 MonthlyIncome, 
 MonthlyIncome- 
 AVG(MonthlyIncome)
 OVER(PARTITION BY Department) Difference 
 FROM HR_Employee_Survey;
 
 -- Salary Quartiles 
 SELECT EmployeeNumber, 
 MonthlyIncome, 
 NTILE(4)
 OVER(ORDER BY MonthlyIncome DESC) Quartile 
 FROM HR_Employee_Survey;
 
 -- Salary Percentile 
 SELECT EmployeeNumber,
 MonthlyIncome,
 PERCENT_RANK()
 OVER(ORDER BY MonthlyIncome) SalaryPercentile 
 FROM HR_Employee_Survey;
 
 -- Department with highest average salary
 SELECT   Department,
 AVG(MonthlyIncome) AvgSalary 
 FROM HR_Employee_Survey 
 GROUP BY Department
 ORDER BY AvgSalary DESC;
 
 -- -----------------------------------------------------------------
 -- ------------------------------------------------------------------
 -- Department with lowest average salary
 SELECT Department, 
 AVG(MonthlyIncome) AvgSalary
 FROM HR_Employee_Survey 
 GROUP BY Department 
 ORDER BY AvgSalary;
 
 -- Attrition percentage
 SELECT Attrition, 
 COUNT(*)*100.0/
 (SELECT COUNT(*) 
 FROM HR_Employee_Survey) Percentage
 FROM HR_Employee_Survey 
 GROUP BY Attrition;
 
 -- Average years at company  ^^^^^^^^^^^^^^^^^^^^^^^^^^
 SELECT AVG(YearsAtCompany) 
 AvgYears FROM HR_Employee_Survey;
 
 -- Employees never promoted --------------
 SELECT * FROM HR_Employee_Survey 
 WHERE YearsSinceLastPromotion=0;
 
 -- Employees with Experience ----------- >>>>
 --  maximum experience
 SELECT * 
 FROM HR_Employee_Survey
 WHERE TotalWorkingYears= 
 ( 
 SELECT MAX(TotalWorkingYears)
 FROM HR_Employee_Survey 
 );
 
 -- Average Job Satisfaction by Department  ^^^^^^^^^^^^^^^^
 SELECT Department,
 AVG(JobSatisfaction) AvgSatisfaction 
 FROM HR_Employee_Survey 
 GROUP BY Department;
 
 -- Highest Performance Rating    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 SELECT * 
 FROM HR_Employee_Survey 
 WHERE PerformanceRating= 
 (
 SELECT MAX(PerformanceRating) 
 FROM HR_Employee_Survey
 );
 
 -- >>>>>>> Salary Band <<<<<<<<< -- 
 SELECT EmployeeNumber,
 MonthlyIncome, 
 CASE WHEN MonthlyIncome<5000 THEN 'Low'
 WHEN MonthlyIncome<10000 THEN 'Medium' ELSE 'High'
 END SalaryBand 
 FROM HR_Employee_Survey;
 
 -- >>>>>>>>>>>>>>>>> Experience Band  <<<<<<<<<<<<<<<<<< -- 
 SELECT EmployeeNumber,
 TotalWorkingYears,
 CASE 
 WHEN TotalWorkingYears<5 THEN 'Beginner'
 WHEN TotalWorkingYears<10 THEN 'Intermediate' 
 ELSE 'Experienced'
 END ExperienceBand 
 FROM HR_Employee_Survey;
 
 -- -------  Overtime count by department ---------
 SELECT Department, 
 SUM(CASE WHEN OverTime='Yes' THEN 1 ELSE 0 END) OvertimeEmployees
 FROM HR_Employee_Survey 
 GROUP BY Department;
 
 -- Attrition by Job Role ---- >>>>>>>>>>
 SELECT JobRole, 
 COUNT(*) AttritionCount
 FROM HR_Employee_Survey WHERE Attrition='Yes' 
 GROUP BY JobRole;
 
 -- Moving Average Salary
 SELECT EmployeeNumber, 
 AVG(MonthlyIncome) 
 OVER( 
 ORDER BY EmployeeNumber ROWS BETWEEN 4 PRECEDING AND CURRENT ROW 
 ) MovingAverage
 FROM HR_Employee_Survey;
 
 -- employee in each department  +++++++++++++++++++++
 -- Highest paid 
 SELECT * 
 FROM HR_Employee_Survey h
 WHERE MonthlyIncome= 
 ( 
 SELECT MAX(MonthlyIncome)
 FROM HR_Employee_Survey
 WHERE Department=h.Department );
 
 -- Lowest paid 
  SELECT * 
 FROM HR_Employee_Survey h
 WHERE MonthlyIncome= 
 ( 
 SELECT MIN(MonthlyIncome)
 FROM HR_Employee_Survey
 WHERE Department=h.Department );
 
 -- Average income by Education Field
 SELECT EducationField, 
 AVG(MonthlyIncome) AvgIncome
 FROM HR_Employee_Survey 
 GROUP BY EducationField;
 
 -- ----------------------------------------------------------------------------------
 --   ------------------------ END -----------------------------------------------
 -- --------------------------------------------------------------------------