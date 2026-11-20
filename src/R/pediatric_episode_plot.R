peds_treatment_plot <- function(peds, level) {
  rows <- peds %>%
    filter(summary_level == .env$level, patients > 10) %>%
    arrange(desc(patients), desc(episodes), plan_type, treatment_protocol) %>%
    mutate(label = if (level == "plan") plan_type else paste(plan_type, treatment_protocol, sep = ": "),
           pct = 100 * patients / cohort_size)
  if (!nrow(rows)) return(htmltools::tags$p("No categories with more than 10 patients."))

  plot_ly(rows, x = ~patients, y = ~label, type = "bar", orientation = "h",
          height = max(300, 30 * nrow(rows) + 80),
          marker = list(color = if (level == "plan") "#80CBC4" else "#FFCC80"),
          text = ~sprintf("%s<br>Patients: %s (%.1f%% of cohort)<br>Episodes: %s",
                          label, patients, pct, episodes),
          hovertemplate = "%{text}<extra></extra>", textposition = "none") %>%
    layout(xaxis = list(title = "Unique patients", rangemode = "tozero"),
           yaxis = list(title = "", type = "category", categoryorder = "array",
                        categoryarray = rev(rows$label), automargin = TRUE,
                        tickmode = "array", tickvals = rows$label,
                        ticktext = stringr::str_trunc(rows$label, 45)))
}
