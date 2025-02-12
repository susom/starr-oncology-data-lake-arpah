WITH age_data AS (
    SELECT 
        person_id,
        birth_datetime,
        DATE_DIFF(CURRENT_DATE(), EXTRACT(DATE FROM birth_datetime), YEAR) AS current_age
    FROM 
        `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`
)
SELECT 
    current_age_groups,
    COUNT(person_id)/1000 AS count_per1000
FROM (
    SELECT 
        person_id,
        birth_datetime,
        current_age,
CASE 
        WHEN current_age >= 18 AND current_age <= 19 THEN '18-19 years'
        WHEN current_age >= 20 AND current_age <= 29 THEN '20-29 years'
        WHEN current_age >= 30 AND current_age <= 39 THEN '30-39 years'
        WHEN current_age >= 40 AND current_age <= 49 THEN '40-49 years'
        WHEN current_age >= 50 AND current_age <= 59 THEN '50-59 years'
        WHEN current_age >= 60 AND current_age <= 69 THEN '60-69 years'
        WHEN current_age >= 70 AND current_age <= 79 THEN '70-79 years'
        WHEN current_age >= 80 AND current_age <= 89 THEN '80-89 years'
        WHEN current_age >= 90 AND current_age <= 99 THEN '90-99 years'
        WHEN current_age >= 100 THEN 'Above 100 years'
        ELSE 'Unknown'
    END AS current_age_groups
    FROM 
        age_data
) AS categorized_data
GROUP BY 
    current_age_groups
ORDER BY 
    current_age_groups;