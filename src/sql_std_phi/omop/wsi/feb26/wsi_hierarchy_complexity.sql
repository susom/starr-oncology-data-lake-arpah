-- Accession complexity distribution
SELECT
  CASE
    WHEN specimens = 1 AND blocks = 1 AND slides = 1 THEN '1 specimen / 1 block / 1 slide'
    WHEN specimens = 1 AND blocks = 1 THEN '1 specimen / 1 block / multi-slide'
    WHEN specimens = 1 THEN '1 specimen / multi-block'
    ELSE 'Multi-specimen'
  END AS complexity,
  COUNT(*) AS accessions,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS pct
FROM (
  SELECT
    accession_number,
    COUNT(DISTINCT specimen) AS specimens,
    COUNT(DISTINCT CONCAT(specimen, '|', block)) AS blocks,
    COUNT(DISTINCT slide) AS slides
  FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
  GROUP BY 1
)
GROUP BY 1
ORDER BY accessions DESC
