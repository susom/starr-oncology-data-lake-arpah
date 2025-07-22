    ---------------------------------------------------------------
    --- Pulling all unique person_ids from different datasets
    ---------------------------------------------------------------
    
    SELECT DISTINCT person_id, 'Oncology OMOP' AS data_set 
    FROM @oncology_prod.@oncology_omop.person
    
    UNION ALL 
    
    SELECT DISTINCT person_id , 'Image Occurrence' AS data_set 
    FROM @oncology_prod.@oncology_omop.image_occurrence
    
    UNION ALL
    
    SELECT DISTINCT p.person_id, 'Neural Frame' AS data_set 
    FROM @oncology_prod.@oncology_omop.person p
    INNER JOIN @oncology_prod.@oncology_neuralframe.onc_neuralframe_case_outcomes nf
    ON p.person_source_value = nf.stanford_patient_uid
    
    UNION ALL 
    
    SELECT DISTINCT p.person_id, 'Philips ISPM' AS data_set 
    FROM @oncology_prod.@oncology_omop.person p
    INNER JOIN @oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders phi
    ON p.person_source_value = phi.stanford_patient_uid

    UNION ALL
    SELECT DISTINCT person_id, 'Tumor Board' AS data_set
    FROM @oncology_prod.@oncology_omop.visit_occurrence
    where LOWER(visit_source_value) LIKE '%tumor board%'