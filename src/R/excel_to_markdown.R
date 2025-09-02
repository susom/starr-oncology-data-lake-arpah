library(readxl)
library(knitr)

# Path to the Excel file
excel_path <- "../R/Philips Data Dictionary.xlsx"

# Get sheet names
sheets <- excel_sheets(excel_path)

# Read first 3 sheets and convert to markdown
for (i in seq_len(min(3, length(sheets)))) {
  sheet_name <- sheets[i]
  
  # Read the sheet
  data <- read_excel(excel_path, sheet = sheet_name)
  
  # Create markdown file name
  md_filename <- paste0("philips_dict_", tolower(gsub(" ", "_", sheet_name)), ".md")
  
  # Open file connection
  sink(md_filename)
  
  # Write header
  cat(paste("# ", sheet_name, "\n\n"))
  
  # Convert to markdown table and write
  print(kable(data, format = "pipe"))
  
  # Close file connection
  sink()
  
  cat(paste("Created", md_filename, "\n"))
}
