--------------------------
--- Counts of unique patients from both variant_occurrence and Philips ISPM (deduplicated) ---
--------------------------------------------------

WITH variant_test AS (
  SELECT DISTINCT accession_number
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
),
philips_test AS (
  SELECT DISTINCT accession_number
  FROM `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders`
),
combined_test AS (
  SELECT accession_number FROM variant_test
  UNION DISTINCT
  SELECT accession_number FROM philips_test
)
SELECT 
  COUNT(DISTINCT accession_number) AS counts_pts,
  'Philips ISPM/Genomic Test' AS data_set
FROM combined_test