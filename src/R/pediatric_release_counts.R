pediatric_release_counts <- function(sql_dir, yaml_file_path, release) {
  counts <- fetch_data_from_sql_file(
    file.path(sql_dir, "tumor_board_encounters.sql"), yaml_file_path,
    release = release, cohort_sql_file = file.path(sql_dir, "cohort_definition.sql")
  )
  if (is.null(counts) || nrow(counts) != 1L) {
    stop("Unable to load pediatric brain tumor counts for ", release)
  }
  counts
}
