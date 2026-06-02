-- Count slides per specimen
SELECT
  accession_number,
  specimen,
  COUNT(DISTINCT slide) AS num_slides_per_specimen
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
GROUP BY accession_number, specimen
ORDER BY num_slides_per_specimen DESC
