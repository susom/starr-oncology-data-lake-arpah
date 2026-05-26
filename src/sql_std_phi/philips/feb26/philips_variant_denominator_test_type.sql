--------------------------
--- Counts of unique accession numbers by test type from both variant_occurrence and Philips ISPM (deduplicated) ---
--------------------------------------------------

WITH variant_test AS (
  SELECT DISTINCT test_type, accession_number
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
),
philips_test AS (
  SELECT DISTINCT test_type, accession_number
  FROM `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders`
),
combined_test AS (
  SELECT test_type, accession_number FROM variant_test
  UNION DISTINCT
  SELECT test_type, accession_number FROM philips_test
)
SELECT 
  test_type,
  COUNT(DISTINCT accession_number) AS test_type_counts
FROM combined_test
GROUP BY test_type
ORDER BY test_type_counts DESC