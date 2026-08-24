--------------------------------------------------------------------------
-- ARIA Phase-Level Radiation Logistics (Radiation events only)
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  count(distinct person_id) as patients_with_aria_phase_data,
  count(distinct nfcaseentityid) as cases_with_aria_phase_data,
  count(distinct nfpatienteventid) as events_with_aria_phase_data
from event_data
where (eventphasetotaldose is not null
   or eventphasedoseperfraction is not null
   or eventphasenumberoffractions is not null
   or eventphaseradiationtreatmentvolume is not null
   or eventphaseradiationdraininglymphnodes is not null
   or eventphaseradiationexternalbeamplanningtech is not null)
