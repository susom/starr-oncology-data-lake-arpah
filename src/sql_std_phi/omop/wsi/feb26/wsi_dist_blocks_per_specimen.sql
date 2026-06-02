-- Distribution of blocks per specimen
SELECT
  cnt AS value,
  COUNT(*) AS frequency
FROM (
  SELECT accession_number, specimen, COUNT(DISTINCT block) AS cnt
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1, 2
)
GROUP BY cnt
ORDER BY cnt
