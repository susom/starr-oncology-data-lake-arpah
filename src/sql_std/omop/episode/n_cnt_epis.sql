-- Basic metrics for the episode table
SELECT 
  'total_episodes' AS metric,
  COUNT(*) AS counts
FROM `@oncology_prod.@oncology_omop.episode`
UNION ALL
SELECT 
  'unique_persons' AS metric,
  COUNT(DISTINCT person_id) AS counts
FROM `@oncology_prod.@oncology_omop.episode`
UNION ALL
SELECT 
  'unique_episode_ids' AS metric,
  COUNT(DISTINCT episode_id) AS counts
FROM `@oncology_prod.@oncology_omop.episode`

