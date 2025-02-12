SELECT 
    year_of_birth AS birth_year,
    COUNT(*) AS person_count 
FROM 
    `bigquery-public-data.cms_synthetic_patient_data_omop.person`
GROUP BY
    birth_year 
    order by person_count desc