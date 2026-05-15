  -------------------------------------------------
  ---  Year counts for test types ordered
  --------------------------------------------------
  
   with all_philips as (
    select phi.*
    FROM `@oncology_prod.@oncology_omop.person` p
    INNER JOIN `@oncology_prod.@oncology_philips.onc_philips_mtb_pat_diag_orders` phi
    ON p.person_id = phi.person_id
   )
select
    test_type,
    extract(year from date_of_test) as order_year,
    count(*) as n_orders
from all_philips
group by 1,2
order by 3 desc