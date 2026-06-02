  --------------------------------------------------------------------
  --- Variant occurrence in thoracic cancer patients ---
  --------------------------------------------------------------------
  
WITH
  thoracic_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
    WHERE LOWER(primarysiteDescription) LIKE '%lung%'
       OR LOWER(primarysiteDescription) LIKE '%bronchus%'
       OR LOWER(primarysiteDescription) LIKE '%thymus%'
  )

SELECT
  COUNT(DISTINCT v.person_id) AS n_thoracic_patients,
  COUNT(*) AS n_variants
FROM `@oncology_prod.@oncology_omop._variant_occurrence` v
INNER JOIN thoracic_pts t ON v.person_id = t.person_id
