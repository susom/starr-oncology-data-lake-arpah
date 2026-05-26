  --------------------------------------------------------------------
  --- Count of patients and variants by phenotype/variant classification ---
  --------------------------------------------------------------------
  
  SELECT 
    phenotype_spec_var_class,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE phenotype_spec_var_class IS NOT NULL
  GROUP BY phenotype_spec_var_class
  ORDER BY n_variants DESC
