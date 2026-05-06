  --------------------------------------------------------------------
  --- Count of variants by specimen type and source ---
  --------------------------------------------------------------------
  
  SELECT 
    specimen_type,
    specimen_source,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE specimen_type IS NOT NULL OR specimen_source IS NOT NULL
  GROUP BY specimen_type, specimen_source
  ORDER BY n_variants DESC
