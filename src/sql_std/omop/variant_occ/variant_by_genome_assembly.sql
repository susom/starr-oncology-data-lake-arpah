  --------------------------------------------------------------------
  --- Variants by genome assembly version ---
  --------------------------------------------------------------------
  
  SELECT 
    genome_assembly,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE genome_assembly IS NOT NULL
  GROUP BY genome_assembly
  ORDER BY n_variants DESC
