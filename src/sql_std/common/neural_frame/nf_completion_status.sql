--------------------------------------------------------------------------
-- Treatment Completion Status
--------------------------------------------------------------------------

with
event_data as (
  select * from `@oncology_prod.@oncology_neuralframe.onc_neuralframe_case_events`
)
select 
  eventchemotherapycompletionstatus,
  eventradiationcompletionstatus,
  count(distinct nfpatientsetid) as case_count,
  round(100.0 * count(distinct nfpatientsetid) / 
    sum(count(distinct nfpatientsetid)) over (), 1) as percent_of_cases
from event_data
where eventchemotherapycompletionstatus is not null 
   or eventradiationcompletionstatus is not null
group by 
  eventchemotherapycompletionstatus,
  eventradiationcompletionstatus
order by case_count desc
