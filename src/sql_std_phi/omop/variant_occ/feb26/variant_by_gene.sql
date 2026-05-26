  --------------------------------------------------------------------
  --- Count of patients and variants by gene ---
  --------------------------------------------------------------------
  
  SELECT 
    gene_name,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE gene_name IS NOT NULL
  GROUP BY gene_name
  ORDER BY n_patients DESC, n_variants DESC
