-- Thoracic tumor board patients with whole slide imaging files
-- Counts overlap between TB+thoracic patients and WSI table
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
wsi_patients AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
),
thoracic_tb_wsi AS (
  SELECT DISTINCT ttb.person_id
  FROM thoracic_tb_patients ttb
  INNER JOIN wsi_patients wp USING (person_id)
)
SELECT
  (SELECT COUNT(*) FROM thoracic_tb_patients) AS thoracic_tb_total,
  (SELECT COUNT(*) FROM wsi_patients) AS wsi_total,
  (SELECT COUNT(*) FROM thoracic_tb_wsi) AS thoracic_tb_with_wsi
