-- Calendar trend of ordered tests by month
-- Groups by year-month from order_datetime

SELECT 
  DATE(TIMESTAMP(order_datetime)) AS order_date, 
  COUNT(DISTINCT procedure_occurrence_id) as n_tests,
  COUNT(DISTINCT person_id) as n_patients,
  COUNT(*) as n_variants
FROM 
  `@oncology_prod.@oncology_omop._variant_occurrence`
WHERE 
  order_datetime IS NOT NULL
GROUP BY 
  order_date
ORDER BY 
  order_date;
