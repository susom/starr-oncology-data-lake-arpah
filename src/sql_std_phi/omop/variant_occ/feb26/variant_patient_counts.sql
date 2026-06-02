  --------------------------------------------------------------------
  --- Total count of patients and variants in variant_occurrence ---
  --------------------------------------------------------------------
  
  SELECT  
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
