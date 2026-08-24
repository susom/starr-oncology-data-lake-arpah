--------------------------------------------------------------------------
-- Neural Frame Event Types Distribution
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventtype,
  eventtypedescription,
  count(distinct nfpatienteventid) as event_count,
  count(distinct nfcaseentityid) as case_count,
  count(distinct person_id) as patient_count
from event_data
where eventtype is not null
group by eventtype, eventtypedescription
order by event_count desc
