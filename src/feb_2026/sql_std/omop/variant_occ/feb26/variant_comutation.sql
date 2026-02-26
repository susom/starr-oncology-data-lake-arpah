-- Get patient-gene mutations for co-mutation analysis
-- Returns each unique person-gene combination

SELECT DISTINCT
  person_id,
  gene_name
FROM 
  `@oncology_prod.@oncology_omop._variant_occurrence`
WHERE 
  gene_name IS NOT NULL
  AND person_id IS NOT NULL;
