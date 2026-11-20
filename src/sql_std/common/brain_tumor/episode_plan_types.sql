-- cohort is supplied by cohort_definition.sql.
SELECT
  COALESCE(JSON_VALUE(e.episode_source_value, '$.plan_type'), 'Unknown') AS plan_type,
  COUNT(DISTINCT c.person_id) AS patient_count,
  COUNT(*) AS episode_rows,
  ROUND(100 * SAFE_DIVIDE(COUNT(DISTINCT c.person_id), (SELECT COUNT(*) FROM cohort)), 1) AS cohort_pct
FROM cohort AS c
JOIN `@oncology_prod.@oncology_omop.episode` AS e USING (person_id)
GROUP BY plan_type
ORDER BY episode_rows DESC, plan_type;
