-- Thoracic tumor board patients: episodes by plan type and treatment protocol
WITH
tb_visits AS (
  SELECT * FROM `@oncology_prod.@oncology_omop.visit_occurrence`
),
scr AS (
  SELECT * FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
),
tumor_board_patients AS (
  SELECT DISTINCT person_id 
  FROM tb_visits
  WHERE LOWER(visit_source_value) LIKE '%tumor board%'
),
scr_thoracic_patients AS (
  SELECT DISTINCT person_id
  FROM scr
  WHERE LOWER(primarysiteDescription) LIKE '%lung%'
     OR LOWER(primarysiteDescription) LIKE '%bronchus%'
     OR LOWER(primarysiteDescription) LIKE '%thymus%'
),
thoracic_tb_patients AS (
  SELECT DISTINCT tb.person_id
  FROM tumor_board_patients tb
  INNER JOIN scr_thoracic_patients stp USING (person_id)
)
SELECT
  JSON_VALUE(e.episode_source_value, '$.plan_type') AS plan_type,
  JSON_VALUE(e.episode_source_value, '$.treatment_protocol') AS treatment_protocol,
  COUNT(DISTINCT e.person_id) AS n_unique_persons,
  COUNT(*) AS total
FROM `@oncology_prod.@oncology_omop.episode` e
INNER JOIN thoracic_tb_patients ttb USING (person_id)
GROUP BY 1, 2
