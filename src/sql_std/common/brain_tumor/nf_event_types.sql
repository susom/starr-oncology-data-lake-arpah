-- cohort is supplied by cohort_definition.sql.
SELECT
  e.eventtype,
  e.eventtypedescription,
  COUNT(DISTINCT c.person_id) AS patient_count,
  COUNT(DISTINCT e.nfcaseentityid) AS case_count,
  COUNT(DISTINCT e.nfpatienteventid) AS event_count,
  ROUND(100 * SAFE_DIVIDE(COUNT(DISTINCT c.person_id), (SELECT COUNT(*) FROM cohort)), 1) AS cohort_pct
FROM cohort AS c
JOIN `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events` AS e USING (person_id)
WHERE e.eventtype IS NOT NULL
GROUP BY e.eventtype, e.eventtypedescription
ORDER BY event_count DESC, e.eventtype, e.eventtypedescription;
