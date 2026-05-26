  --------------------------------------------------------------------
  --- Count of patients and variants by variant type ---
  --------------------------------------------------------------------
  
  SELECT 
    variant_type,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE variant_type IS NOT NULL
  GROUP BY variant_type
  ORDER BY n_variants DESC
