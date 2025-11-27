-------------------------------------------------------
-- number of unique pts with at least one addresses --
--------------------------------------------------------
with address as (
select ps.person_id, loc.* from  `@oncology_prod.@oncology_omop.person` ps
left join `@oncology_prod.@oncology_omop.location` loc
on ps.location_id=loc.location_id
where address_1 is not null or address_2 is not null
) select count(distinct person_id) as uniq_pts_address , 'uniq_pt_address' as variable_name from address