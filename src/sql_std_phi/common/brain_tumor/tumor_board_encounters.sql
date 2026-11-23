SELECT
  COUNT(DISTINCT c.person_id) AS cohort_patients,
  COUNT(DISTINCT v.person_id) AS tumor_board_patients,
  COUNT(DISTINCT v.visit_occurrence_id) AS tumor_board_encounters
FROM cohort AS c
LEFT JOIN `@oncology_prod.@oncology_omop.visit_occurrence` AS v
  ON c.person_id = v.person_id
  AND LOWER(v.visit_source_value) LIKE '%tumor board%'
