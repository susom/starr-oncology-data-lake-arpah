

--------------------------------------------------------------
--- number of modality series for thoracic cancer patients ---
--------------------------------------------------------------
WITH person AS (
    SELECT * 
    FROM   `@oncology_prod.@oncology_omop.person`
),
scr AS (
    SELECT * 
    FROM  `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` 
),
scr_data AS (
    SELECT DISTINCT 
        stanford_patient_uid,
        primarySiteDescription, 
        nfcasestatus
    FROM scr 
),
scr_omop AS ( -- nf with omop 
    SELECT DISTINCT
        p.person_id,
        p.person_source_value,
        primarySiteDescription,
        nfcasestatus
    FROM scr_data
    INNER JOIN person p ON json_value(p.person_source_value, '$.stanford_patient_uid')= scr_data.stanford_patient_uid
) , -- 200,715
imaging_data AS (
    SELECT DISTINCT 
        image_study_uid, 
        image_series_uid, 
        JSON_VALUE(modality_source_value, '$.modality') AS modality_source_value, 
        person_id  
    FROM 
          `@oncology_prod.@oncology_omop.image_occurrence`
    WHERE 
        modality_source_value IS NOT NULL 
        AND JSON_VALUE(modality_source_value, '$.modality') NOT IN ('PR', 'KO', 'REG', 'SR')
) , 
thoracic_cancer_patients AS ( --thoracic cancer 
    SELECT 
        person_id
    FROM 
        scr_omop
    WHERE 
        LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
)  -- 13598
SELECT 
    im.modality_source_value, 
    COUNT(*) AS series_count, 
    COUNT(DISTINCT im.person_id) AS unique_person_count, 
    'Number of series in each modality site' AS variable_name
FROM 
    imaging_data im
INNER JOIN 
    thoracic_cancer_patients tc ON im.person_id = tc.person_id
GROUP BY 
    im.modality_source_value
ORDER BY 
    series_count DESC;






