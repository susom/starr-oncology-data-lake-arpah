-- Count of variants by phenotype specific variant class
-- Groups variants by phenotype_spec_var_class

SELECT 
  phenotype_spec_var_class,
  COUNT(DISTINCT person_id) as n_patients,
  COUNT(*) as n_variants
FROM 
  `@oncology_prod.@oncology_omop._variant_occurrence`
WHERE 
  phenotype_spec_var_class IS NOT NULL
GROUP BY 
  phenotype_spec_var_class
ORDER BY 
  n_variants DESC;
