
-----------------------------------------------------------------------
--- Number of pts with thoracic cancer, tb, and image occur records
-----------------------------------------------------------------------
WITH
tb_visits AS (
    SELECT * FROM  `@oncology_prod.@oncology_omop.visit_occurrence`
),
image_occ AS (
    SELECT * FROM `@oncology_prod.@oncology_omop.image_occurrence`
),
scr AS (
    SELECT * FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
tumor_board_patients AS (
    SELECT person_id 
    FROM tb_visits
    WHERE  LOWER(visit_source_value) LIKE '%tumor board%'
),
scr_thoracic_patients AS (
    SELECT DISTINCT person_id
    FROM scr
    WHERE LOWER(primarysiteDescription) LIKE '%lung%'
       OR LOWER(primarysiteDescription) LIKE '%bronchus%'
       OR LOWER(primarysiteDescription) LIKE '%thymus%'
),
tb_thoracic_patients AS (
    SELECT DISTINCT tb.person_id
    FROM tumor_board_patients tb
    INNER JOIN scr_thoracic_patients using (person_id)
) ,
modality_counts AS (
    SELECT 
        modality_source_value, 
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
            image_occ
        WHERE 
            modality_source_value IS NOT NULL 
            AND modality_source_value NOT IN ('PR', 'KO', 'REG', 'SR')
            AND person_id IN (SELECT person_id FROM tb_thoracic_patients)
    ) AS distinct_series
    GROUP BY 
        modality_source_value
)
select * from modality_counts
ORDER BY 
    series_count DESC