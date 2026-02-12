  --------------------------------------------------------------------
  --- Count of variants by STAMP pipeline version ---
  --------------------------------------------------------------------
  
  SELECT 
    stamp_pipeline_version,
    COUNT(DISTINCT person_id) AS n_patients,
    COUNT(*) AS n_variants,
    COUNT(DISTINCT accession_number) AS n_accessions
  FROM `@oncology_prod.@oncology_omop._variant_occurrence`
  WHERE stamp_pipeline_version IS NOT NULL
  GROUP BY stamp_pipeline_version
  ORDER BY n_variants DESC
