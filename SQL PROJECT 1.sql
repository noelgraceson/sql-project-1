------to know the disribution of time spend in hospital in general------

SELECT time_in_hospital AS total_days, COUNT(*) AS count,
rpad('', COUNT(*)/100, '^' ) AS number
FROM diabetes.diabetic_data
group by total_days
order by total_days asc;

------ to list of all specialties and the average total of the number of procedures currently practiced at the hospital-------

SELECT DISTINCT medical_specialty, count(medical_specialty) AS total,
ROUND(avg(num_procedures),0) AS average_procedures
FROM diabetes.diabetic_data
WHERE NOT medical_specialty= '?'
group by medical_specialty
order by average_procedures DESC;

------to list all specialities with at least 50 patients and more than 1 procedures on average---------

SELECT DISTINCT medical_specialty, count(medical_specialty) AS total,
ROUND(avg(num_procedures),0) AS average_procedures
FROM diabetes.diabetic_data
GROUP BY medical_specialty
HAVING total > '50' and average_procedures > 1 
and medical_specialty <> '?'
ORDER BY average_procedures DESC

-------to know if the hospital seems to be treating patients of different races differently, specifically with the number of lab procedures done-----

SELECT race, round(AVG(num_lab_procedures),0) as average_number_lab_procedures
from diabetes.diabetic_data
group by race
order by average_number_lab_procedures desc

--------to know if people need more procedures if they stay longer in the hospital-------

SELECT MIN(num_lab_procedures) as minimum, ROUND(avg(num_lab_procedures),0) as average,
max(num_lab_procedures) as maximum from diabetes.diabetic_data

------based on this the number of procedures into 3 different categories, few(0-25), average(25-50) and more(>50)------

SELECT  ROUND(AVG(time_in_hospital),0) AS days_in_hospital,
(CASE 
WHEN num_lab_procedures >= 0 and num_lab_procedures < 25 then 'few'
WHEN num_lab_procedures >= 25 and num_lab_procedures < 50 then 'average'
ELSE 'more'
END)  AS frequnecy_of_procedures
 FROM diabetes.diabetic_data
 GROUP BY frequnecy_of_procedures
 order by days_in_hospital asc
 
 ------to get patient ids of anyone who is African American or had an “Up” for metformin------ 
 
 SELECT patient_nbr FROM diabetes.diabetic_data 
 WHERE race= 'AfricanAmerican'
 UNION 
 SELECT patient_nbr FROM diabetes.diabetic_data 
 WHERE metformin= 'Up'

 -------to count the total number of targeted patienst from the above step------
 
WITH total_patients AS 
(SELECT patient_nbr FROM diabetes.diabetic_data 
 WHERE race= 'AfricanAmerican'
 UNION 
 SELECT patient_nbr FROM diabetes.diabetic_data 
 WHERE metformin= 'Up') 
 SELECT COUNT(patient_nbr)
FROM total_patients

-------to find situations when patients came into the hospital with an emergency but stayed less than the average time in the hospital-------

SELECT DISTINCT COUNT(*) AS total_patients
FROM diabetes.diabetic_data

-----compare this with------

WITH average_time_in_hospital AS
(SELECT AVG(time_in_hospital)
from diabetes.diabetic_data)
SELECT COUNT(*) AS completed_cases
FROM diabetes.diabetic_data
WHERE admission_type_id= 1
AND time_in_hospital< (SELECT * FROM average_time_in_hospital)


-------to write a summary for the top 50 medication patients, and break any ties with the number of lab procedure by following the hospital’s format in descending order-----

SELECT CONCAT('Patient ', patient_nbr, ' was ',  race, ' and', 
CASE 
WHEN readmitted= ' NO' THEN ' was not readmitted'
ELSE ' was readmitted'END,
 ' They had ', num_medications, ' medications and ', num_lab_procedures, ' lab procedures') AS summary
 FROM diabetes.diabetic_data
 ORDER BY num_medications DESC, num_lab_procedures DESC
 LIMIT 50
 
----- to find how ages of patients affect their level of diabetes------

SELECT  DISTINCT age, insulin, diabetesMed AS 'medicine' 
FROM diabetes.diabetic_data
ORDER BY age DESC

