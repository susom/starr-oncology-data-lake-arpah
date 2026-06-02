  --------------------------------------------------------------------
  --- Variant occurrence in tumor board patients ---
  --------------------------------------------------------------------
  
WITH
  tb_pts AS (
    SELECT DISTINCT person_id
    FROM `@oncology_prod.@oncology_omop.visit_occurrence`
    WHERE LOWER(visit_source_value) LIKE '%tumor board%'
  )

SELECT
  COUNT(DISTINCT v.person_id) AS n_tumor_board_patients,
  COUNT(*) AS n_variants
FROM `@oncology_prod.@oncology_omop._variant_occurrence` v
INNER JOIN tb_pts t ON v.person_id = t.person_id
