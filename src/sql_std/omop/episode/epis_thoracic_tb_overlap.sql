-- Thoracic tumor board patients with episode records
-- Counts overlap between TB+thoracic patients and episode table
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
),
episode_patients AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_omop.episode`
),
thoracic_tb_episode AS (
  SELECT DISTINCT ttb.person_id
  FROM thoracic_tb_patients ttb
  INNER JOIN episode_patients ep USING (person_id)
)
SELECT
  (SELECT COUNT(*) FROM thoracic_tb_patients) AS thoracic_tb_total,
  (SELECT COUNT(*) FROM episode_patients) AS episode_total_patients,
  (SELECT COUNT(*) FROM thoracic_tb_episode) AS thoracic_tb_with_episodes
