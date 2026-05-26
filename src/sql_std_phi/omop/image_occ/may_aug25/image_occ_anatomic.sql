
----------------------------------
--- number of anatomic series ---
-----------------------------------
SELECT 
    anatomic_site_source_value AS anatomic_site, 
    COUNT(*) AS series_count, 
    COUNT(DISTINCT person_id) AS unique_person_count, 
    'Number of series in each anatomic site' AS variable_name
FROM (
    SELECT DISTINCT 
        image_study_uid, 
        image_series_uid, 
        anatomic_site_source_value, 
        person_id  
    FROM 
        `@oncology_prod.@oncology_omop.image_occurrence`
    WHERE 
        anatomic_site_source_value IS NOT NULL
) AS distinct_series
GROUP BY 
    anatomic_site_source_value
ORDER BY 
    series_count DESC;