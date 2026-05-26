-------------------------------------------
--- number of tb patients with TB over time
--------------------------------------------
WITH
  tb_encounters AS (
    SELECT
      visit.visit_start_datetime,
      visit.person_id
    FROM
      `@oncology_omop.visit_occurrence` visit
    WHERE
      LOWER(visit_source_value) LIKE '%tumor board%'
      AND visit.visit_start_datetime IS NOT NULL
  ),
  nf AS (
    SELECT 
      DISTINCT person_id
    FROM 
      `@oncology_neuralframe.onc_neuralframe_case_diagnoses`
  ),
  thoracic_pts AS (
    SELECT 
      DISTINCT person_id
    FROM 
      `@oncology_neuralframe.onc_neuralframe_case_diagnoses`
    WHERE 
      LOWER(primarysiteDescription) LIKE '%lung%'
      OR LOWER(primarysiteDescription) LIKE '%bronchus%'
      OR LOWER(primarysiteDescription) LIKE '%thymus%'
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
      COALESCE(COUNT(DISTINCT tb.person_id), 0) AS total_patients
    FROM 
      tb_encounters tb
    INNER JOIN 
      nf ON tb.person_id = nf.person_id
    LEFT JOIN 
      `@oncology_omop.image_occurrence` img ON tb.person_id = img.person_id
    WHERE img.person_id IS NOT NULL
  )
SELECT * FROM all_tb
UNION ALL
SELECT * FROM tb_nf
UNION ALL 
SELECT * FROM tb_imaging_nf 
UNION ALL
SELECT * FROM thoracic_tb
  
  