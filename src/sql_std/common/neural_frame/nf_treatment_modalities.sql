--------------------------------------------------------------------------
-- Treatment Modalities Summary
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  case 
    when eventrxsummchemo is not null then 'Chemotherapy'
    when eventphaseradiationtreatmentmodality is not null then 'Radiation'
    when eventrxsummsurgprimsite is not null then 'Surgery'
    when eventrxsummhormone is not null then 'Hormone Therapy'
    when eventrxsummbrm is not null then 'Biologic Response Modifier'
    else 'Other'
  end as treatment_modality,
  count(distinct nfpatientsetid) as case_count,
  count(distinct person_id) as patient_count
from event_data
where eventdate is not null
group by treatment_modality
order by case_count desc
