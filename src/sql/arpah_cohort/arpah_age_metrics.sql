SELECT 
    year_of_birth AS birth_year,
    COUNT(*) AS person_count 
FROM 
    `som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person`
GROUP BY
    birth_year 
    order by person_count desc