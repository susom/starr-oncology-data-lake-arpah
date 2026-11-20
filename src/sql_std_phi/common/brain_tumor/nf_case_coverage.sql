-- cohort_sql_file supplies the pediatric brain tumor cohort.
SELECT
  COUNT(DISTINCT c.person_id) AS cohort_size,
  COUNT(DISTINCT nf.person_id) AS patients_with_case
FROM cohort AS c
LEFT JOIN `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` AS nf
  USING (person_id)
