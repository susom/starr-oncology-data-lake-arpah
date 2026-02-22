-- Distribution of specimen sources
SELECT 
  COALESCE(specimen_source_name, 'Unknown') AS specimen_source,
  COUNT(*) AS image_count,
  COUNT(DISTINCT person_id) AS patient_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
GROUP BY specimen_source_name
ORDER BY image_count DESC
