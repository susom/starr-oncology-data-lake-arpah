-- Count of unique ordered tests in variant_occurrence table
-- Counts unique procedure_occurrence_id values

SELECT 
  COUNT(DISTINCT procedure_occurrence_id) as n_unique_tests,
  COUNT(DISTINCT person_id) as n_patients,
  COUNT(*) as n_variants
FROM 
 `@oncology_prod.@oncology_omop._variant_occurrence`
WHERE 
  procedure_occurrence_id IS NOT NULL;
