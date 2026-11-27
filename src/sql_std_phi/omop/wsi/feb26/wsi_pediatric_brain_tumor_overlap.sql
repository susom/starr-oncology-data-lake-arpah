-- cohort_sql_file supplies the pediatric brain tumor cohort.
SELECT
  COUNT(DISTINCT c.person_id) AS cohort_size,
  COUNT(DISTINCT w.person_id) AS patients_with_wsi
FROM cohort AS c
LEFT JOIN `@oncology_prod.@oncology_omop._whole_slide_imaging` AS w
  ON w.person_id = c.person_id
