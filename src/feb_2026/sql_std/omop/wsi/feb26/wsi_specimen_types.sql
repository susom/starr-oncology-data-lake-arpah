-- Distribution of specimen types
SELECT 
  COALESCE(specimen_type_name, 'Unknown') AS specimen_type,
  COUNT(*) AS image_count,
  COUNT(DISTINCT person_id) AS patient_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
GROUP BY specimen_type_name
ORDER BY image_count DESC
