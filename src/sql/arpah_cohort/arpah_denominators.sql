
WITH oncology_count AS (
    SELECT COUNT(DISTINCT person_id) AS counts_pts
    FROM som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_feb2025.person
)
SELECT 
    counts_pts, 
    data_set, 
    (counts_pts * 100.0 / (SELECT counts_pts FROM oncology_count)) AS percentage
FROM (
    SELECT COUNT(DISTINCT person_id) AS counts_pts, 'Oncology OMOP' AS data_set 
    FROM som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_feb2025.person
    
    UNION ALL 
    
    SELECT COUNT(DISTINCT person_id) AS counts_pts, 'Image Occurrence' AS data_set 
    FROM som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_feb2025.image_occurrence
    
    UNION ALL
    
    SELECT COUNT(DISTINCT stanford_patient_uid) AS counts_pts, 'Neural Frame' AS data_set 
    FROM som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_feb2025.person p
    INNER JOIN som-rit-phi-oncology-prod.oncology_neuralframe_phi_irb76049_feb2025.onc_neuralframe_case_outcomes nf
    ON p.person_source_value = nf.stanford_patient_uid
    
    UNION ALL 
    
    SELECT COUNT(DISTINCT stanford_patient_uid) AS counts_pts, 'Philips ISBM' AS data_set 
    FROM som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_feb2025.person p
    INNER JOIN som-rit-phi-oncology-dev.star_8788_onc_philips_ispm_starr_common_2025_03_16.onc_philips_mtb_pat_diag_orders phi
    ON p.person_source_value = phi.stanford_patient_uid
) AS counts 
