--------------------------
--- Counts of unique patients and accession numbers from both variant_occurrence and Philips ISPM (deduplicated) ---
--------------------------------------------------

WITH philips_data AS (
  SELECT DISTINCT person_id, accession_number
  FROM `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders`
),
variant_data AS (
  SELECT DISTINCT person_id, accession_number
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
),
combined AS (
  SELECT person_id, accession_number FROM philips_data
  UNION DISTINCT
  SELECT person_id, accession_number FROM variant_data
)
SELECT 
  COUNT(DISTINCT person_id) AS counts_pts,
  COUNT(DISTINCT accession_number) AS n_acc,
  'Philips ISPM' AS data_set
FROM combined
