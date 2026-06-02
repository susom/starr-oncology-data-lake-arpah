-- Temporal trends of whole slide imaging by year
SELECT 
  EXTRACT(YEAR FROM procedure_start_time) AS year,
  COUNT(*) AS image_count,
  COUNT(DISTINCT person_id) AS patient_count,
  COUNT(DISTINCT accession_number) AS accession_count
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
WHERE procedure_start_time IS NOT NULL
GROUP BY year
ORDER BY year DESC
