#
#
#
#
#
#
# Your existing initialization
rm(list=ls())
source("/workspaces/starr-oncology-data-lake-arpah/src/R/all_function.R", encoding = "UTF-8")
yaml_file_path <- "/workspaces/starr-oncology-data-lake-arpah/src/deid_aug_2026/sql_params.yml"
#
#
#
library(forcats)
library(dplyr)
library(tidyr)
library(DT)
library(plotly)
library(ggplot2)


# Define unified color palette
color_palette <- c('#8dd3c7', '#ffffb3', '#bebada', '#fb8072', '#b3de69', '#fcd7cd')

# Basic variant counts
sql_file_path_pts <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_patient_counts.sql"
n_pts<- fetch_data_from_sql_file(sql_file_path_pts, yaml_file_path, release = "nov_2026")

# Cohort overlap
sql_overlap <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_cohort_overlap.sql"
cohort_overlap <- fetch_data_from_sql_file(sql_overlap, yaml_file_path, release = "nov_2026")

# Additional queries for visualizations
sql_by_gene <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_gene.sql"
variant_genes <- fetch_data_from_sql_file(sql_by_gene, yaml_file_path, release = "nov_2026")

sql_by_type <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_type.sql"
variant_types <- fetch_data_from_sql_file(sql_by_type, yaml_file_path, release = "nov_2026")

sql_by_consequence <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_consequence.sql"
variant_consequence <- fetch_data_from_sql_file(sql_by_consequence, yaml_file_path, release = "nov_2026")

sql_clinical_sig <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_clinical_significance.sql"
variant_clinical <- fetch_data_from_sql_file(sql_clinical_sig, yaml_file_path, release = "nov_2026")

sql_specimen_type <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_specimen_type.sql"
variant_specimen_type <- fetch_data_from_sql_file(sql_specimen_type, yaml_file_path, release = "nov_2026")

sql_specimen_source <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_specimen_source.sql"
variant_specimen_source <- fetch_data_from_sql_file(sql_specimen_source, yaml_file_path, release = "nov_2026")

sql_ordered_tests <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_ordered_tests_counts.sql"
ordered_tests_counts <- fetch_data_from_sql_file(sql_ordered_tests, yaml_file_path, release = "nov_2026")

sql_ordered_trend <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_ordered_tests_trend.sql"
ordered_tests_trend <- fetch_data_from_sql_file(sql_ordered_trend, yaml_file_path, release = "nov_2026")


sql_frequency <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_freqency.sql"
variant_frequency <- fetch_data_from_sql_file(sql_frequency, yaml_file_path, release = "nov_2026")

sql_phenotype_class <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_phenotype_class.sql"
variant_phenotype_class <- fetch_data_from_sql_file(sql_phenotype_class, yaml_file_path, release = "nov_2026")

sql_comutation <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_comutation.sql"
comutation_data <- fetch_data_from_sql_file(sql_comutation, yaml_file_path, release = "nov_2026")

sql_test_family <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_by_test_family.sql"
test_family_data <- fetch_data_from_sql_file(sql_test_family, yaml_file_path, release = "nov_2026")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
test_family_summary <- test_family_data %>%
  group_by(test_family) %>%
  summarise(
    n_tests = sum(n_tests),
    n_patients = sum(n_patients),
    n_variants = sum(n_variants),
    .groups = "drop"
  ) %>%
  arrange(desc(n_tests))

test_family_totals <- test_family_summary %>%
  summarise(
    test_family = "Overall",
    n_tests = sum(n_tests),
    n_patients = sum(n_patients),
    n_variants = sum(n_variants)
  )

DT::datatable(
  bind_rows(test_family_summary, test_family_totals) %>%
    rename(
      "Test Family" = test_family,
      "Ordered Tests" = n_tests,
      "Patients" = n_patients,
      "Variants" = n_variants
    ),
  options = list(
    dom = 't',
    ordering = FALSE,
    pageLength = 20
  ),
  rownames = FALSE
) %>%
  formatRound(columns = c("Ordered Tests", "Patients", "Variants"), digits = 0, mark = ",")
#
#
#
#
#
#
#
#
DT::datatable(
  test_family_data %>%
    arrange(test_family, desc(n_tests)) %>%
    rename(
      "Test Family" = test_family,
      "Test Name" = test_name,
      "Ordered Tests" = n_tests,
      "Patients" = n_patients,
      "Variants" = n_variants
    ),
  options = list(
    dom = 'tp',
    ordering = TRUE,
    pageLength = 15
  ),
  rownames = FALSE
) %>%
  formatRound(columns = c("Ordered Tests", "Patients", "Variants"), digits = 0, mark = ",")
#
#
#
#
#
#
#
#
#
#
# Create summary table
summary_table <- cohort_overlap %>%
  mutate(
    category = case_when(
      category == "Total variant patients" ~ "Total Patients with Variants",
      category == "Variants with tumor board" ~ "Patients with Tumor Board Encounters",
      category == "Variants with thoracic cancer" ~ "Patients with Thoracic Cancer",
      category == "Variants with both tumor board and thoracic" ~ "Patients with Both TB & Thoracic",
      TRUE ~ category
    )
  ) %>%
  rename(
    "Patient Cohort" = category,
    "Number of Patients" = n_patients
  )

DT::datatable(
  summary_table,
  options = list(
    dom = 't',
    ordering = FALSE,
    pageLength = 10
  ),
  rownames = FALSE
) %>%
  formatRound(columns = "Number of Patients", digits = 0, mark = ",")
#
#
#
#
#
#
#
#
#
#
#
#
library(lubridate)
df_trend <- ordered_tests_trend %>%
  mutate(order_date = as.Date(order_date),
         year_month = floor_date(order_date, "month")) %>%
  group_by(year_month) %>%
  summarise(
    n_tests = sum(n_tests),
    n_patients = sum(n_patients),
    n_variants = sum(n_variants),
    .groups = "drop"
  )

# Collapse all months before Jan 2025 into one bar
cutoff <- as.Date("2025-01-01")
pre_jan25 <- df_trend %>% filter(year_month < cutoff)
post_jan25 <- df_trend %>% filter(year_month >= cutoff)

pre_row <- if (nrow(pre_jan25) > 0) {
  pre_jan25 %>% summarise(
    year_month_label = "< Jan 2025",
    n_tests = sum(n_tests),
    n_patients = sum(n_patients),
    n_variants = sum(n_variants)
  )
} else {
  tibble(year_month_label = character(), n_tests = integer(), n_patients = integer(), n_variants = integer())
}

df_plot <- bind_rows(
  pre_row,
  post_jan25 %>% mutate(year_month_label = format(year_month, "%b %Y")) %>%
    select(year_month_label, n_tests, n_patients, n_variants)
) %>%
  mutate(
    year_month_label = factor(year_month_label, levels = year_month_label),
    cumulative_tests = cumsum(n_tests),
    cumulative_variants = cumsum(n_variants)
  )

# Create plot with monthly and cumulative trends
plot_ly(df_plot) %>%
  # Add monthly tests as bars
  add_bars(
    x = ~year_month_label,
    y = ~n_tests,
    name = "Monthly Tests",
    marker = list(color = color_palette[1], opacity = 0.7),
    hovertemplate = paste(
      "<b>%{x}</b><br>",
      "Monthly Tests: %{y:,.0f}<br>",
      "<extra></extra>"
    )
  ) %>%
  # Add cumulative tests as line on secondary axis
  add_lines(
    x = ~year_month_label,
    y = ~cumulative_tests,
    yaxis = "y2",
    name = "Cumulative Tests",
    line = list(color = color_palette[4], width = 3),
    marker = list(size = 8, color = color_palette[4]),
    hovertemplate = paste(
      "<b>%{x}</b><br>",
      "Total Tests: %{y:,.0f}<br>",
      "<extra></extra>"
    )
  ) %>%
  layout(
    xaxis = list(title = ""),
    yaxis = list(
      title = "Monthly Test Volume",
      titlefont = list(color = color_palette[1]),
      tickfont = list(color = color_palette[1])
    ),
    yaxis2 = list(
      title = "Cumulative Tests",
      titlefont = list(color = color_palette[4]),
      tickfont = list(color = color_palette[4]),
      overlaying = "y",
      side = "right"
    ),
    title = "",
    hovermode = "x unified",
    legend = list(
      orientation = "h",
      x = 0.5,
      xanchor = "center",
      y = -0.25
    ),
    margin = list(b = 140, r = 80)
  )
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Top 20 genes by variant count
df_genes <- variant_genes %>% 
  filter(!is.na(gene_name)) %>%
  arrange(desc(n_variants)) %>%
  head(20) %>%
  mutate(
    gene_name = fct_reorder(gene_name, n_variants),
    pct_patients = (n_patients / n_pts$n_patients) * 100
  )

plot_ly(df_genes,
        y = ~gene_name,
        x = ~n_variants,
        type = "bar",
        marker = list(color = color_palette[1]),
        text = ~paste0(round(pct_patients, 1), "%"),
        textposition = "outside",
        hovertemplate = paste(
          "<b>%{y}</b><br>",
          "Variants: %{x:,.0f}<br>",
          "Patients: %{customdata:,.0f}<br>",
          "<extra></extra>"
        ),
        customdata = ~n_patients) %>%
  layout(
    xaxis = list(title = "Number of Variants"),
    yaxis = list(title = ""),
    title = "",
    margin = list(l = 100)
  )
#
#
#
#
#
#
#
df_consequence <- variant_consequence %>% 
  filter(!is.na(variant_molecular_consequence)) %>%
  arrange(desc(n_variants)) %>%
  head(15) %>%
  mutate(variant_molecular_consequence = fct_reorder(variant_molecular_consequence, n_variants))

plot_ly(df_consequence,
        y = ~variant_molecular_consequence,
        x = ~n_variants,
        type = "bar",
        marker = list(color = color_palette[3]),
        customdata = ~n_patients,
        hovertemplate = paste(
          "<b>%{y}</b><br>",
          "Variants: %{x:,.0f}<br>",
          "Patients: %{customdata:,.0f}<br>",
          "<extra></extra>"
        )) %>%
  layout(
    xaxis = list(title = "Number of Variants"),
    yaxis = list(title = ""),
    title = "",
    margin = list(l = 150)
  )
#
#
#
#
#
#
#
#
#
#
#
#
#
#
df_phenotype <- variant_phenotype_class %>% 
  filter(!is.na(phenotype_spec_var_class)) %>%
  arrange(desc(n_variants)) %>%
  mutate(phenotype_spec_var_class = fct_reorder(phenotype_spec_var_class, n_variants))

plot_ly(df_phenotype,
        y = ~phenotype_spec_var_class,
        x = ~n_variants,
        type = "bar",
        marker = list(color = color_palette[5]),
        customdata = ~n_patients,
        hovertemplate = paste(
          "<b>%{y}</b><br>",
          "Variants: %{x:,.0f}<br>",
          "Patients: %{customdata:,.0f}<br>",
          "<extra></extra>"
        )) %>%
  layout(
    xaxis = list(title = "Number of Variants"),
    yaxis = list(title = ""),
    title = "",
    margin = list(l = 200)
  )
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
df_specimen_type <- variant_specimen_type %>% 
  filter(!is.na(specimen_type)) %>%
  arrange(desc(n_variants))

plot_ly(df_specimen_type,
        labels = ~specimen_type,
        values = ~n_variants,
        type = "pie",
        textposition = "inside",
        textinfo = "label",
        customdata = ~n_patients,
        hovertemplate = paste(
          "<b>%{label}</b><br>",
          "Variants: %{value:,.0f}<br>",
          "Patients: %{customdata:,.0f}<br>",
          "Percent: %{percent}<br>",
          "<extra></extra>"
        ),
        marker = list(colors = rep(color_palette, length.out = nrow(df_specimen_type)))) %>%
  layout(title = "Variants by Specimen Type",
         showlegend = TRUE)
#
#
#
#
#
#
#
#
#
#
#
#
#
df_specimen_source <- variant_specimen_source %>% 
  filter(!is.na(specimen_source)) %>%
  arrange(desc(n_variants)) %>%
  head(15) %>%
  mutate(specimen_source = fct_reorder(specimen_source, n_variants))

plot_ly(df_specimen_source,
        y = ~specimen_source,
        x = ~n_variants,
        type = "bar",
        marker = list(color = color_palette[6]),
        hovertemplate = paste(
          "<b>%{y}</b><br>",
          "Variants: %{x:,.0f}<br>",
          "Patients: %{customdata:,.0f}<br>",
          "<extra></extra>"
        ),
        customdata = ~n_patients) %>%
  layout(
    xaxis = list(title = "Number of Variants"),
    yaxis = list(title = ""),
    title = "",
    margin = list(l = 150)
  )
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Filter and prepare data
df_freq <- variant_frequency %>%
  filter(!is.na(variant_molecular_consequence),
         !is.na(allelic_frequency),
         allelic_frequency > 0) %>%
  # Get top consequence types for readability
  mutate(consequence_count = n(), .by = variant_molecular_consequence) %>%
  filter(consequence_count >= 10) %>%
  mutate(variant_molecular_consequence = fct_reorder(variant_molecular_consequence, allelic_frequency, .fun = median))

# Create sina plot
ggplot(df_freq, aes(x = variant_molecular_consequence, y = allelic_frequency)) +
  geom_violin(fill = color_palette[4], alpha = 0.3, color = NA) +
  geom_jitter(alpha = 0.3, size = 1, width = 0.2, color = color_palette[4]) +
  stat_summary(fun = median, geom = "point", size = 3, color = "black", shape = 18) +
  labs(
    x = "Variant Molecular Consequence",
    y = "Allelic Frequency",
    title = ""
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold")
  ) +
  scale_y_continuous(labels = scales::percent_format())
#
#
#
#
#
#
#
#
#
# Prepare data - select top 15 genes by variant count
top_genes <- variant_frequency %>%
  filter(!is.na(gene_name)) %>%
  count(gene_name, sort = TRUE) %>%
  head(15) %>%
  pull(gene_name)

df_gene_freq <- variant_frequency %>%
  filter(gene_name %in% top_genes,
         !is.na(allelic_frequency),
         allelic_frequency > 0) %>%
  mutate(gene_name = fct_reorder(gene_name, allelic_frequency, .fun = median))

# Create mutation landscape with box plot and jittered points
ggplot(df_gene_freq, aes(x = gene_name, y = allelic_frequency)) +
  geom_boxplot(fill = color_palette[2], alpha = 0.3, outlier.shape = NA, width = 0.6) +
  geom_jitter(alpha = 0.4, size = 2, width = 0.25, color = color_palette[4]) +
  stat_summary(fun = median, geom = "point", size = 5, color = "red", shape = 18) +
  labs(
    x = "Gene",
    y = "Allelic Frequency",
    title = ""
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12, face = "bold"),
    axis.text.y = element_text(size = 11),
    axis.title = element_text(size = 12, face = "bold"),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray90")
  ) +
  scale_y_continuous(labels = scales::percent_format(), breaks = seq(0, 1, 0.1))
#
#
#
#
#
#
#
#
#
#
#
# Gene mutations in thoracic TB patients
sql_thoracic_genes <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_thoracic_tb_genes.sql"
thoracic_tb_genes <- fetch_data_from_sql_file(sql_thoracic_genes, yaml_file_path, release = "nov_2026")

# Clinical significance for thoracic TB patients
sql_thoracic_clinical <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_thoracic_tb_clinical.sql"
thoracic_tb_clinical <- fetch_data_from_sql_file(sql_thoracic_clinical, yaml_file_path, release = "nov_2026")

# Specimen types for thoracic TB patients
sql_thoracic_specimen <- "/workspaces/starr-oncology-data-lake-arpah/src/sql_std/omop/variant_occ/variant_thoracic_tb_specimen.sql"
thoracic_tb_specimen <- fetch_data_from_sql_file(sql_thoracic_specimen, yaml_file_path, release = "nov_2026")
#
#
#
#
#
#
#
#
#
df_thoracic_genes <- thoracic_tb_genes %>%
  filter(!is.na(gene_name)) %>%
  arrange(desc(n_variants)) %>%
  head(15) %>%
  mutate(
    gene_name = fct_reorder(gene_name, n_variants),
    pct_patients = (n_patients / 45) * 100
  )

# Create heatmap matrix
heatmap_data <- df_thoracic_genes %>%
  mutate(
    variants_cat = n_variants,
    patients_cat = n_patients
  ) %>%
  select(gene_name, n_variants, n_patients, pct_patients)

plot_ly(
  data = heatmap_data,
  x = ~c("Variant Count", "Patient Count"),
  y = ~gene_name,
  z = ~cbind(n_variants, n_patients),
  type = "heatmap",
  colorscale = list(
    c(0, "#f3f0f7"),
    c(0.5, "#bebada"),
    c(1, "#6a4c93")
  ),
  hovertemplate = paste(
    "<b>%{y}</b><br>",
    "%{x}: %{z}<br>",
    "<extra></extra>"
  ),
  showscale = TRUE,
  colorbar = list(title = "Count")
) %>%
  layout(
    xaxis = list(title = "", side = "bottom"),
    yaxis = list(title = ""),
    margin = list(l = 100, r = 100, b = 80)
  )
#
#
#
#
#
#
#
#
#
df_thoracic_clinical <- thoracic_tb_clinical %>%
  filter(!is.na(phenotype_spec_var_class)) %>%
  arrange(desc(n_variants)) %>%
  mutate(phenotype_spec_var_class = fct_reorder(phenotype_spec_var_class, n_variants))

plot_ly(df_thoracic_clinical,
        labels = ~phenotype_spec_var_class,
        values = ~n_variants,
        type = "pie",
        textposition = "inside",
        textinfo = "label+percent",
        marker = list(colors = color_palette),
        hovertemplate = paste(
          "<b>%{label}</b><br>",
          "Variants: %{value:,.0f}<br>",
          "Percent: %{percent}<br>",
          "<extra></extra>"
        )) %>%
  layout(
    title = "",
    showlegend = TRUE,
    legend = list(orientation = "v", x = 1.02, y = 0.5)
  )
#
#
#
#
#
#
#
specimen_summary <- thoracic_tb_specimen %>%
  mutate(
    pct_variants = round((n_variants / sum(n_variants)) * 100, 1)
  ) %>%
  arrange(desc(n_variants)) %>%
  rename(
    "Specimen Type" = specimen_type,
    "Variants" = n_variants,
    "Patients" = n_patients,
    "% of Variants" = pct_variants
  )

DT::datatable(
  specimen_summary,
  options = list(
    dom = 't',
    ordering = FALSE,
    pageLength = 10,
    columnDefs = list(
      list(className = 'dt-left', targets = 0),
      list(className = 'dt-center', targets = c(1, 2, 3))
    )
  ),
  rownames = FALSE
) %>%
  formatRound(columns = c("Variants", "Patients"), digits = 0, mark = ",")
#
#
#
#
#
#
#
#
#
#
