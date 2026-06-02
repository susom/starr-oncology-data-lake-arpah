-- Distribution of slides per block
SELECT
  cnt AS value,
  COUNT(*) AS frequency
FROM (
  SELECT accession_number, specimen, block, COUNT(DISTINCT slide) AS cnt
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1, 2, 3
)
GROUP BY cnt
ORDER BY cnt
