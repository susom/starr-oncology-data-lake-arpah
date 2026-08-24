--------------------------------------------------------------------------
-- Radiation Therapy Details
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventphaseradiationtreatmentmodalitydescription as radiation_modality,
  count(distinct nfpatienteventid) as radiation_events,
  count(distinct nfcaseentityid) as cases_with_radiation,
  count(distinct person_id) as patients_with_radiation,
  round(avg(safe_cast(eventphasetotaldose as float64)), 2) as avg_total_dose_gy,
  round(avg(safe_cast(eventphasedoseperfraction as float64)), 2) as avg_dose_per_fraction_gy,
  round(avg(safe_cast(eventphasenumberoffractions as float64)), 1) as avg_number_of_fractions
from event_data
where eventphaseradiationtreatmentmodality is not null
group by radiation_modality
order by cases_with_radiation desc
