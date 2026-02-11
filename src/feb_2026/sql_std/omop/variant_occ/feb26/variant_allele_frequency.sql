  --------------------------------------------------------------------
  --- Distribution of variant allelic frequency (VAF) ---
  --------------------------------------------------------------------
  
  SELECT 
    CASE 
      WHEN allelic_frequency < 0.05 THEN '< 5%'
      WHEN allelic_frequency >= 0.05 AND allelic_frequency < 0.10 THEN '5-10%'
      WHEN allelic_frequency >= 0.10 AND allelic_frequency < 0.25 THEN '10-25%'
      WHEN allelic_frequency >= 0.25 AND allelic_frequency < 0.50 THEN '25-50%'
      WHEN allelic_frequency >= 0.50 AND allelic_frequency < 0.75 THEN '50-75%'
      WHEN allelic_frequency >= 0.75 THEN '>= 75%'
      ELSE 'Unknown'
    END AS vaf_range,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  GROUP BY vaf_range
  ORDER BY 
    CASE vaf_range
      WHEN '< 5%' THEN 1
      WHEN '5-10%' THEN 2
      WHEN '10-25%' THEN 3
      WHEN '25-50%' THEN 4
      WHEN '50-75%' THEN 5
      WHEN '>= 75%' THEN 6
      ELSE 7
    END
