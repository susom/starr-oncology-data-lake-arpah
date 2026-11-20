-- cohort is supplied by cohort_definition.sql.
SELECT
  CASE WHEN nf.nfcasestatus = 'Incomplete - Edit' THEN 'Incomplete'
       ELSE COALESCE(nf.nfcasestatus, 'Unknown') END AS case_status,
  COUNT(DISTINCT c.person_id) AS patient_count,
  ROUND(100 * SAFE_DIVIDE(COUNT(DISTINCT c.person_id), (SELECT COUNT(*) FROM cohort)), 1) AS cohort_pct
FROM cohort AS c
JOIN `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses` AS nf USING (person_id)
GROUP BY case_status
ORDER BY patient_count DESC, case_status;
