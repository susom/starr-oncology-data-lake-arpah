  --------------------------------------------------------------------
  --- Variants with linkage to clinical visits and procedures ---
  --------------------------------------------------------------------
  
  SELECT 
    CASE 
      WHEN visit_occurrence_id IS NOT NULL AND procedure_occurrence_id IS NOT NULL THEN 'Both Visit & Procedure'
      WHEN visit_occurrence_id IS NOT NULL THEN 'Visit Only'
      WHEN procedure_occurrence_id IS NOT NULL THEN 'Procedure Only'
      ELSE 'No Linkage'
    END AS linkage_type,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  GROUP BY linkage_type
  ORDER BY n_variants DESC
