-- Fan-out summary: avg/median/max at each hierarchy level
SELECT
  'Specimens per Accession' AS metric,
  COUNT(*) AS total_count,
  ROUND(AVG(cnt), 1) AS avg_val,
  APPROX_QUANTILES(cnt, 100)[OFFSET(50)] AS median_val,
  MAX(cnt) AS max_val
FROM (
  SELECT accession_number, COUNT(DISTINCT specimen) AS cnt
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1
)
UNION ALL
SELECT
  'Blocks per Specimen', COUNT(*), ROUND(AVG(cnt), 1),
  APPROX_QUANTILES(cnt, 100)[OFFSET(50)], MAX(cnt)
FROM (
  SELECT accession_number, specimen, COUNT(DISTINCT block) AS cnt
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1, 2
)
UNION ALL
SELECT
  'Slides per Block', COUNT(*), ROUND(AVG(cnt), 1),
  APPROX_QUANTILES(cnt, 100)[OFFSET(50)], MAX(cnt)
FROM (
  SELECT accession_number, specimen, block, COUNT(DISTINCT slide) AS cnt
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1, 2, 3
)
