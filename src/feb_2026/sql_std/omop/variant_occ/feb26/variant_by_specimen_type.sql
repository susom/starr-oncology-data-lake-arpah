SELECT 
  specimen_type,
  COUNT(DISTINCT variant_occurrence_id) as n_variants,
  COUNT(DISTINCT person_id) as n_patients
FROM `@oncology_omop._variant_occurrence`
WHERE specimen_type IS NOT NULL
GROUP BY specimen_type
ORDER BY n_variants DESC;
