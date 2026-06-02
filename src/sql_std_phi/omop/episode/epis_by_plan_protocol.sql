SELECT
  JSON_VALUE(episode_source_value, '$.plan_type') AS plan_type,
  JSON_VALUE(episode_source_value, '$.treatment_protocol') AS treatment_protocol,
  COUNT(DISTINCT person_id) AS n_unique_persons,
  COUNT(*) AS total
FROM `@oncology_prod.@oncology_omop.episode`
GROUP BY 1, 2
