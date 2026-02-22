--------------------------
--- Counts of unique patients from both variant_occurrence and Philips ISPM (deduplicated) ---
--------------------------------------------------

WITH variant_pts AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
),
philips_pts AS (
  SELECT DISTINCT person_id
  FROM `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders`
),
combined_pts AS (
  SELECT person_id FROM variant_pts
  UNION DISTINCT
  SELECT person_id FROM philips_pts
)
SELECT 
  COUNT(DISTINCT person_id) AS counts_pts,
  'Philips ISPM/Genomic Data' AS data_set
FROM combined_pts