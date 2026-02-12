  --------------------------------------------------------------------
  --- Count of variants by chromosome ---
  --------------------------------------------------------------------
  
  SELECT 
    chromosome,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE chromosome IS NOT NULL
  GROUP BY chromosome
  ORDER BY 
    CASE 
      WHEN chromosome IN ('X', 'Y', 'MT', 'M') THEN 99
      ELSE CAST(chromosome AS INT64)
    END
