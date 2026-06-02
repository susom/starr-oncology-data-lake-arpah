-- Distribution of specimens per accession
SELECT
  cnt AS value,
  COUNT(*) AS frequency
FROM (
  SELECT accession_number, COUNT(DISTINCT specimen) AS cnt
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1
)
GROUP BY cnt
ORDER BY cnt
