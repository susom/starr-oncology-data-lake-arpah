--------------------------------------------------------------------------
-- Diagnostic and Pathology Procedures
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
  where lower(eventtypedescription) like '%radiation%'
)
select 
  eventdiagnosticprocedure,
  eventdiagnosticproceduredescription,
  count(distinct nfpatienteventid) as procedure_events,
  count(distinct nfcaseentityid) as cases_with_procedure,
  count(distinct person_id) as patients_with_procedure
from event_data
where eventdiagnosticprocedure is not null
group by 
  eventdiagnosticprocedure,
  eventdiagnosticproceduredescription
order by cases_with_procedure desc
