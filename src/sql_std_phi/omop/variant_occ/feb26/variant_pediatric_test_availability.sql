-- cohort_sql_file supplies the pediatric brain tumor cohort.
SELECT
  COUNT(DISTINCT c.person_id) AS cohort_size,
  COUNT(DISTINCT v.person_id) AS patients_with_test_type
FROM cohort AS c
LEFT JOIN `@oncology_prod.@oncology_omop._variant_occurrence` AS v
  ON v.person_id = c.person_id
  AND NULLIF(TRIM(v.test_name), '') IS NOT NULL
  AND LOWER(TRIM(v.test_name)) != 'unknown or missing'
