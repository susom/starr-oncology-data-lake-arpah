--------------------------------------------------------------------------
-- Radiation Therapy Details
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventphaseradiationtreatmentmodality,
  eventphaseradiationtreatmentmodalitydescription,
  eventphaseradiationexternalbeamplanningtech,
  eventphaseradiationexternalbeamplanningtechdescription,
  count(distinct nfpatienteventid) as radiation_events,
  count(distinct nfpatientsetid) as cases_with_radiation,
  round(avg(cast(eventphasetotaldose as float64)), 2) as avg_total_dose_gy,
  round(avg(cast(eventphasedoseperfraction as float64)), 2) as avg_dose_per_fraction_gy,
  round(avg(cast(eventphasenumberoffractions as float64)), 1) as avg_number_of_fractions
from event_data
where eventphaseradiationtreatmentmodality is not null
group by 
  eventphaseradiationtreatmentmodality,
  eventphaseradiationtreatmentmodalitydescription,
  eventphaseradiationexternalbeamplanningtech,
  eventphaseradiationexternalbeamplanningtechdescription
order by cases_with_radiation desc
