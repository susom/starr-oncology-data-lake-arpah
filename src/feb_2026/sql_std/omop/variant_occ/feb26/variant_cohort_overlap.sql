  --------------------------------------------------------------------
  --- Variant occurrence overlap with tumor board and thoracic patients ---
  --------------------------------------------------------------------
  
WITH
  variant_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  ),
  tb_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_omop.visit_occurrence`
    WHERE LOWER(visit_source_value) LIKE '%tumor board%'
  ),
  thoracic_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`
    WHERE LOWER(primarysiteDescription) LIKE '%lung%'
       OR LOWER(primarysiteDescription) LIKE '%bronchus%'
       OR LOWER(primarysiteDescription) LIKE '%thymus%'
  )

SELECT
  'Total variant patients' AS category,
  COUNT(DISTINCT v.person_id) AS n_patients
FROM variant_pts v

UNION ALL

SELECT
  'Variants with tumor board' AS category,
  COUNT(DISTINCT v.person_id) AS n_patients
FROM variant_pts v
INNER JOIN tb_pts t ON v.person_id = t.person_id

UNION ALL

SELECT
  'Variants with thoracic cancer' AS category,
  COUNT(DISTINCT v.person_id) AS n_patients
FROM variant_pts v
INNER JOIN thoracic_pts th ON v.person_id = th.person_id

UNION ALL

SELECT
  'Variants with both tumor board and thoracic' AS category,
  COUNT(DISTINCT v.person_id) AS n_patients
FROM variant_pts v
INNER JOIN tb_pts t ON v.person_id = t.person_id
INNER JOIN thoracic_pts th ON v.person_id = th.person_id

ORDER BY 
  CASE category
    WHEN 'Total variant patients' THEN 1
    WHEN 'Variants with tumor board' THEN 2
    WHEN 'Variants with thoracic cancer' THEN 3
    WHEN 'Variants with both tumor board and thoracic' THEN 4
  END
