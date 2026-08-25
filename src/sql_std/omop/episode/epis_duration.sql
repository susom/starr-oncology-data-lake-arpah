-- Basic metrics for the episode table

SELECT 
  'min_episode_start_date' AS metric,
  CAST(MIN(episode_start_date) AS DATE) AS counts
FROM `@oncology_prod.@oncology_omop.episode`
UNION ALL
SELECT 
  'max_episode_start_date' AS metric,
  CAST(MAX(episode_start_date) AS DATE) AS counts
FROM `@oncology_prod.@oncology_omop.episode`
UNION ALL
SELECT 
  'min_episode_end_date' AS metric,
  CAST(MIN(episode_end_date) AS DATE) AS counts
FROM `@oncology_prod.@oncology_omop.episode`
UNION ALL
SELECT 
  'max_episode_end_date' AS metric,
  CAST(MAX(episode_end_date) AS DATE) AS counts
FROM `@oncology_prod.@oncology_omop.episode`

