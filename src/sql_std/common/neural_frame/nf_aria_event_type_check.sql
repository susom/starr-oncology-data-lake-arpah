--------------------------------------------------------------------------
-- ARIA Phase-Level by Radiation Phase (Radiation events only)
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventtype,
  eventtypedescription,
  eventradiationphase,
  count(distinct person_id) as patients,
  count(distinct nfcaseentityid) as cases,
  count(distinct nfpatienteventid) as events
from event_data
where lower(eventtypedescription) like '%radiation%'
  and (eventphasetotaldose is not null
   or eventphasedoseperfraction is not null
   or eventphasenumberoffractions is not null
   or eventphaseradiationtreatmentvolume is not null
   or eventphaseradiationdraininglymphnodes is not null
   or eventphaseradiationexternalbeamplanningtech is not null
   or eventphaseradiationtreatmentmodality is not null
   or eventradiationphase is not null)
group by eventtype, eventtypedescription, eventradiationphase
order by patients desc
