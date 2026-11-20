-- Supply common/brain_tumor/cohort_definition.sql as cohort_sql_file.
, cohort_episodes AS (
  SELECT
    e.person_id,
    COALESCE(NULLIF(TRIM(JSON_VALUE(e.episode_source_value, '$.plan_type')), ''), '(Not recorded)') AS plan_type,
    COALESCE(NULLIF(TRIM(JSON_VALUE(e.episode_source_value, '$.treatment_protocol')), ''), '(Not recorded)') AS treatment_protocol
  FROM `@oncology_prod.@oncology_omop.episode` AS e
  INNER JOIN cohort USING (person_id)
)
SELECT
  CASE
    WHEN GROUPING(plan_type) = 1 THEN 'overall'
    WHEN GROUPING(treatment_protocol) = 1 THEN 'plan'
    ELSE 'protocol'
  END AS summary_level,
  plan_type,
  treatment_protocol,
  COUNT(DISTINCT person_id) AS patients,
  COUNT(*) AS episodes,
  (SELECT COUNT(*) FROM cohort) AS cohort_size
FROM cohort_episodes
GROUP BY ROLLUP(plan_type, treatment_protocol)
