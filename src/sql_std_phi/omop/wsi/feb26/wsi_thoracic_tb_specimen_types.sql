-- Specimen type distribution for thoracic tumor board patients with WSI files
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
  INNER JOIN scr_thoracic_patients USING (person_id)
)
SELECT 
  COALESCE(w.specimen_type, 'Unknown') AS specimen_type,
  COUNT(*) AS image_count,
  COUNT(DISTINCT w.person_id) AS patient_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging` w
INNER JOIN thoracic_tb_patients ttb ON w.person_id = ttb.person_id
GROUP BY specimen_type
ORDER BY image_count DESC
