WITH vital_concepts AS (
    /*
    Spec: At least one vital: height, weight, blood pressure, BMI, or temperature
    */
    SELECT conc.*
    FROM `@oncology_prod.@oncology_omop.concept_ancestor` ca
    INNER JOIN `@oncology_prod.@oncology_omop.concept` conc
    ON ca.descendant_concept_id = conc.concept_id
    WHERE ancestor_concept_id IN (
        3036277,  -- height
        3025315,  -- weight
        45876174, -- blood pressure
        1002813,  -- BMI
        4245997,  -- BMI alternative
        1004059,  -- temperature
        4178505   -- temperature alternative
    )
    AND conc.standard_concept = 'S'
),

smoking_concepts AS (
    SELECT DISTINCT conc.*
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
        AND vocabulary_id IN ('ICD10CM', 'ICD9CM')
    )
    AND conc.standard_concept = 'S'
    AND cr.relationship_id = 'Maps to'
    AND conc.domain_id IN ('Condition', 'Observation')
    -- Ensure we only get smoking-related concepts
    AND (
        LOWER(conc.concept_name) LIKE '%smok%' 
        OR LOWER(conc.concept_name) LIKE '%tobacco%'
        OR LOWER(conc.concept_name) LIKE '%nicotine%'
    )
)

SELECT 
    'data_model' AS variable_name,
    (SELECT 2 AS all_years) AS all_years -- 2 = OMOP

UNION DISTINCT 

SELECT 
    'total_patients' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id) 
        FROM `@oncology_prod.@oncology_omop.visit_occurrence`
    ) AS all_years

UNION DISTINCT 

SELECT 
    'total_pt_gt_12' AS variable_name,
    (
        SELECT COUNT(DISTINCT per.person_id) 
        FROM `@oncology_prod.@oncology_omop.person` per
        INNER JOIN `@oncology_prod.@oncology_omop.visit_occurrence` vis
        ON per.birth_datetime IS NOT NULL 
        AND per.person_id = vis.person_id
        WHERE DATE_DIFF(vis.visit_start_date, per.birth_datetime, YEAR) > 12
    ) AS all_years 

UNION DISTINCT 

SELECT 
    'uniq_pt_with_age' AS variable_name,
    (
        SELECT COUNT(DISTINCT per.person_id) 
        FROM `@oncology_prod.@oncology_omop.person` per
        INNER JOIN `@oncology_prod.@oncology_omop.visit_occurrence` vis
        ON per.birth_datetime IS NOT NULL 
        AND per.person_id = vis.person_id
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_loinc' AS variable_name,
    (
        SELECT COUNT(DISTINCT per.person_id) 
        FROM (
            SELECT person_id
            FROM `@oncology_prod.@oncology_omop.measurement` meas
            INNER JOIN `@oncology_prod.@oncology_omop.concept` conc
            ON conc.vocabulary_id = 'LOINC'
            AND meas.measurement_concept_id = conc.concept_id
            UNION DISTINCT 
            SELECT person_id
            FROM `@oncology_prod.@oncology_omop.observation` obs
            INNER JOIN `@oncology_prod.@oncology_omop.concept` conc
            ON conc.vocabulary_id = 'LOINC'
            AND obs.observation_concept_id = conc.concept_id
        ) AS per
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_med_rxnorm' AS variable_name,
    (
        SELECT COUNT(DISTINCT drug.person_id) 
        FROM `@oncology_prod.@oncology_omop.drug_exposure` drug
        INNER JOIN `@oncology_prod.@oncology_omop.concept` conc
        ON drug.drug_concept_id = conc.concept_id
        WHERE conc.vocabulary_id IN ('RxNorm', 'NDC')
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_icd_dx' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.condition_occurrence`
        WHERE condition_concept_id IN (
            SELECT cr.concept_id_2
            FROM `@oncology_prod.@oncology_omop.concept` c1
            INNER JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
            ON c1.concept_id = cr.concept_id_1
            WHERE relationship_id = 'Maps to'
            AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
        )
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_snomed_dx' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.condition_occurrence`
        WHERE condition_concept_id IN (
            SELECT cr.concept_id_2
            FROM `@oncology_prod.@oncology_omop.concept` c1
            INNER JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
            ON c1.concept_id = cr.concept_id_1
            WHERE relationship_id = 'Maps to'
            AND c1.vocabulary_id = 'SNOMED'
        )
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_icd_proc' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.procedure_occurrence`
        WHERE procedure_concept_id IN (
            SELECT cr.concept_id_2
            FROM `@oncology_prod.@oncology_omop.concept` c1
            INNER JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
            ON c1.concept_id = cr.concept_id_1
            WHERE relationship_id = 'Maps to'
            AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
        )
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_cpt' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.procedure_occurrence`
        WHERE procedure_concept_id IN (
            SELECT cr.concept_id_2
            FROM `@oncology_prod.@oncology_omop.concept` c1
            INNER JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
            ON c1.concept_id = cr.concept_id_1
            WHERE relationship_id = 'Maps to'
            AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
        )
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_snomed_proc' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.procedure_occurrence`
        WHERE procedure_concept_id IN (
            SELECT cr.concept_id_2
            FROM `@oncology_prod.@oncology_omop.concept` c1
            INNER JOIN `@oncology_prod.@oncology_omop.concept_relationship` cr
            ON c1.concept_id = cr.concept_id_1
            AND relationship_id = 'Maps to'
            AND c1.vocabulary_id = 'SNOMED'
        )
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_note' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.note`
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_smoking' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id) 
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
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_opioid' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM (
            SELECT person_id
            FROM `@oncology_prod.@oncology_omop.condition_occurrence`
            WHERE condition_concept_id IN (
                SELECT descendant_concept_id
                FROM `@oncology_prod.@oncology_omop.concept_ancestor`
                WHERE ancestor_concept_id = 4032799 -- Opioid-induced organic mental disorder
            ) 
            AND condition_start_date BETWEEN CAST('2022-05-01' AS DATE) AND CAST('2023-04-30' AS DATE)
            UNION DISTINCT 
            SELECT person_id
            FROM `@oncology_prod.@oncology_omop.drug_exposure`
            WHERE drug_concept_id IN (
                SELECT descendant_concept_id
                FROM `@oncology_prod.@oncology_omop.concept_ancestor`
                WHERE ancestor_concept_id IN (1103640, 1133201) -- methadone and buprenorphine
            )
        ) AS opioid_patients
    ) AS all_years

UNION DISTINCT 

SELECT 
    'uniq_pt_any_insurance_value' AS variable_name,
    (
        SELECT COUNT(DISTINCT person_id)
        FROM `@oncology_prod.@oncology_omop.payer_plan_period`
    ) AS all_years;