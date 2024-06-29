sql_ready_df <- sqlData(con, data)
str(sql_ready_df)
write.csv(sql_ready_df, "sql_all_crypto_prices.csv", row.names = FALSE)


library(DBI)
library(odbc)

# Set up your Azure SQL Database connection
driver <- "ODBC Driver 17 for SQL Server"
server <- "cp-io-sql.database.windows.net"
database <- "sql_db_ohlcv"
uid <- "yogass09"
pwd <- "Qwerty@312"
port <- 1433
timeout <- 30

# Try to connect to the database
tryCatch({
  con <- dbConnect(odbc::odbc(), 
                   Driver = driver, 
                   Server = server, 
                   Database = database, 
                   UID = uid, 
                   PWD = pwd, 
                   Port = port,
                   Timeout = timeout)
  message("Connected to the database successfully!")
  
  # Your database operations go here
  
  # Disconnect from the database
  #------------dbDisconnect(con)
}, error = function(e) {
  message("Failed to connect to the database. Error: ", e$message)
})



# Assume sql_ready_df is already loaded in your environment

# Function to upload dataframe in chunks
upload_dataframe_in_chunks <- function(df, con, chunk_size = 1e5, table_name = "sql_all_crypto_prices.csv") {
  # Get the total number of rows
  total_rows <- nrow(df)
  
  # Calculate the number of chunks
  num_chunks <- ceiling(total_rows / chunk_size)
  
  for (i in 1:num_chunks) {
    # Determine the start and end rows for the current chunk
    row_start <- (i - 1) * chunk_size + 1
    row_end <- min(i * chunk_size, total_rows)
    
    # Extract the chunk
    chunk <- df[row_start:row_end, ]
    
    # Append the chunk to the SQL table
    dbWriteTable(con, table_name, chunk, row.names = FALSE, append = TRUE)
  }
}

# Call the function to upload the dataframe in chunks
upload_dataframe_in_chunks(sql_ready_df, con, table_name = "sql_all_crypto_prices.csv")

