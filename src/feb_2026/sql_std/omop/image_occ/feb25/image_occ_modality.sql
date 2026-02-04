
----------------------------------
--- number of modality series ---
--- For Feb-Aug 2025: Direct column access (no JSON)
----------------------------------

SELECT 
    modality_source_value AS modality, 
    COUNT(*) AS series_count, 
    COUNT(DISTINCT person_id) AS unique_person_count, 
    'Number of series in each modality' AS variable_name
FROM (
    SELECT DISTINCT 
        image_study_uid, 
        image_series_uid, 
        modality_source_value, 
        person_id  
    FROM 
        `@oncology_prod.@oncology_omop.image_occurrence`
    WHERE 
        modality_source_value IS NOT NULL 
        AND modality_source_value NOT IN ('PR', 'KO', 'REG', 'SR')
) AS distinct_series
GROUP BY 
    modality_source_value
ORDER BY 
    series_count DESC;