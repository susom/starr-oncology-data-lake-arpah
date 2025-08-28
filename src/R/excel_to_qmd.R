library(readxl)
library(knitr)

# Path to the Excel file
excel_path <- "../R/Philips Data Dictionary.xlsx"

# Get sheet names
sheets <- excel_sheets(excel_path)

# Read first 3 sheets and convert to qmd
for (i in seq_len(min(3, length(sheets)))) {
  sheet_name <- sheets[i]
  
  # Read the sheet
  data <- read_excel(excel_path, sheet = sheet_name)
  
  # Create qmd file name (convert to lowercase and replace spaces with underscores)
  qmd_filename <- paste0("../philips_ispm_data_dict/", tolower(gsub(" ", "_", sheet_name)), ".qmd")
  
  # Open file connection
  sink(qmd_filename)
  
  # Write YAML frontmatter
  cat("---\n")
  cat(sprintf('title: "Philips ISPM %s"\n', sheet_name))
  cat("---\n\n")
  
  # Write description
  cat(sprintf("The table `onc_philips_mtb_%s` contains genomic testing information from the Philips IntelliSpace Precision Medicine (ISPM) genomics database at Stanford.\n\n", tolower(gsub(" ", "_", sheet_name))))
  
  # Write table header
  cat("### Table Columns\n\n")
  
  # Convert column names to lowercase and replace spaces with underscores
  names(data) <- tolower(gsub(" ", "_", names(data)))
  
  # Convert to markdown table and write
  print(kable(data, format = "pipe"))
  
  # Close file connection
  sink()
  
  cat(paste("Created", qmd_filename, "\n"))
}
