-- =========================================
-- OMOP Metrics Template SQL (All Months)
-- Placeholders: @oncology_prod.@oncology_omop_feb, @oncology_neuralframe_feb, etc.
-- =========================================

WITH vital_concepts AS (
    /*
    Spec: At least one vital: height, weight, blood pressure, BMI, or temperature
    */
    SELECT conc.*
    FROM `@oncology_prod.@oncology_omop.concept_ancestor` ca
    INNER JOIN `@oncology_prod.@oncology_omop.concept` conc
      ON ca.descendant_concept_id = conc.concept_id
    WHERE ancestor_concept_id IN (
        3036277, 3025315, 45876174, 1002813, 4245997, 1004059, 4178505
    )
    AND conc.standard_concept = 'S'
),

smoking_concepts AS (
    SELECT conc.*
    FROM `@oncology_prod.@oncology_omop.concept_relationship` cr 
    INNER JOIN `@oncology_prod.@oncology_omop.concept` conc
      ON cr.concept_id_2 = conc.concept_id
    WHERE cr.concept_id_1 IN (
        SELECT concept_id
        FROM `@oncology_prod.@oncology_omop.concept`
        WHERE concept_code IN (
            'Z87.891', 'F17.20', 'F17.200', 'F17.201', 
            'F17.203', 'F17.208', 'F17.209', 'F17.21', 
            'F17.210', 'F17.211', 'F17.213', 'F17.218', 
            'F17.219'
        )
    )
    AND conc.standard_concept = 'S'
    AND cr.relationship_id = 'Maps to'
)

-- =========================================
-- Metrics
-- =========================================


SELECT 'total_patients', COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.visit_occurrence`

UNION DISTINCT 

SELECT 'total_pt_gt_12', 
       COUNT(DISTINCT per.person_id)
FROM `@oncology_prod.@oncology_omop.person` per
JOIN `@oncology_prod.@oncology_omop.visit_occurrence` vis
  ON per.person_id = vis.person_id
WHERE per.birth_datetime IS NOT NULL
  AND DATE_DIFF(vis.visit_start_date, per.birth_datetime, YEAR) > 12

UNION DISTINCT 

SELECT 'uniq_pt_with_age', 
       COUNT(DISTINCT per.person_id)
FROM `@oncology_prod.@oncology_omop.person` per
JOIN `@oncology_prod.@oncology_omop.visit_occurrence` vis
  ON per.person_id = vis.person_id
WHERE per.birth_datetime IS NOT NULL

UNION DISTINCT 

SELECT 'uniq_pt_loinc',
       COUNT(DISTINCT person_id)
FROM (
    SELECT person_id
    FROM `@oncology_prod.@oncology_omop.measurement` meas
    JOIN `@oncology_prod.@oncology_omop.concept` conc
      ON meas.measurement_concept_id = conc.concept_id
     AND conc.vocabulary_id = 'LOINC'
    UNION DISTINCT
    SELECT person_id
    FROM `@oncology_prod.@oncology_omop.observation` obs
    JOIN `@oncology_prod.@oncology_omop.concept` conc
      ON obs.observation_concept_id = conc.concept_id
     AND conc.vocabulary_id = 'LOINC'
) AS per

UNION DISTINCT 

SELECT 'uniq_pt_med_rxnorm',
       COUNT(DISTINCT drug.person_id)
FROM `@oncology_prod.@oncology_omop.drug_exposure` drug
JOIN `@oncology_prod.@oncology_omop.concept` conc
  ON drug.drug_concept_id = conc.concept_id
WHERE conc.vocabulary_id IN ('RxNorm', 'NDC')

UNION DISTINCT 

SELECT 'uniq_pt_icd_dx',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.condition_occurrence`
WHERE condition_concept_id IN (
    SELECT cr.concept_id_2
    FROM `@oncology_prod.@oncology_omop.concept` c1
    JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
      ON c1.concept_id = cr.concept_id_1
    WHERE relationship_id = 'Maps to'
      AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
)

UNION DISTINCT 

SELECT 'uniq_pt_snomed_dx',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.condition_occurrence`
WHERE condition_concept_id IN (
    SELECT cr.concept_id_2
    FROM `@oncology_prod.@oncology_omop.concept` c1
    JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
      ON c1.concept_id = cr.concept_id_1
    WHERE relationship_id = 'Maps to'
      AND c1.vocabulary_id = 'SNOMED'
)

UNION DISTINCT 

SELECT 'uniq_pt_icd_proc',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.procedure_occurrence`
WHERE procedure_concept_id IN (
    SELECT cr.concept_id_2
    FROM `@oncology_prod.@oncology_omop.concept` c1
    JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
      ON c1.concept_id = cr.concept_id_1
    WHERE relationship_id = 'Maps to'
      AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
)

UNION DISTINCT 

SELECT 'uniq_pt_cpt',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.procedure_occurrence`
WHERE procedure_concept_id IN (
    SELECT cr.concept_id_2
    FROM `@oncology_prod.@oncology_omop.concept` c1
    JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
      ON c1.concept_id = cr.concept_id_1
    WHERE relationship_id = 'Maps to'
      AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
)

UNION DISTINCT 

SELECT 'uniq_pt_snomed_proc',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.procedure_occurrence`
WHERE procedure_concept_id IN (
    SELECT cr.concept_id_2
    FROM `@oncology_prod.@oncology_omop.concept` c1
    JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
      ON c1.concept_id = cr.concept_id_1
    WHERE relationship_id = 'Maps to'
      AND c1.vocabulary_id = 'SNOMED'
)

UNION DISTINCT 

SELECT 'uniq_pt_note',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.note`

UNION DISTINCT 

SELECT 'uniq_pt_smoking',
       COUNT(DISTINCT person_id)
FROM (
    SELECT person_id
    FROM `@oncology_prod.@oncology_omop.condition_occurrence`
    WHERE condition_concept_id IN (
        SELECT concept_id
        FROM smoking_concepts
        WHERE domain_id = 'Condition'
    )
    UNION DISTINCT
    SELECT person_id
    FROM `@oncology_prod.@oncology_omop.observation`
    WHERE observation_concept_id IN (
        SELECT concept_id
        FROM smoking_concepts
        WHERE domain_id = 'Observation'
    )
) AS combined_smoking

UNION DISTINCT 

SELECT 'uniq_pt_opioid',
       COUNT(DISTINCT person_id)
FROM (
    SELECT person_id
    FROM `@oncology_prod.@oncology_omop.condition_occurrence`
    WHERE condition_concept_id IN (
        SELECT descendant_concept_id
        FROM `@oncology_prod.@oncology_omop.concept_ancestor`
        WHERE ancestor_concept_id = 4032799
    ) 
    AND condition_start_date BETWEEN CAST('2022-05-01' AS DATE) AND CAST('2023-04-30' AS DATE)
    UNION DISTINCT
    SELECT person_id
    FROM `@oncology_prod.@oncology_omop.drug_exposure`
    WHERE drug_concept_id IN (
        SELECT descendant_concept_id
        FROM `@oncology_prod.@oncology_omop.concept_ancestor`
        WHERE ancestor_concept_id IN (1103640, 1133201)
    )
) AS opioid_patients

UNION DISTINCT 

SELECT 'uniq_pt_any_insurance_value',
       COUNT(DISTINCT person_id)
FROM `@oncology_prod.@oncology_omop.payer_plan_period`;
