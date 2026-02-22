-- Count of unique ordered tests in variant_occurrence table
-- Counts unique procedure_occurrence_id values

SELECT 
 variant_molecular_consequence,
  SAFE_CAST(allelic_frequency AS FLOAT64) AS allelic_frequency
FROM 
 `@oncology_prod.@oncology_omop._variant_occurrence`
WHERE 
  variant_molecular_consequence IS NOT NULL;
