  --------------------------------------------------------------------
  --- Count of variants by test name/assay ---
  --------------------------------------------------------------------
  
  SELECT 
    test_name,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants,
    COUNT(DISTINCT gene_name) AS n_unique_genes
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE test_name IS NOT NULL
  GROUP BY test_name
  ORDER BY n_variants DESC
