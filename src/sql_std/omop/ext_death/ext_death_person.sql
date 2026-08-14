--- unique pts counts ---
select 'external_death_records' as flag, count(distinct person_id) as unique_pt_count
from @oncology_prod.@oncology_omop._external_death_records 
union all
select 'external_death_records_overlap' as flag, count(distinct ex.person_id) as unique_pt_count
from @oncology_prod.@oncology_omop._external_death_records ex
inner join @oncology_prod.@oncology_omop._death using(person_id) 