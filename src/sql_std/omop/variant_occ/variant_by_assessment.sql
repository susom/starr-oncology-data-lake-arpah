  --------------------------------------------------------------------
  --- Count of variants by assessment (tier classification) ---
  --------------------------------------------------------------------
  
  SELECT 
    assessment,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE assessment IS NOT NULL
  GROUP BY assessment
  ORDER BY n_variants DESC
