--------------------------------------------------------------------
--- Specimen types used for thoracic tumor board patients ---
--------------------------------------------------------------------

WITH
  -- Tumor board patients
  tb_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_omop.visit_occurrence`
    WHERE LOWER(visit_source_value) LIKE '%tumor board%'
  ),
  -- Thoracic cancer patients from NeuralFrame
  thoracic_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
    WHERE LOWER(primarysiteDescription) LIKE '%lung%'
       OR LOWER(primarysiteDescription) LIKE '%bronchus%'
       OR LOWER(primarysiteDescription) LIKE '%thymus%'
  ),
  -- Patients with both tumor board and thoracic cancer
  thoracic_tb_pts AS (
    SELECT DISTINCT tb.person_id
    FROM tb_pts tb
    INNER JOIN thoracic_pts th ON tb.person_id = th.person_id
  )

SELECT
  v.specimen_type,
  COUNT(*) AS n_variants,
  COUNT(DISTINCT v.person_id) AS n_patients
FROM `@oncology_prod.@oncology_omop._variant_occurrence` v
INNER JOIN thoracic_tb_pts t ON v.person_id = t.person_id
WHERE v.specimen_type IS NOT NULL
GROUP BY v.specimen_type
ORDER BY n_variants DESC
