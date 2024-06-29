# Record the start time
  start_time <- Sys.time()
 
# get data------------------------
 # all_coins_historical<-crypto_history(coin_list = coin_list_all,convert = "USD", limit = 10000,sleep = 0)
 
# who dat 
  library(DBI)
  library(odbc)
  library(dplyr)
  
 
## UPLOAD TO AZURE ##
  length(unique(all_coins_historical$id))
# Set up your Azure SQL Database connection
  con <- dbConnect(odbc::odbc(),Driver = "ODBC Driver 17 for SQL Server",Server = "cp-io-sql.database.windows.net",Database = "sql_db_ohlcv",
                 UID = "yogass09",
                 PWD = "Qwerty@312",
                 Port = 1433)
 
# Write data to the SQL database
  # Assuming 'all_coins_historical' is your tibble
  dbWriteTable(con, "all_coins_historical", as.data.frame(all_coins_historical), overwrite = TRUE)
  
 
# Disconnect from the database
  dbDisconnect(con)
 
# Calculate and print the execution time
  end_time <- Sys.time()
  execution_time <- end_time - start_time
  cat("Execution time:", execution_time, "\n")
# 
 
  #write.csv(all_coins_historical, "H_all_coins.csv", row.names = FALSE)
  