--------------------------------------------------------------------
-- Variant, patient, and test counts by test name, grouped into
-- higher-level test families (Solid tumor STAMP, Heme-STAMP NGS,
-- Heme-STAMP MRD, POLE, Guardant360, Pharmacogenomics Panel).
--------------------------------------------------------------------

SELECT
  CASE
    WHEN UPPER(test_name) = 'STANFORD ACTIONABLE MUTATION PANEL FOR SOLID TUMORS'
      THEN 'Solid tumor STAMP (SHC)'
    WHEN UPPER(test_name) IN (
        'HEME-STAMP NGS PANEL, BM/TISSUE/FLUID',
        'HEME-STAMP NGS, BLOOD'
    ) THEN 'Heme-STAMP NGS (SHC)'
    WHEN UPPER(test_name) IN (
        'HEME-STAMP MRD, BONE MARROW',
        'HEME-STAMP MRD, BLOOD'
    ) THEN 'Heme-STAMP MRD (SHC)'
    WHEN UPPER(test_name) = 'POLE, FFPE'
      THEN 'POLE'
    WHEN UPPER(test_name) IN (
        'GUARDANT360',
        'GUARDANT360 CDX',
        'GUARDANT360 TISSUENEXT',
        'GUARDANT360 RESPONSE'
    ) THEN 'Guardant360'
    WHEN UPPER(test_name) = 'PHARMACOGENOMICS PANEL (STANFORD)'
      THEN 'Pharmacogenomics Panel (Stanford)'
    ELSE 'Other / Unmapped'
  END AS test_family,
  test_name,
  COUNT(DISTINCT procedure_occurrence_id) AS n_tests,
  COUNT(DISTINCT person_id)               AS n_patients,
  COUNT(*)                                AS n_variants
FROM `@oncology_prod.@oncology_omop._variant_occurrence`
WHERE test_name IS NOT NULL
GROUP BY test_family, test_name
ORDER BY test_family, n_variants DESC
