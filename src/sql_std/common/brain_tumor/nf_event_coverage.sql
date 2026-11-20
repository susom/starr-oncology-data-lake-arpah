-- cohort is supplied by cohort_definition.sql.
SELECT
  COUNT(DISTINCT c.person_id) AS cohort_size,
  COUNT(DISTINCT e.person_id) AS patients_with_event
FROM cohort AS c
LEFT JOIN `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events` AS e
  USING (person_id)
