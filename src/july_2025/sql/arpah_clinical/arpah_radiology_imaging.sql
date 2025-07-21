-------------------------------------------
--- arpah-radiology-imaging
--------------------------------------------

SELECT
'radiology_metrics' AS flag,
  COUNT(DISTINCT _accession_number) AS n_events,
  count(distinct person_id) AS n_pts
FROM
  som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_may2025.image_occurrence
WHERE
  modality_source_value IN ('CT',
    'MG',
    'PT',
    'CR',
    'XA',
    'DX',
    'US',
    'RF',
    'MR',
    'NM')

