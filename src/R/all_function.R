############################
### connection function ###
############################
library(DBI)
library(bigrquery)
library(readr)
library(stringr)
library(gt)

# Function to execute a BigQuery query and return the result as a DataFrame
run_bigquery_query <- function(project_id, sql_file_path) {
  credentials_path <- "/home/rstudio/.config/gcloud/application_default_credentials.json"
  # Set Google Cloud credentials
  Sys.setenv(GOOGLE_APPLICATION_CREDENTIALS = credentials_path)
  
  # Authenticate with BigQuery
  bq_auth(path = Sys.getenv("GOOGLE_APPLICATION_CREDENTIALS"))
  
  # Create BigQuery connection
  bq_conn <- dbConnect(
    bigrquery::bigquery(),
    project = project_id,
    use_legacy_sql = FALSE
  )
  
  # Load SQL from the specified file
  sql_query <- read_file(sql_file_path)
  sql_query <- str_c(sql_query, collapse = " ") ## for any line break
  # Execute the query and return results
  result_df <- tryCatch({
    query_result <- dbGetQuery(bq_conn, sql_query)
    print("Query executed successfully!")
    return(query_result)
  }, error = function(e) {
    print(paste("Query failed:", e$message))
    return(NULL)
  })
  
  # Disconnect from BigQuery
  dbDisconnect(bq_conn)
  end_time <- Sys.time()
  print(paste("Query execution time:", end_time - start_time))
  return(result_df)
}

#######################
### plot function ###
#######################
create_bar_plot <- function(data, x_var, y_var, plot_title, x_axis_title, y_axis_title) {
  plot_ly(
    data = data, 
    x = data[[x_var]], 
    y = data[[y_var]], 
    type = 'bar', 
    marker = list(color = 'rgb(136, 108, 108)', line = list(color = 'rgb(174, 19, 19)', width = 1.5))
  ) %>%
    layout(
       title = list(
        text = plot_title,
        x = 0.01,  # Align to the left (0 = far left, 1 = far right)
        xanchor = "left"
      ),
      xaxis = list(
        title = x_axis_title,
        tickangle = -45,
        showgrid = FALSE
      ),
      yaxis = list(
        title = y_axis_title,
        rangemode = "tozero"
      ),
      margin = list(b = 100),
      showlegend = FALSE
    )
}

##########################
#### fetch sql names 
##########################
library(DBI)
library(bigrquery)
library(dplyr)
library(purrr)

# Define the function
fetch_data_from_sql <- function(credentials_path, project, folder_path) {
  # Set the credentials
  Sys.setenv(GOOGLE_APPLICATION_CREDENTIALS = credentials_path)
  
  # Connect to BigQuery
  conn <- dbConnect(
    bigrquery::bigquery(),
    project = project,
    use_legacy_sql = FALSE
  )
  
  # List SQL files
  sql_files <- list.files(path = folder_path, pattern = "\\.sql$", full.names = TRUE)
  
  # Read and execute the SQL files
  combined_df <- sql_files %>%
    map_dfr(~{
      sql_query <- readLines(.x)
      df <- dbGetQuery(conn, paste(sql_query, collapse = "\n")) 
      df <- df %>%
        mutate(sql_file_name = basename(.x))
      return(df)
    })
  
  # Close the database connection
  dbDisconnect(conn)
  
  # Return the combined data frame
  return(combined_df)
}

