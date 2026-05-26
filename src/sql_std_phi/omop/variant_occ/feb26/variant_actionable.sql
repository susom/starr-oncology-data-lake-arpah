  --------------------------------------------------------------------
  --- Count of actionable variants (by interpretation and assessment) ---
  --------------------------------------------------------------------
  
  SELECT 
    gene_name,
    variant_molecular_consequence,
    interpretation,
    assessment,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE interpretation IS NOT NULL
     OR assessment IS NOT NULL
  GROUP BY gene_name, variant_molecular_consequence, interpretation, assessment
  ORDER BY n_patients DESC, n_variants DESC
