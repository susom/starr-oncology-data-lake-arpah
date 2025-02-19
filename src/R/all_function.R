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
  print(paste("Query execution time:", end_time))
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
  sql_params <- yaml::read_yaml("sql_params.yml")

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
##########################
### function for N(%) ###
#########################
# Define the function
calculate_N_percent <- function(count_column, den) {
  total_count <- sum(count_column)
  perc <- round(100 * count_column / den, 1)
  N_per_1000 <- round((count_column /1000), 1)
  paste0(N_per_1000, " (", perc, "%)")
}


####################################################
#### read the params into fetching sql queries 
####################################################
# Load required libraries
library(DBI)
library(bigrquery)
library(dplyr)
library(purrr)
library(glue)
library(stringr)
library(yaml)

# Define the function
fetch_data_from_sql_yml <- function(credentials_path, project, folder_path) {
  # Set the environment variable for Google Cloud credentials
  Sys.setenv(GOOGLE_APPLICATION_CREDENTIALS = credentials_path)
  
  # Connect to BigQuery
  conn <- dbConnect(
    bigrquery::bigquery(),
    project = project,
    use_legacy_sql = FALSE
  )
  
  # Ensure to disconnect after we're done
  on.exit(dbDisconnect(conn), add = TRUE)
  
  # Read YAML parameters
  sql_params <- yaml::read_yaml("sql_params.yml")
  
  # List SQL files in the specified folder
  sql_files <- list.files(path = folder_path, pattern = "\\.sql$", full.names = TRUE)
  
  # Function to replace placeholders in the SQL query
  replace_placeholders <- function(sql_query, params) {
    for (param in names(params)) {
      # Replace @param_name with the corresponding value in params
      sql_query <- str_replace_all(sql_query, paste0("@", param), params[[param]])
    }
    return(sql_query)
  }

  # Safely execute the query to handle errors
  safe_query <- safely(dbGetQuery)

  # Process each SQL file
  combined_df <- sql_files %>%
    map_dfr(~{
      # Read SQL query from the file
      sql_query <- readLines(.x, warn = FALSE) %>% 
        paste(collapse = "\n") 
      
      # Replace placeholders with actual values from the YAML
      sql_query <- replace_placeholders(sql_query, sql_params)

      # Print the final SQL query for debugging
      print(sql_query)

      # Execute the query and capture results
      result <- safe_query(conn, sql_query)

      # Handle possible errors
      if (!is.null(result$error)) {
        warning(glue(
          "Query failed for {basename(.x)}: {result$error$message}\nSQL:\n{sql_query}"
        ))
        return(NULL)
      }
      
      df <- result$result %>%
        mutate(sql_file_name = basename(.x))  # Add file name to the result
      
      return(df)
    })
  
  # Return the combined results as a data frame
  return(combined_df)
}



## 2nd function 
library(DBI)
library(bigrquery)
library(dplyr)
library(purrr)
library(glue)
library(stringr)
library(yaml)

# Define the function
fetch_data_from_sql_yml2 <- function(credentials_path, project, folder_path) {
  Sys.setenv(GOOGLE_APPLICATION_CREDENTIALS = credentials_path)
  
  conn <- dbConnect(
    bigrquery::bigquery(),
    project = project,
    use_legacy_sql = FALSE
  )

  on.exit(dbDisconnect(conn), add = TRUE)
  
  sql_params <- yaml::read_yaml("sql_params.yml")
  
  sql_files <- list.files(path = folder_path, pattern = "\\.sql$", full.names = TRUE)
  
  replace_placeholders <- function(sql_query, params) {
    for (param in names(params)) {
      # We replace the table references completely
      sql_query <- str_replace_all(sql_query, 
       paste0("@", param), 
     params[[param]])
    }
    return(sql_query)
  }

  safe_query <- safely(dbGetQuery)

  combined_df <- sql_files %>%
    map_dfr(~{
      sql_query <- readLines(.x, warn = FALSE) %>% 
        paste(collapse = "\n")
      
      # Replace placeholders with actual values from the YAML
      sql_query <- replace_placeholders(sql_query, sql_params)

      # Debug: print the final SQL query
      print(glue("Final SQL Query: \n{sql_query}"))

      # Execute the query and capture results
      result <- safe_query(conn, sql_query)

      # Handle possible errors
      if (!is.null(result$error)) {
        warning(glue(
          "Query failed for {basename(.x)}: {result$error$message}\nSQL:\n{sql_query}"
        ))
        return(NULL)
      }
      
      df <- result$result %>%
        mutate(sql_file_name = basename(.x))
      
      return(df)
    })
  
  return(combined_df)
}