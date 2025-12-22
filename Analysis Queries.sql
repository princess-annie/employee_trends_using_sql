-- view databases
show databases;
-- use employee_db
use employee_db;
-- show tables
show tables;

-- Key Queries & Insights

-- 1. Total number of employees broken down by Position and department?

SELECT DISTINCT Title, DepartmentType,
COUNT(*) AS Totalemployees
FROM employee_data
GROUP BY Title,DepartmentType
ORDER BY Totalemployees DESC;

-- 2. What is the distribution of employees by gender?
SELECT GenderCode,
COUNT(*) AS Totalemployees
FROM employee_data
GROUP BY GenderCode;

-- 3. How many employees are currently active and terminated?
-- Count Active employees
SELECT 'Active' AS StatusCategory, COUNT(*) AS EmployeeCount
FROM employee_data
WHERE EmployeeStatus = 'Active'

UNION ALL

-- Count Terminated employees (all types)
SELECT 'Terminated' AS StatusCategory, COUNT(*) AS EmployeeCount
FROM employee_data
WHERE EmployeeStatus LIKE '%Terminated%';


-- 4. Which Job titles or employeeclassification have the highest head count?
SELECT  DISTINCT Title, EmployeeClassificationType,
COUNT(*) AS head_count
from employee_data
GROUP BY Title
ORDER BY EmployeeClassificationType, head_count DESC;

-- 5. What is the highest,lowest current employee rating per active employees?
SELECT
MAX(CurrentEmployeeRating) AS highest_rating,
MIN(CurrentEmployeeRating) AS lowest_rating
from employee_data;


-- 6. What is the distribution of performance scores by job title and employment classification type?
SELECT  DISTINCT Title, EmployeeClassificationType, PerformanceScore,
COUNT(*) AS number_of_employees
from employee_data
GROUP BY Title, EmployeeClassificationType
ORDER BY EmployeeClassificationType,PerformanceScore, number_of_employees DESC;


-- 7. Which Employees shows high performance but low enagagement?
Select e.PerformanceScore, es.Engagement_Score,
COUNT(*) AS Total_Performing_Rate_Per_Engagement
from employee_data e
JOIN employee_survey_data es
ON e.EmpID = es.Employee_ID
WHERE e.PerformanceScore IN('Exceeds', 'Fully Meets')
AND es.Engagement_Score IN(1,2)
GROUP BY e.PerformanceScore, es.Engagement_Score
ORDER BY e.PerformanceScore, es.Engagement_Score;


-- 8. Which training program achieved the best and Worst outcomes?
SELECT TrainingProgramName, TrainingOutcome, TrainingType,
COUNT(*) AS ApplicantCount
FROM training_and_development_data
WHERE TrainingOutcome = 'Passed' 
OR TrainingOutcome = 'Failed'
GROUP BY TrainingProgramName, TrainingOutcome
ORDER BY TrainingProgramName,TrainingType, ApplicantCount DESC;


-- *9. What is the average training duration per training type and training program?
SELECT TrainingProgramName, TrainingType, 
AVG(TrainingDuration) AS Average_duration
from training_and_development_data
GROUP BY TrainingProgramName,TrainingType
ORDER BY TrainingType;

-- 10. What is the total training cost per training type?
SELECT TrainingProgramName, TrainingType,
SUM(TrainingCost) AS Total_Cost
FROM training_and_development_data
GROUP BY TrainingProgramName, TrainingType
ORDER BY TrainingType, Total_Cost DESC;


-- 11. Do employees with successful training outcomes have varying engagement scores?
SELECT 
CASE 
WHEN t.TrainingOutcome = 'Completed' THEN 'Completed'
WHEN t.TrainingOutcome = 'Passed' THEN 'Passed'
WHEN t.TrainingOutcome = 'Failed' THEN 'Failed'
WHEN t.TrainingOutcome = 'Incomplete' THEN 'Incomplete'
ELSE 'Other'
END AS TrainingOutcome,

CASE 
WHEN es.Engagement_Score = 5 THEN '5'
WHEN es.Engagement_Score = 4 THEN '4'
WHEN es.Engagement_Score = 3 THEN '3'
WHEN es.Engagement_Score = 2 THEN '2'
WHEN es.Engagement_Score = 1 THEN '1'
ELSE 'Unknown Score'
END AS EngagementScore,

COUNT(*) AS EmployeeCount
FROM training_and_development_data t
JOIN employee_survey_data es ON t.EmployeeID = es.Employee_ID
GROUP BY 

CASE 
WHEN t.TrainingOutcome = 'Completed' THEN 'Completed'
WHEN t.TrainingOutcome = 'Passed' THEN 'Passed'
WHEN t.TrainingOutcome = 'Failed' THEN 'Failed'
WHEN t.TrainingOutcome = 'Incomplete' THEN 'Incomplete'
ELSE 'Other'
END,

CASE 
WHEN es.Engagement_Score = 5 THEN '5'
WHEN es.Engagement_Score = 4 THEN '4'
WHEN es.Engagement_Score = 3 THEN '3'
WHEN es.Engagement_Score = 2 THEN '2'
WHEN es.Engagement_Score = 1 THEN '1'
ELSE 'Unknown Score'
END

ORDER BY TrainingOutcome, EmployeeCount DESC;



-- 12. Which Position have hired applicants who became high performers?
SELECT e.Title, e.PerformanceScore,
COUNT(*) AS PerformingCount
from employee_data e
JOIN training_and_development_data t
ON e.EmpID = t.EmployeeID
GROUP BY e.Title, e.PerformanceScore
ORDER BY e.PerformanceScore, PerformingCount DESC;


-- 13.  Which Department have percentage of lowperformance score and should be piroritized for more trainings?

SELECT e.DepartmentType,
COUNT(CASE WHEN e.PerformanceScore IN ('PIP') THEN 1 END) AS LowPerformanceCount,
COUNT(*) AS TotalEmployees,
ROUND(COUNT(CASE WHEN e.PerformanceScore IN ('PIP') THEN 1 END) * 100.0 / COUNT(*), 2) AS LowPerformancePercentage
FROM employee_data e
GROUP BY e.DepartmentType
ORDER BY LowPerformancePercentage DESC;


-- 14.  Which department have low performance and low training outcomes?
SELECT e.DepartmentType,e.PerformanceScore,t.TrainingOutcome,
COUNT(*) AS low_performance
FROM employee_data e
JOIN training_and_development_data t
ON e.EmpID = t.EmployeeID
WHERE 
e.PerformanceScore IN ('PIP')   
AND t.TrainingOutcome IN ('Failed', 'Incomplete')      
GROUP BY e.DepartmentType, e.PerformanceScore, t.TrainingOutcome
ORDER BY low_performance DESC;




