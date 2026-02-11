-- Distribution of images per patient
WITH patient_image_counts AS (
  SELECT 
    person_id,
    COUNT(*) AS image_count
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY person_id
)
SELECT 
  CASE 
    WHEN image_count = 1 THEN '1 image'
    WHEN image_count BETWEEN 2 AND 5 THEN '2-5 images'
    WHEN image_count BETWEEN 6 AND 10 THEN '6-10 images'
    WHEN image_count BETWEEN 11 AND 20 THEN '11-20 images'
    WHEN image_count BETWEEN 21 AND 50 THEN '21-50 images'
    ELSE '50+ images'
  END AS image_count_range,
  COUNT(*) AS patient_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM patient_image_counts
GROUP BY image_count_range
ORDER BY 
  CASE 
    WHEN image_count_range = '1 image' THEN 1
    WHEN image_count_range = '2-5 images' THEN 2
    WHEN image_count_range = '6-10 images' THEN 3
    WHEN image_count_range = '11-20 images' THEN 4
    WHEN image_count_range = '21-50 images' THEN 5
    ELSE 6
  END
