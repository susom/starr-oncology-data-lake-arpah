  --------------------------------------------------------------------
  --- Distribution of variant burden per patient ---
  --------------------------------------------------------------------
  
  WITH patient_variants AS (
    SELECT 
      person_id,
      COUNT(*) AS n_variants_per_patient
    FROM `@oncology_prod.@oncology_omop._variant_occurrence`
    GROUP BY person_id
  )
  SELECT 
    CASE 
      WHEN n_variants_per_patient = 1 THEN '1 variant'
      WHEN n_variants_per_patient BETWEEN 2 AND 5 THEN '2-5 variants'
      WHEN n_variants_per_patient BETWEEN 6 AND 10 THEN '6-10 variants'
      WHEN n_variants_per_patient BETWEEN 11 AND 20 THEN '11-20 variants'
      WHEN n_variants_per_patient > 20 THEN '> 20 variants'
    END AS variant_burden,
    COUNT(DISTINCT person_id) AS n_patients
  FROM patient_variants
  GROUP BY variant_burden
  ORDER BY 
    CASE variant_burden
      WHEN '1 variant' THEN 1
      WHEN '2-5 variants' THEN 2
      WHEN '6-10 variants' THEN 3
      WHEN '11-20 variants' THEN 4
      WHEN '> 20 variants' THEN 5
    END
