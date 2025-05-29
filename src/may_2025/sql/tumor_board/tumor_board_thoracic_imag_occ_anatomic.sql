
-----------------------------------------------------------------------
--- Number of pts with thoracic cancer, tb, and image occur records
-----------------------------------------------------------------------
WITH
person AS (
    SELECT * FROM `@oncology_prod.@oncology_omop.person`
),
all_flag AS (
    SELECT * FROM `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`
),
image_occ AS (
    SELECT * FROM `@oncology_prod.@oncology_omop.image_occurrence`
),
scr AS (
    SELECT * FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
tumor_board_patients AS (
    SELECT person_source_value 
    FROM all_flag
    WHERE tumor_board_encounter_flag = 1
),
scr_thoracic_patients AS (
    SELECT DISTINCT stanford_patient_uid
    FROM scr
    WHERE LOWER(primarysiteDescription) LIKE '%lung%'
       OR LOWER(primarysiteDescription) LIKE '%bronchus%'
       OR LOWER(primarysiteDescription) LIKE '%thymus%'
),
person_img AS (
    SELECT person_source_value , image_occ.person_id
    FROM person 
    INNER JOIN image_occ USING (person_id)
),
tb_thoracic_patients AS (
    SELECT DISTINCT person_img.person_id
    FROM tumor_board_patients tb
    INNER JOIN person_img ON person_img.person_source_value = tb.person_source_value
    INNER JOIN scr_thoracic_patients ON person_img.person_source_value = scr_thoracic_patients.stanford_patient_uid
) ,
anatomic_counts AS (
    SELECT 
        anatomic_site_source_value, 
        COUNT(*) AS series_count, 
        COUNT(DISTINCT person_id) AS unique_person_count, 
        'Number of series in each anatomic' AS variable_name
    FROM (
        SELECT DISTINCT 
            image_study_uid, 
            image_series_uid, 
         anatomic_site_source_value, 
            person_id  
        FROM 
            image_occ
        WHERE 
            anatomic_site_source_value IS NOT NULL 
            AND person_id IN (SELECT person_id FROM tb_thoracic_patients)
    ) AS distinct_series
    GROUP BY 
        anatomic_site_source_value
)
select * from anatomic_counts
ORDER BY 
    series_count DESC