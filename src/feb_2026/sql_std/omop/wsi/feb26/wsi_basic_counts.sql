-- Basic counts for whole slide imaging dataset
SELECT 
  'total_images' AS metric,
  COUNT(*) AS counts
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`

UNION ALL

SELECT 
  'unique_patients' AS metric,
  COUNT(DISTINCT person_id) AS counts
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`

UNION ALL

SELECT 
  'unique_accessions' AS metric,
  COUNT(DISTINCT accession_number) AS counts
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`

UNION ALL

SELECT 
  'with_json' AS metric,
  COUNT(*) AS counts
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
WHERE json_uri IS NOT NULL

UNION ALL

SELECT 
  'with_tiff' AS metric,
  COUNT(*) AS counts
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
WHERE tiff_uri IS NOT NULL

ORDER BY metric
