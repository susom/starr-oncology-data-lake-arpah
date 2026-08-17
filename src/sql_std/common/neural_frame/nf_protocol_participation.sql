--------------------------------------------------------------------------
-- Protocol Participation Analysis
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventprotocolparticipation,
  eventprotocoltrialtype,
  eventprotocoleligibilitystatus,
  count(distinct eventprotocolnumber) as unique_protocols,
  count(distinct nfpatientsetid) as enrolled_cases,
  count(distinct person_id) as enrolled_patients
from event_data
where eventprotocolnumber is not null
group by 
  eventprotocolparticipation,
  eventprotocoltrialtype,
  eventprotocoleligibilitystatus
order by enrolled_patients desc
