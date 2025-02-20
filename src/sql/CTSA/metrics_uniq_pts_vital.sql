--------------------------------------------------
---- Number of unique pts with vital concepts ----
--------------------------------------------------

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
),
		all_enc as (SELECT *
		FROM
		(
			SELECT visit_occurrence_id , person_id
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.measurement
			WHERE measurement_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Measurement'
			))
			UNION DISTINCT 
			SELECT visit_occurrence_id , person_id
			FROM som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.observation 
			WHERE observation_concept_id IN 
			(
				SELECT concept_id
				FROM vital_concepts
				WHERE domain_id = 'Observation'
			))

select count(distinct person_id) as uniq_pts_vital from all_enc