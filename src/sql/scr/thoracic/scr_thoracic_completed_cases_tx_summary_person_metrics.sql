--------------------------------------------------------------------------
-- Patient summary by first line of treatment category in Neural Frame 
-- 'completed' case status and diagnosed with thoracic cancer 
---------------------------------------------------------------------------
with 
person as (select * from `@oncology_prod.@oncology_omop.person`),
scr_dx as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_diagnoses`),
scr_tx as (select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_treatments`),
scr_thoracic_dx as
(
select
distinct scr_dx.*
from
scr_dx
where
trim(medicalRecordNumber) <> ''and length(dateOfBirth) = 8
and nfcasestatus = 'Completed'
and (
lower(primarysiteDescription) like '%lung%'
or lower(primarysiteDescription) like '%bronchus%'
or lower(primarysiteDescription) like '%thymus%'
)
),
scr_thoracic_tx as
(
select
distinct scr_tx.*
from
scr_tx
join scr_thoracic_dx on scr_thoracic_dx.cleaned_nf_mrn = scr_tx.cleaned_nf_mrn
      and scr_thoracic_dx.cleaned_nf_dob = scr_tx.cleaned_nf_dob
      and scr_thoracic_dx.nfCaseEntityId = scr_tx.nfCaseEntityId
),
scr_omop_thoracic_tx as
(select
 distinct
 p.person_id,
 p.person_source_value,
 scr_thoracic_tx.*
from
scr_thoracic_tx
inner join person p on p.person_source_value = concat(scr_thoracic_tx.cleaned_nf_mrn, ' | ', scr_thoracic_tx.cleaned_nf_dob)
),
scr_omop_thoracic_tx_summary as
(select
distinct person_source_value,
case when rxDateChemo is not null then 'Yes' else 'No' end chemo_flag,
case when rxDateRadiation is not null then 'Yes' else 'No' end radiation_flag,
case when rxDateSurgery is not null then 'Yes' else 'No' end surgery_flag
from scr_omop_thoracic_tx
)
select
count(distinct person_source_value) patient_count,
chemo_flag,
radiation_flag,
surgery_flag
from scr_omop_thoracic_tx_summary
group by chemo_flag,radiation_flag,surgery_flag
