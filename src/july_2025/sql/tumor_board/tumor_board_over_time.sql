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
  all_tb AS (
    SELECT 
      'all_tb' AS flag,
      EXTRACT(YEAR FROM visit_start_datetime) AS year,
      COUNT(*) AS n_tb_encounters,
      COUNT(DISTINCT person_id) AS total_patients
    FROM 
      tb_encounters
    GROUP BY 
      year
    ORDER BY 
      year
  ),
  scr AS (
    SELECT 
      DISTINCT person_id
    FROM 
      som-rit-phi-oncology-prod.oncology_neuralframe_phi_irb76049_may2025.onc_neuralframe_case_diagnoses
    WHERE 
      LOWER(primarysiteDescription) LIKE '%lung%'
      OR LOWER(primarysiteDescription) LIKE '%bronchus%'
      OR LOWER(primarysiteDescription) LIKE '%thymus%'
  ),
  thoracic_tb AS (
    SELECT 
      'thoracic_tb' AS flag,
      EXTRACT(YEAR FROM visit_start_datetime) AS year,
      COUNT(*) AS n_tb_encounters,
      COUNT(DISTINCT person_id) AS total_patients
    FROM 
      tb_encounters
    INNER JOIN 
      scr USING (person_id)
    GROUP BY 
      year
    ORDER BY 
      year
  )
SELECT * FROM all_tb
UNION ALL
SELECT * FROM thoracic_tb




