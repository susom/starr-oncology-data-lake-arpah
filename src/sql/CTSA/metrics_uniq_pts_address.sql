-------------------------------------------------------
-- number of unique pts with at least one addresses --
--------------------------------------------------------
with address as (
select ps.person_id, loc.* from  som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.person ps
left join som-rit-phi-oncology-prod.oncology_omop_arpah_alpha.location loc
on ps.location_id=loc.location_id
where address_1 is not null or address_2 is not null
) select count(distinct person_id) as uniq_pts_address from address