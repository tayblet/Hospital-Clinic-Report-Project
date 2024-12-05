---------View Data-------------------
SELECT*
FROM Hospital_Clinical_Data;

-----Create a Back up data----
SELECT*
INTO Hospital_Clinical_Data_Copy
FROM Hospital_Clinical_Data;

------row count----------
SELECT COUNT(*) AS row_count
FROM Hospital_Clinical_Data;

-----column count------------
SELECT COUNT(*) AS column_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Hospital_Clinical_Data';

-----correct the patient_first_inital column name---------
EXEC sp_rename 'Hospital_Clinical_Data.patient_first_inital', 'patient_first_initial', 'COLUMN'

--------------identify and remove duplicates-------------------------
ALTER TABLE Hospital_Clinical_Data
ADD id INT IDENTITY (1,1) NOT NULL;

SELECT*,
ROW_NUMBER() OVER(PARTITION BY date,patient_id,patient_sat_score,patient_first_initial,patient_last_name,patient_race,patient_admin_flag,patient_waittime,
                  department_referral,id ORDER BY id) AS row_num
FROM Hospital_Clinical_Data;

WITH duplicates_values AS(SELECT*,
ROW_NUMBER() OVER(PARTITION BY date,patient_id,patient_sat_score,patient_first_initial,patient_last_name,patient_race,patient_admin_flag,patient_waittime,
                  department_referral,id ORDER BY id) AS row_num
FROM Hospital_Clinical_Data)

SELECT*
FROM duplicates_values
WHERE row_num > 1;       /* No Duplicates */

-----------------------check the null values--------------

SELECT *
FROM Hospital_Clinical_Data
WHERE 
    patient_id IS NULL OR
    patient_sat_score IS NULL OR
    patient_first_initial IS NULL OR
    patient_last_name IS NULL OR
    patient_race IS NULL OR
    patient_admin_flag IS NULL OR
    patient_waittime IS NULL OR
    department_referral IS NULL OR
    id IS NULL;   /* All the NULL Value is in the patient_sat_score which is NULL means No ratings */


-----------------------------------check date column and standardize it---------------------------
ALTER TABLE Hospital_Clinical_Data
ADD year INT,
    time_moment VARCHAR(2),
    month INT,
    month_name VARCHAR(3),
    day INT,
    weekday VARCHAR(20),
    weekend_weekday VARCHAR(10);

UPDATE Hospital_Clinical_Data
SET year = DATEPART(YEAR, date),
    time_moment = FORMAT(date, 'tt'),
    month = DATEPART(MONTH, date),
    month_name = FORMAT(date, 'MMM'),
    day = DATEPART(DAY, date),
    weekday = DATENAME(WEEKDAY, date),
    weekend_weekday = CASE 
                         WHEN DATEPART(WEEKDAY, date) IN (1, 7) THEN 'Weekend'
                         ELSE 'Weekday'
                      END;

-----------------------checking of patient_id rows------
SELECT patient_id
FROM Hospital_Clinical_Data
WHERE LEN(patient_id) < 11 OR LEN(patient_id) > 11;

-----patient_gender-------
SELECT DISTINCT(patient_gender)
FROM Hospital_Clinical_Data;

UPDATE Hospital_Clinical_Data
SET patient_gender = CASE 
                         WHEN patient_gender = 'F' THEN 'Female'
						 WHEN patient_gender = 'M' THEN 'Male'
						 WHEN patient_gender = 'NC' THEN 'Unknown'
                   END;

-------patient_age grouping---------
SELECT DISTINCT(patient_age)
FROM Hospital_Clinical_Data;

ALTER TABLE Hospital_Clinical_Data
ADD age_group VARCHAR (50);

UPDATE Hospital_Clinical_Data
SET age_group = CASE
                    WHEN patient_age < 13 THEN 'Child'
	                WHEN patient_age BETWEEN 13 AND 19 THEN 'Teenager'
					WHEN patient_age BETWEEN 20 AND 35 THEN 'Young Adult'
					WHEN patient_age BETWEEN 36 AND 50 THEN 'Adult'
					WHEN patient_age BETWEEN 51 AND 65 THEN 'Mature Adult'
					WHEN patient_age > 65 THEN 'Senior'
                END;

------------patient satisfaction score --------------  
SELECT DISTINCT(patient_sat_score)
FROM Hospital_Clinical_Data;

-------------create a new column for patient_full_name by Joining patient first_initial name and last name column togethrer ----------------
SELECT CONCAT(patient_first_initial, ' ',patient_last_name) AS patient_full_name
FROM Hospital_Clinical_Data;

ALTER TABLE Hospital_Clinical_Data
ADD patient_full_name VARCHAR(50);

UPDATE Hospital_Clinical_Data
SET patient_full_name = CONCAT(patient_first_initial, ' ',patient_last_name);

-------- patient race -------
SELECT patient_race,COUNT(patient_race)
FROM Hospital_Clinical_Data
GROUP BY patient_race;

-------patient admininistration flag ------------
SELECT DISTINCT(patient_admin_flag)
FROM Hospital_Clinical_Data;

ALTER TABLE Hospital_Clinical_Data
ADD patient_administrative_flag VARCHAR(50);

UPDATE Hospital_Clinical_Data
SET patient_administrative_flag = CASE
                                       WHEN patient_admin_flag = 0 THEN 'None Administrative Appointment'
                                       WHEN patient_admin_flag = 1 THEN 'Administrative Appointment'
                                  END;

----------departmental referral----------------
SELECT DISTINCT (department_referral)
FROM Hospital_Clinical_Data;

------------------drop unused column-----------
ALTER TABLE Hospital_Clinical_Data
DROP COLUMN patient_first_initial;

ALTER TABLE Hospital_Clinical_Data
DROP COLUMN patient_last_name;

ALTER TABLE Hospital_Clinical_Data
DROP COLUMN patient_admin_flag;

ALTER TABLE Hospital_Clinical_Data
DROP COLUMN patient_age;






----------------------------------------------DATA ANALYSIS--------------------------------------------


----(1) Total Patient Visit -----
SELECT COUNT(patient_id)
FROM Hospital_Clinical_Data;

---(2) What is the average patient wait time, and how does it vary by department and patient demographics?

SELECT AVG(patient_waittime) AS avg_waiting_time
FROM Hospital_Clinical_Data;


----(3)------------- Patient Visits by Age Group and Race-----------------
SELECT age_group,
       patient_race,
       COUNT(*) AS total_patient_visit
FROM Hospital_Clinical_Data
-- WHERE age_group = 'Adult'
GROUP BY age_group, patient_race
ORDER BY age_group,total_patient_visit DESC;

     /* Patient Visits by age group only */
SELECT age_group,COUNT(*) AS total_patient_visit
FROM Hospital_Clinical_Data
GROUP BY age_group
ORDER BY 2 DESC;
     /* Patient Visits by Race only */
SELECT patient_race,COUNT(*) AS total_patient_visit
FROM Hospital_Clinical_Data
GROUP BY patient_race
ORDER BY 2 DESC;

----(4) Total visit by week type-----
SELECT weekend_weekday,COUNT(*) AS Total_Visit
FROM Hospital_Clinical_Data
GROUP BY weekend_weekday;

----(5) Total Visit by Gender in percentage --------
WITH TotalCount AS (
                  SELECT COUNT(*) AS Total
				  FROM Hospital_Clinical_Data

) 
SELECT patient_gender,
       COUNT(patient_gender) AS Count,
	   (COUNT(patient_gender)*100.0 / (SELECT Total FROM TotalCount))  AS Percentage
FROM Hospital_Clinical_Data
GROUP BY patient_gender;



-----(6)-----Total visit by Month--------------
SELECT month_name, COUNT(*) AS Patient_Visit
FROM Hospital_Clinical_Data
GROUP BY month_name
ORDER BY Patient_Visit DESC;


-----(7)------Total Visit by Year
SELECT year,COUNT(*) AS Patient_Visit
FROM Hospital_Clinical_Data
GROUP BY year
ORDER BY Patient_Visit DESC;

------(8)-----Total Visit By Department _referral-------------
SELECT department_referral,COUNT(*) AS Count
FROM Hospital_Clinical_Data
GROUP BY department_referral
ORDER BY Count DESC;

    /*----classify None in department_referral as Walk-in patient and others as Referred Patient Visit-- */

WITH TotalCount AS (
    SELECT COUNT(*) AS Total
    FROM Hospital_Clinical_Data
)
SELECT 
    CASE 
        WHEN department_referral = 'None' THEN 'Walk-In Patient'
        ELSE 'Referred Patient'
    END AS Patient_Type,
    COUNT(*) AS Count,
    (COUNT(*) * 100.0 / (SELECT Total FROM TotalCount)) AS Percentage
FROM Hospital_Clinical_Data
GROUP BY 
    CASE 
        WHEN department_referral = 'None' THEN 'Walk-In Patient'
        ELSE 'Referred Patient'
    END
ORDER BY Count DESC;

-----(9) --------patient race avg waiting time on age group------
SELECT patient_race,
       AVG(patient_waittime) AS Avg_waittime,
       age_group
FROM Hospital_Clinical_Data
GROUP BY patient_race, age_group
ORDER BY age_group,Avg_waittime DESC;


-----(10)------------- Patient Administartive apppoint--------------
WITH TotalCount AS (
    SELECT COUNT(*) AS Total
    FROM Hospital_Clinical_Data
)
SELECT patient_administrative_flag,
       COUNT(patient_administrative_flag) AS Count,
       (COUNT(patient_administrative_flag) * 100.0 / (SELECT Total FROM TotalCount)) AS Percentage
FROM Hospital_Clinical_Data
GROUP BY patient_administrative_flag;

----(11)-------------

SELECT 
    AVG(CAST(patient_sat_score AS FLOAT)) AS Avg_Satisfaction,
    (COUNT(*) - COUNT(patient_sat_score)) * 100.0 / COUNT(*) AS Not_Rated_Percentage
FROM Hospital_Clinical_Data




SELECT*
FROM Hospital_Clinical_Data;


