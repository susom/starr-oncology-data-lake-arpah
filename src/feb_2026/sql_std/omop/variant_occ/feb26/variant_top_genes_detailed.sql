  --------------------------------------------------------------------
  --- Top 20 most frequently mutated genes with variant details ---
  --------------------------------------------------------------------
  
  SELECT 
    gene_name,
    variant_type,
    variant_molecular_consequence,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE gene_name IS NOT NULL
  GROUP BY gene_name, variant_type, variant_molecular_consequence
  ORDER BY n_patients DESC, n_variants DESC
  LIMIT 20
