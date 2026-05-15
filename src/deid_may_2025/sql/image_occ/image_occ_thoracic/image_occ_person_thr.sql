
--------------------------------------------------------
--- number of unique series and number of unique pts ---
--------------------------------------------------------
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
        person_id as nf_person_id,
        primarySiteDescription, 
        nfcasestatus
    FROM scr 
),
scr_omop AS ( -- nf with omop 
    SELECT DISTINCT
        p.person_id,
        primarySiteDescription,
        nfcasestatus
    FROM scr_data
    INNER JOIN person p ON p.person_id = scr_data.nf_person_id
) , -- 200,715
imaging_data AS (
    SELECT DISTINCT 
        image_study_uid, 
        image_series_uid, 
        person_id  
    FROM 
          `@oncology_prod.@oncology_omop.image_occurrence`
),
thoracic_cancer_patients AS ( --thoracic cancer 
    SELECT 
        person_id
    FROM 
        scr_omop
    WHERE 
        LOWER(primarySiteDescription) LIKE '%lung%'
        OR LOWER(primarySiteDescription) LIKE '%bronchus%'
        OR LOWER(primarySiteDescription) LIKE '%thymus%'
) ,
thoracic_cancer_imaging_data AS (
    SELECT DISTINCT 
        image_study_uid, 
        image_series_uid, 
        person_id  
    FROM 
          imaging_data
    WHERE 
        person_id IN (SELECT person_id FROM thoracic_cancer_patients)
)
SELECT COUNT(*) AS counts, 'Number of series in image_occurrence table' AS variable_name
FROM (
    SELECT DISTINCT image_study_uid, image_series_uid
    FROM thoracic_cancer_imaging_data
) AS distinct_series

UNION ALL

SELECT COUNT(DISTINCT person_id) AS counts, 'Number of unique persons in image_occurrence table' AS variable_name
FROM thoracic_cancer_imaging_data
UNION ALL
SELECT COUNT(DISTINCT person_id) AS counts, 'Number of unique persons with thoracic cancer' AS variable_name
FROM thoracic_cancer_patients