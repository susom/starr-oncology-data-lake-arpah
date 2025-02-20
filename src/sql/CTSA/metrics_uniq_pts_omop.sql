
with vital_concepts as (
	/*
	Spec: At least one vital: height, weight, blood pressure, BMI, or temperature

	 height
		3036277
	 , weight
		3025315
	 , blood pressure
		45876174
	 , BMI
		1002813
		4245997
	 , temperature
		1004059
		4178505

	# concepts exist in both meas and obs

*/

	SELECT conc.*
	FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_ancestor ca
	INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept conc
  ON ca.descendant_concept_id = conc.concept_id
  WHERE ancestor_concept_id IN
	(
		3036277
		,3025315
		,45876174
		,1002813
		,4245997
		,1004059
		,4178505
	)
	AND conc.standard_concept = 'S'
)

,smoking_concepts as (

	SELECT conc.*
	FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_relationship cr 
	INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept conc
	ON cr.concept_id_2 = conc.concept_id
  WHERE cr.concept_id_1 IN
	(
		SELECT concept_id
		FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept
		WHERE concept_code in 
		(
			'Z87.891'
			,'F17.20'
			,'F17.200'
			, 'F17.201'
			, 'F17.203'
			, 'F17.208'
			, 'F17.209'
			, 'F17.21'
			, 'F17.210'
			, 'F17.211'
			, 'F17.213'
			, 'F17.218'
			, 'F17.219'
		)
	)
	AND conc.standard_concept = 'S'
	AND cr.relationship_id = 'Maps to'

)

/*
  Variable: data_model
  Acceptable values:  1=PCORNet, 2=OMOP, 3=TriNetX, 4=i2b2/ACT
*/
SELECT 
	'data_model' as variable_name
	,(SELECT 2 as one_year) as all_years -- 2 = OMOP


UNION DISTINCT 
SELECT 
	'total_patients' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id) 
		FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.visit_occurrence) as all_years
UNION DISTINCT 
SELECT 
	'total_pt_gt_12' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person per
		INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
		AND DATE_DIFF(vis.visit_start_date, per.birth_datetime,year) > 12) as all_years 

UNION DISTINCT 
SELECT 
	'uniq_pt_with_age' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person per
		INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.visit_occurrence vis
		ON per.birth_datetime IS NOT NULL 
		AND per.person_id = vis.person_id
	)  as all_years
    

UNION DISTINCT 
SELECT 
	'uniq_pt_loinc' as variable_name
	,(
		SELECT COUNT(DISTINCT per.person_id) 
		FROM (
			SELECT person_id
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.measurement meas
			INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND meas.measurement_concept_id = conc.concept_id
			UNION DISTINCT 
			SELECT person_id
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.observation  obs
			INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept conc
			ON conc.vocabulary_id = 'LOINC'
			AND obs.observation_concept_id = conc.concept_id
		) per
	)  as all_years
	
  

UNION DISTINCT 
SELECT 
	'uniq_pt_med_rxnorm' as variable_name
	,(
		SELECT COUNT(DISTINCT drug.person_id) 
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.drug_exposure drug
		INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept conc
    ON drug.drug_concept_id = conc.concept_id
    WHERE conc.vocabulary_id in ('RxNorm', 'NDC')
	) as all_years


UNION DISTINCT 
SELECT 
	'uniq_pt_icd_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept c1
				INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD9CM', 'ICD10CM')
		)
		AND condition_start_date BETWEEN cast('2022-05-01' as DATE) AND cast('2023-04-30' as DATE)
	) as all_years

UNION DISTINCT 
SELECT 
	'uniq_pt_snomed_dx' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.condition_occurrence
		WHERE condition_concept_id IN 
		(
				SELECT cr.concept_id_2
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept c1
				INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
	) as all_years

    
UNION DISTINCT 
SELECT 
	'uniq_pt_icd_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept c1
				INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('ICD10PCS', 'ICD9Proc')
		)

	) as all_years


UNION DISTINCT 
SELECT 
	'uniq_pt_cpt' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept c1
				INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				WHERE relationship_id = 'Maps to'
				AND c1.vocabulary_id IN ('CPT4', 'HCPCS')
		)

	) as all_years


UNION DISTINCT 
SELECT 
	'uniq_pt_snomed_proc' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.procedure_occurrence
		WHERE procedure_concept_id IN 
		(
				SELECT cr.concept_id_2
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept c1
				INNER JOIN som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_relationship cr
				ON c1.concept_id = cr.concept_id_1
				AND relationship_id = 'Maps to'
				AND c1.vocabulary_id = 'SNOMED'
		)
	) as all_years


UNION DISTINCT 
SELECT 
	'uniq_pt_note' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.note
	) as all_years

/*
Spec: At least one vital: height, weight, blood pressure, BMI, or temperature

 height
	3036277
 , weight
	3025315
 , blood pressure
	45876174
 , BMI
	1002813
	4245997
 , temperature
	1004059
	4178505
*/


/*
Smoking Status Codes: Z87.891, F17.20, F17.200, F17.201, F17.203, F17.208, F17.209, F17.21, F17.210, F17.211, F17.213, F17.218, F17.219
*/
UNION DISTINCT 
SELECT 
	'uniq_pt_smoking' as variable_name
	,(
		SELECT COUNT(distinct person_id) 
		FROM
		(
			SELECT person_id 
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Condition'
			)
			
			UNION DISTINCT 
			SELECT person_id 
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM smoking_concepts
				WHERE domain_id = 'Observation'
			)
		
		)
	) as all_years



UNION DISTINCT 
SELECT 
	'uniq_pt_opioid' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM
		(
			-- " SNOMED -14784000 and its descendants "
			SELECT person_id
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.condition_occurrence
			WHERE condition_concept_id IN 
			(
				SELECT descendant_concept_id
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_ancestor
				WHERE ancestor_concept_id = 4032799 --Opioid-induced organic mental disorder
			) 
			AND condition_start_date BETWEEN cast('2022-05-01' as DATE) AND cast('2023-04-30' as DATE)
			UNION DISTINCT 
			--"RxNorm (methadone {6813} and descendants, buprenorphine {1819} and descendant TTYs) "
			SELECT person_id
			FROM  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.drug_exposure
			WHERE drug_concept_id IN 
			(
				SELECT descendant_concept_id
				from som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.concept_ancestor
				WHERE ancestor_concept_id IN (
					1103640		-- methadone (6813 is the concept code)
					,1133201	-- buprenorphine (1819 is the concept code)
				)
			) 
		) 
	) as all_years

-- TODO: Better way to calculate the date range overlap?

UNION DISTINCT 
SELECT 
	'uniq_pt_any_insurance_value' as variable_name
	,(
		SELECT COUNT(DISTINCT person_id)
		FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.payer_plan_period
	) as all_years

UNION DISTINCT 
SELECT 
	'uniq_enc_vital_sign' as variable_name
	,(
		SELECT COUNT(distinct visit_occurrence_id) 
		FROM
		(
			SELECT visit_occurrence_id 
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.measurement
			WHERE measurement_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Measurement'
			))
			UNION DISTINCT 
			SELECT visit_occurrence_id 
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Observation'
			)
		) as all_years
