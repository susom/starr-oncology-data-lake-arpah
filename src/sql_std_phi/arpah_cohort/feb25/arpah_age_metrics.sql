SELECT 
    year_of_birth AS birth_year,
    COUNT(*) AS person_count 
FROM 
    `@oncology_prod.@oncology_omop.person`
GROUP BY
    birth_year 
    order by person_count desc