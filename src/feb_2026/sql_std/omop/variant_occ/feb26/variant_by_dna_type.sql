  --------------------------------------------------------------------
  --- Count of variants by DNA variant type ---
  --------------------------------------------------------------------
  
  SELECT 
    dna_var_type,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE dna_var_type IS NOT NULL
  GROUP BY dna_var_type
  ORDER BY n_variants DESC
