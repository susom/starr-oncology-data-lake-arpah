  --------------------------------------------------------------------
  --- Count of patients and variants by interpretation ---
  --------------------------------------------------------------------
  
  SELECT 
    interpretation,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE interpretation IS NOT NULL
  GROUP BY interpretation
  ORDER BY n_variants DESC
