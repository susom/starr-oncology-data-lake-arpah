  --------------------------------------------------------------------
  --- Count of patients and variants by variant molecular consequence ---
  --------------------------------------------------------------------
  
  SELECT 
    variant_molecular_consequence,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE variant_molecular_consequence IS NOT NULL
  GROUP BY variant_molecular_consequence
  ORDER BY n_variants DESC
