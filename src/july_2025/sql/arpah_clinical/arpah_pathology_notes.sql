-------------------------------------------
--- arpah-pathology 
--------------------------------------------
  -- pathology --

SELECT
  'pathology_metrics' AS flag,
  COUNT(DISTINCT person_id) AS n_pts,   COUNT(DISTINCT note_id) as n_events
FROM
  som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_may2025.note 
WHERE
  n.note_title IN ('pathology',
    'pathology and cytology')

