-- Specimen source breakdown for high-volume patients (50+ images)
WITH high_volume_patients AS (
  SELECT person_id
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY person_id
  HAVING COUNT(*) >= 50
)
SELECT 
  COALESCE(w.specimen_source, 'Unknown') AS specimen_source,
  COUNT(*) AS image_count,
  COUNT(DISTINCT w.person_id) AS patient_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging` w
INNER JOIN high_volume_patients h ON w.person_id = h.person_id
GROUP BY specimen_source
ORDER BY image_count DESC
