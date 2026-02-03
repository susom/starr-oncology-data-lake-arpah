---------------------------------------------------
--- number of pts with thoracic cancer and tb ----
---------------------------------------------------

with
person as (select * from `@oncology_prod.@oncology_omop.person`),
all_flag as (select * from `@oncology_prod.@oncology_temp.onc_arpah__cancer_cohort`),
scr as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
tumor_board_patients AS (
select person_source_value from all_flag
where tumor_board_encounter_flag = 1
),
scr_thoracic_patients as (
    select distinct
cleaned_nf_mrn,cleaned_nf_dob
    FROM scr
    WHERE trim(medicalRecordNumber) <> '' and length(dateOfBirth) = 8
    and lower(primarysiteDescription) like '%lung%'
    or lower(primarysiteDescription) like '%bronchus%'
    or lower(primarysiteDescription) like '%thymus%'
    GROUP BY cleaned_nf_mrn, cleaned_nf_dob --return results at patient level
)
select count(distinct person.person_source_value) n_pts
from
tumor_board_patients tb
inner join person on person.person_source_value = tb.person_source_value
inner join scr_thoracic_patients on person.person_source_value = concat(scr_thoracic_patients.cleaned_nf_mrn, ' | ', scr_thoracic_patients.cleaned_nf_dob)
