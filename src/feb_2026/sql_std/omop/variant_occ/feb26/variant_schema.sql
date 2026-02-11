  --------------------------------------------------------------------
  --- Get schema/column information for _variant_occurrence table ---
  --------------------------------------------------------------------
  
  SELECT 
    column_name,
    data_type,
    is_nullable,
    ordinal_position
  FROM `@oncology_prod.@oncology_omop`.INFORMATION_SCHEMA.COLUMNS
  WHERE table_name = '_variant_occurrence'
  ORDER BY ordinal_position
