-------------------------------------------
--- number of tb patients with TB over time
--------------------------------------------
WITH
  tb_encounters AS (
    SELECT
      visit.visit_start_datetime,
      visit.person_id
    FROM
      `som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_may2025.visit_occurrence` visit
    WHERE
      LOWER(visit_source_value) LIKE '%tumor board%'
      AND visit.visit_start_datetime IS NOT NULL
  ),
  nf AS (
    SELECT 
      DISTINCT person_id
    FROM 
      som-rit-phi-oncology-prod.oncology_neuralframe_phi_irb76049_may2025.onc_neuralframe_case_diagnoses
  ),
  thoracic_pts AS (
    SELECT 
      DISTINCT person_id
    FROM 
      som-rit-phi-oncology-prod.oncology_neuralframe_phi_irb76049_may2025.onc_neuralframe_case_diagnoses
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
      COUNT(DISTINCT tb.person_id) AS total_patients
    FROM 
      tb_encounters tb
    INNER JOIN 
      nf ON tb.person_id = nf.person_id
    INNER JOIN 
      `som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_may2025.image_occurrence` img ON tb.person_id = img.person_id
  ),
  tb_genomic_nf_imaging AS (
    SELECT 
      'tb_genomic_nf_imaging' AS flag,
      COUNT(DISTINCT tb.person_id) AS total_patients
    FROM 
      tb_encounters tb
    INNER JOIN 
      nf ON tb.person_id = nf.person_id
    INNER JOIN 
      `som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_may2025.image_occurrence` img ON tb.person_id = img.person_id
    INNER JOIN 
      `som-rit-phi-oncology-prod.oncology_philips_phi_irb76049_may2025.onc_philips_mtb_pat_diag_orders` genomic ON tb.person_id = genomic.person_id
  )
SELECT * FROM all_tb
UNION ALL
SELECT * FROM tb_nf
UNION ALL 
SELECT * FROM tb_imaging_nf 
UNION ALL
SELECT * FROM tb_genomic_nf_imaging
UNION ALL
SELECT * FROM thoracic_tb