  --------------------------------------------------------------------
  --- Distribution of copy number variations ---
  --------------------------------------------------------------------
  
  WITH cnv_data AS (
    SELECT 
      person_id,
      gene_name,
      copy_number_lower,
      copy_number_upper,
      CASE 
        WHEN copy_number_lower IS NULL AND copy_number_upper IS NULL THEN 'No CNV data'
        WHEN copy_number_upper < 2 THEN 'Loss (< 2 copies)'
        WHEN copy_number_lower = 2 AND copy_number_upper = 2 THEN 'Normal (2 copies)'
        WHEN copy_number_lower > 2 THEN 'Gain (> 2 copies)'
        ELSE 'Variable'
      END AS cnv_category
    FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  )
  SELECT 
    cnv_category,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants
  FROM cnv_data
  GROUP BY cnv_category
  ORDER BY n_variants DESC
