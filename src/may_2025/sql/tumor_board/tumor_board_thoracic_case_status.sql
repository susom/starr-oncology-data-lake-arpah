-------------------------------------------------------------------------
-- this query generates tb patients case status
------------------------------------------------------------------------
with
person as (select * from `som-rit-phi-oncology-prod.oncology_omop_phi_irb76049_may2025_ALPHA.person`),
all_flag as (select * from `som-rit-phi-oncology-prod.oncology_omop_phi_flags_irb76049_may2025_ALPHA.onc_arpah__cancer_cohort`),
scr_thoracic_patients as (select * from `som-rit-phi-oncology-prod.oncology_neuralframe_phi_irb76049_may2025_ALPHA.onc_neuralframe_case_diagnoses`
WHERE
(lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
),
tumor_board_patients AS (
select person_source_value from all_flag
where tumor_board_encounter_flag = 1
),
case_status_category as
(select
person.person_source_value,
case
when scr_thoracic_patients.nfcasestatus in ('Incomplete','Incomplete - Edit','Suspense') then 'Incomplete'
else nfcasestatus
end nfcasestatus_category
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join scr_thoracic_patients on person.person_source_value = scr_thoracic_patients.stanford_patient_uid
),
unique_pat as
(select distinct person_source_value from case_status_category),
complete_pat as
(select * from case_status_category
where nfcasestatus_category = 'Completed'
),
incomplete_pat as
(select * from case_status_category
where nfcasestatus_category = 'Incomplete'
),
notreportable_pat as
(select * from case_status_category
where nfcasestatus_category = 'Not Reportable'
),
derived as
(select
distinct
unique_pat.*
,case
when complete_pat.person_source_value is not null then 'Complete'
when complete_pat.person_source_value is null and incomplete_pat.person_source_value is null and notreportable_pat.person_source_value is not null then 'Not Reportable'
else 'Incomplete'
end patient_status
from
unique_pat
left join complete_pat on unique_pat.person_source_value = complete_pat.person_source_value
left join incomplete_pat on unique_pat.person_source_value = incomplete_pat.person_source_value
left join notreportable_pat on unique_pat.person_source_value = notreportable_pat.person_source_value
)
select patient_status,count(1) from derived
group by patient_status
