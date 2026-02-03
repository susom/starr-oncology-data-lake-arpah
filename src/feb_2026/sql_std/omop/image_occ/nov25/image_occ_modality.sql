
----------------------------------
--- number of modality series ---
-----------------------------------

SELECT 
    modality, 
    COUNT(*) AS series_count, 
    COUNT(DISTINCT person_id) AS unique_person_count, 
    'Number of series in each modality' AS variable_name
FROM (
    SELECT DISTINCT 
        image_study_uid, 
        image_series_uid, 
        JSON_VALUE(modality_source_value, '$.modality') AS modality, 
        person_id  
    FROM 
        `@oncology_prod.@oncology_omop.image_occurrence`
    WHERE 
        modality_source_value IS NOT NULL 
        AND JSON_VALUE(modality_source_value, '$.modality') NOT IN ('PR', 'KO', 'REG', 'SR')
) AS distinct_series
GROUP BY 
    modality
ORDER BY 
    series_count DESC;