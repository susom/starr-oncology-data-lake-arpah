-- Count distinct specimens, blocks, slides, and files per accession
SELECT
  accession_number,
  COUNT(DISTINCT CONCAT(accession_number, '|', specimen))             AS specimens,
  COUNT(DISTINCT CONCAT(accession_number, '|', specimen, '|', block)) AS blocks,
  COUNT(DISTINCT slide)                                               AS slides,
  COUNT(*)                                                            AS files
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
GROUP BY accession_number
ORDER BY slides DESC
