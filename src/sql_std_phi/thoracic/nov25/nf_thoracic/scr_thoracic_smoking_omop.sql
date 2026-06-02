
--------------------------------------------------------------------------
-- Smoking Status in OMOP 
---------------------------------------------------------------------------

WITH scr AS (
    SELECT * 
    FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
scr_data AS ( -- thoracic cancer pts 
    SELECT DISTINCT 
        stanford_patient_uid,
        primarySiteDescription,
        nfcasestatus
    FROM scr
    WHERE
        LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
),
scr_omop AS ( -- thoracic cancer pts in omop 
    SELECT DISTINCT
        p.person_id,
        p.person_source_value,
        sd.primarySiteDescription
    FROM scr_data sd
    INNER JOIN `@oncology_prod.@oncology_omop.person` p 
        ON json_value(p.person_source_value, '$.stanford_patient_uid')= sd.stanford_patient_uid
),
observation AS (
    SELECT 
        o.person_id,
        o.value_as_string AS smoking_status,
        o.observation_date,
        ROW_NUMBER() OVER (PARTITION BY o.person_id ORDER BY o.observation_date DESC) AS rn
    FROM `@oncology_prod.@oncology_omop.observation` o
    INNER JOIN scr_omop USING(person_id)
    WHERE 
        o.observation_concept_id = 43054909  -- Smoking status concept ID
) 
SELECT 
    smoking_status, 
    COUNT(DISTINCT person_id) AS unique_person_count
FROM 
    observation
    WHERE 
    rn = 1  -- Get only the most recent smoking status
GROUP BY  smoking_status
ORDER BY smoking_status desc;  