-------------------------------------------
--- number of tb patients with TB over time
--------------------------------------------
with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
tumor_board_patients 
AS ( select person_source_value from all_flag
where tumor_board_encounter_flag = 1
),
tb_encounters AS (
  select DISTINCT
    p.person_id,
    tb.person_source_value
  from
    tumor_board_patients tb
  inner join person p on p.person_source_value = tb.person_source_value
),

  nf AS (
    SELECT 
      DISTINCT p.person_id
    FROM 
      `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` scr_data
    INNER JOIN person p ON p.person_source_value = concat(scr_data.cleaned_nf_mrn, ' | ', scr_data.cleaned_nf_dob)
  ),
  thoracic_pts AS (
    SELECT 
      DISTINCT p.person_id
    FROM 
      `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` scr_data
    INNER JOIN person p ON p.person_source_value = concat(scr_data.cleaned_nf_mrn, ' | ', scr_data.cleaned_nf_dob)
    WHERE 
      LOWER(scr_data.primarysiteDescription) LIKE '%lung%'
      OR LOWER(scr_data.primarysiteDescription) LIKE '%bronchus%'
      OR LOWER(scr_data.primarysiteDescription) LIKE '%thymus%'
  ),
  all_tb AS (
    SELECT 
      'all_tb' AS flag,
      COUNT(DISTINCT person_id) AS total_patients
    FROM 
      tb_encounters
  ),
  thoracic_tb AS (
    SELECT 
      'thoracic_tb' AS flag,
      COUNT(DISTINCT tb.person_id) AS total_patients
    FROM 
      tb_encounters tb
    INNER JOIN 
      thoracic_pts thoracic ON tb.person_id = thoracic.person_id
  ),
  tb_nf AS (
    SELECT 
      'tb_nf' AS flag,
      COUNT(DISTINCT tb.person_id) AS total_patients
    FROM 
      tb_encounters tb
    INNER JOIN 
      nf ON tb.person_id = nf.person_id
  ),
  tb_imaging_nf AS (
    SELECT 
      'tb_imaging_nf' AS flag,
      COUNT(DISTINCT tb.person_id) AS total_patients
    FROM 
      tb_encounters tb
    INNER JOIN 
      nf ON tb.person_id = nf.person_id
    INNER JOIN 
      `@oncology_prod.@oncology_omop.image_occurrence` img ON tb.person_id = img.person_id
  )
SELECT * FROM all_tb
UNION ALL
SELECT * FROM tb_nf
UNION ALL 
SELECT * FROM tb_imaging_nf 
UNION ALL
SELECT * FROM thoracic_tb