-- Distribution of slides per specimen (accession_number)
SELECT
  accession_number AS specimen,
  person_id,
  specimen_source,
  specimen_type,
  COUNT(DISTINCT whole_slide_imaging_id) AS num_slides
FROM `@oncology_prod.@oncology_omop._whole_slide_imaging`
WHERE accession_number IS NOT NULL
GROUP BY accession_number, person_id, specimen_source, specimen_type
ORDER BY num_slides DESC
