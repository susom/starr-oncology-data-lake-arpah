brain_tumor_coverage <- function(type, yaml_file_path) {
  sql <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std_phi/common/brain_tumor/data_source_coverage.sql"
  fetch_data_from_sql_file(sql, yaml_file_path, release = "nov_2026") %>%
    filter(coverage_type == .env$type)
}

coverage_table <- function(data, source_label, record_label) {
  data %>%
    select(data_source, patient_count, record_count, percentage) %>%
    DT::datatable(
      colnames = c(source_label, "Unique Patients", record_label, "% Patients"),
      options = list(pageLength = 15, dom = 'ftp'),
      rownames = FALSE
    )
}

patient_bar_chart <- function(data, label_col, title, color, top_n = 20, order_levels = NULL, record_label = NULL) {
  data <- data %>%
    mutate(label = as.character(.data[[label_col]])) %>%
    arrange(desc(patient_count)) %>%
    head(top_n)

  data$label <- if (is.null(order_levels)) {
    factor(data$label, levels = rev(data$label))
  } else {
    factor(data$label, levels = rev(order_levels))
  }

  data$customdata <- if (!is.null(record_label)) data$record_count else NA_real_

  hover_template <- "<b>%{y}</b><br>Patients: %{x:,}<br>% Patients: %{text}"
  if (!is.null(record_label)) {
    hover_template <- paste0(hover_template, "<br>", record_label, ": %{customdata:,}")
  }
  hover_template <- paste0(hover_template, "<extra></extra>")

  plot_ly(
    data,
    x = ~patient_count,
    y = ~label,
    type = "bar",
    orientation = "h",
    marker = list(color = color),
    text = ~paste0(percentage, "%"),
    textposition = "outside",
    customdata = ~customdata,
    hovertemplate = hover_template
  ) %>%
    layout(
      title = list(text = title, x = 0.05),
      xaxis = list(title = "Unique Patients"),
      yaxis = list(title = "", tickfont = list(size = 10)),
      margin = list(l = 200, t = 50, r = 50, b = 50)
    )
}
