# Hospital-Clinic-Report-Project


## Table of Contents
- [Hospital Patients Visit Reports 2019-2020 Overview](#hospital-patients-visit-reports-2019-2020-overview)
- [Data Source](#data-source)
- [Landing Page](#landing-page)
- [Tools](#tools)
- [Data Cleaning](#data-cleaning)
- [Key Business Questions](#key-business-questions)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Visualization](#DASHBOARD)
- [Key Insights](#key-insights)
- [RECOMMENDATIONS](#recommendations)

## Hospital Patients Visit Reports 2019-2020 Overview
The Hospital Patients Visit Reports for 2019-2020 provide a detailed analysis of patient visits, encompassing key metrics such as average wait times, patient satisfaction, total monthly visits, administrative vs. non-administrative appointments, referrals and walk-in patients, and demographics by age group and race. The insights drawn from this data help highlight areas for improvement in hospital operations and patient care, offering actionable recommendations to enhance efficiency, satisfaction, and overall service quality. By implementing these strategies, the hospital can better meet the needs of its diverse patient population and optimize healthcare delivery.

## Data Source
The data source is from my Mentor for Practise 
[Download the dataset here](https://drive.google.com/file/d/1h7SHRhKeP9jP1axeYRtKg-TE3UldhiYx/view)

## Landing Page
| Column Name         | Data Type | Description                                                            |
|---------------------|-----------|------------------------------------------------------------------------|
| date                | DateTime  | Timestamp of patient record creation or visit.                         |
| patient_id          | String    | Unique identifier for each patient.                                    |
| patient_gender      | String    | Gender of the patient (e.g., M for Male, F for Female).                |
| patient_age         | Integer   | Age of the patient in years.                                           |
| patient_sat_score   | Integer   | Patient satisfaction score on a scale (e.g., 1–10); null if missing.   |
| patient_first_initial| String   | First letter of the patient’s first name.                              |
| patient_last_name   | String    | Last name of the patient.                                              |
| patient_race        | String    | Race/ethnicity of the patient.                                         |
| patient_admin_flag  | Boolean   | Indicates if the patient has administrative issues (TRUE/FALSE).       |
| patient_waittime    | Integer   | Time the patient waited (in minutes).                                  |
| department_referral | String    | Department to which the patient is referred; None if not referred.     |

## Tools
- Microsoft Excel: Exploring the data before importing to SQL Server Management Studio
- SQL Server Management Studio: Data cleaning, testing, and analyzing the data
- Power BI: Visualizing the data via an interactive dashboard
- GitHub: Hosting the project documentation and version control

### Data Cleaning
These processes were carried out using SQL Server Management Studio:
- **Create a Backup Data**
  - Created a backup copy of the original dataset to ensure data integrity.
- **Row and Column Count**
  - Verified the dataset's size by checking the number of rows and columns.
- **Correct the Column Name**
  - Corrected the column name `patient_first_inital` to `patient_first_initial` for accuracy.
- **Identify and Remove Duplicates**
  - Added an identity column to uniquely identify each row.
  - Checked for and confirmed no duplicate rows in the dataset.
- **Check Null Values**
  - Identified that all null values were in the `patient_sat_score` column, indicating no ratings provided.
- **Standardize Date Column**
  - Added and populated new columns for year, time moment, month, month name, day, weekday, and weekend/weekday to facilitate analysis.
- **Check `patient_id` Rows**
  - Ensured all `patient_id` values have a consistent length of 11 characters.
- **Standardize `patient_gender`**
  - Standardized values in the `patient_gender` column to "Female", "Male", and "Other".
- **Group `patient_age`**
  - Added and populated an `age_group` column to categorize patients into age groups.
- **Create `patient_full_name`**
  - Created a new column `patient_full_name` by concatenating `patient_first_initial` and `patient_last_name`.
- **Standardize `patient_admin_flag`**
  - Created a new column `patient_administrative_flag` to categorize administrative appointments.
- **Drop Unused Columns**
  - Removed unnecessary columns: `patient_first_initial`, `patient_last_name`, `patient_admin_flag`, and `patient_age`.

## Key Business Questions
1. **Average Wait Time**: Discover how long patients typically wait before their appointments. Uncover patterns and trends that shed light on the efficiency of our healthcare system.
2. **Patient Satisfaction**: We'll explore the average satisfaction scores given by our patients. Learn about the factors that contribute to a positive patient experience and how we can enhance it.
3. **Total Patient Visits Monthly**: Get an overview of the ebb and flow of patients through our doors each month. Understand the dynamics of healthcare demand over time.
4. **Administrative vs. Non-Administrative Appointments**: Delve into the data to distinguish between appointments that involve administrative processes and those that don't. Explore the impact on wait times and patient satisfaction.
5. **Referrals and Walk-In Patients**: Uncover the balance between patients referred to specific departments and those who walk in without prior referral. How does this impact the overall patient experience?
6. **Patient Visits by Age Group and Race**: Explore the distribution of patient visits across different age groups and races. Gain insights into the diversity of healthcare needs and preferences.

## Exploratory Data Analysis
### Primary KPIs
1. Average Wait Time: 35.26 minutes
2. Patient Satisfaction Score: 5.47
3. Monthly Patient Volume: 431 (lowest in January), 1,024 (highest in August)
4. Percentage of Walk-In vs. Referred Patients: Walk-In: 58.59%, Referred: 41.41%
5. Equity in Wait Times: Longer wait times for older adults (51–65 and 65+) and certain racial groups

### Secondary KPIs
1. Total Patient Visits (Yearly):
   - Total patients: 9,216
   - Year 2019: 4,878
   - Year 2020: 4,338
2. Administrative vs. Non-Administrative Appointments:
   - Administrative: 50.04%
   - Non-Administrative: 49.96%
3. Patient Volume by Weekday vs. Weekend:
   - Weekday: 6,574
   - Weekend: 2,642
4. Average Wait Time by Age Group:
   - Seniors (51–65 and 65+): Longer wait times
5. Patient Satisfaction:
   - 75.10% of patients did not provide feedback
   - 24.90% of patients gave feedback
6. Peak Month Resource Utilization:
   - Highest in August (1,024 visits)
   - Lowest in February (431 visits)

### Overview of Patients Visit by Gender/Sex
- Male Patients: 51.05% of total visits (4,708 patients).
- Female Patients: 48.69% of total visits (4,487 patients).
- Unknown Gender: 0.26% of total visits (21 patients).

### Overview of Patients Visit by Year
- 2019: 4,878 visits (52.93% of total).
- 2020: 4,338 visits (47.07% of total).




### DASHBOARD
![Hospital Patients Visit](https://github.com/tayblet/Hospital-Clinic-Report-Project/blob/fed99aea2ec6bcd054fd0e5de33633979152d67a/Hospital%20Patients%20Visit%20pic.PNG)



### Key Insights

- **Average Wait Time**:
  - **Finding**: Patients experience an average wait time of 35.26 minutes.
  - **Impact**: Longer wait times are likely contributing to lower patient satisfaction scores.

- **Patient Satisfaction**:
  - **Finding**: The average satisfaction score is 5.47, with a significant portion of unfilled feedback (75.10%).
  - **Impact**: Enhancing the feedback process and addressing key areas of concern can improve overall patient satisfaction.

- **Total Patient Visits Monthly**:
  - **Finding**: Patient visits peak in August (1,024 visits) and are lowest in February (431 visits).
  - **Impact**: Understanding these trends helps in resource planning and managing patient flow throughout the year.

- **Administrative vs. Non-Administrative Appointments**:
  - **Finding**: Appointments are almost evenly split between administrative (50.04%) and non-administrative (49.96%).
  - **Impact**: Evaluating and streamlining administrative processes can reduce inefficiencies and improve the overall patient experience.

- **Referrals and Walk-In Patients**:
  - **Finding**: Walk-in patients constitute 58.59% of total visits, while referred patients make up 41.41%.
  - **Impact**: Managing the balance between referred and walk-in patients is crucial for optimizing departmental workloads and improving patient care.

- **Patient Visits by Age Group and Race**:
  - **Finding**: Young adults and adults are the largest age groups visiting the hospital, with a diverse racial distribution of patients.
  - **Impact**: Tailoring health services and outreach programs to the needs of these groups ensures cultural competence and inclusivity in healthcare delivery.

### Recommendations

1. **Reduce Average Wait Time**:
   - Optimize scheduling systems and staffing levels, especially during peak hours and for age groups with longer wait times (e.g., seniors aged 51+).
   - Introduce a triage system to prioritize patients based on urgency and healthcare needs.

2. **Improve Patient Satisfaction**:
   - Actively collect feedback by incentivizing patient surveys to reduce the 75.10% non-response rate.
   - Enhance the patient’s experience by addressing common concerns (e.g., wait times, staff interaction).

3. **Balance Monthly Patient Volume**:
   - Use predictive analytics to prepare for high-demand months (e.g., August) by increasing staffing and resources.
   - Introduce appointment reminders and follow-up systems to reduce no-shows during less busy months (e.g., February).

4. **Streamline Administrative Processes**:
   - Automate repetitive administrative tasks to reduce delays for appointments involving paperwork.
   - Implement pre-visit check-ins or online portals to complete administrative steps before arriving at the hospital.

5. **Manage Walk-In Patient Flow**:
   - Encourage pre-scheduling by educating patients about referral processes and benefits.
   - Expand dedicated walk-in clinics or urgent care units to handle unscheduled visits efficiently.

6. **Ensure Equity in Wait Times**:
   - Analyze and address disparities in wait times by age group and race to ensure fair access to healthcare services.
   - Implement training programs for staff to manage diverse patient needs effectively.

7. **Enhance Weekend Service Availability**:
   - Extend weekend hours to reduce weekday congestion and provide flexibility for patients unable to visit during weekdays.
   - Gradually scale weekend operations based on demand patterns.

8. **Focus on High-Demand Departments**:
   - Assess bottlenecks in departments with high patient loads, such as General Practice and Orthopedics, and allocate additional staff/resources accordingly.
   - Use data-driven insights to optimize department workflows and reduce delays.

9. **Leverage Technology**:
   - Use digital tools (e.g., mobile apps) for appointment scheduling, reminders, and real-time updates on wait times.
   - Implement telehealth services to reduce in-person visits for non-critical cases.

10. **Resource Allocation for Peak Months**:
    - Develop contingency plans for high-demand months like August, ensuring adequate staff, equipment, and infrastructure.
    - Monitor patient inflow patterns to dynamically allocate resources where needed most.

 

