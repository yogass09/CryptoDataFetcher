# Record the start time

start_time <- Sys.time()

# get data

btc_daily<-crypto_history(coin_list = coin_list_all,
                             convert = "USD", # change to USD or other currency if desired
                             limit = 1,
                             sleep = 0)
# who dat 

library(DBI)
library(odbc)

# Set up your Azure SQL Database connection

con <- dbConnect(odbc::odbc(),
                 Driver = "ODBC Driver 17 for SQL Server",
                 Server = "cp-io-sql.database.windows.net",
                 Database = "sql_db_ohlcv",
                 UID = "yogass09",
                 PWD = "Qwerty@312",
                 Port = 1433)


# Write data to the SQL database

dbWriteTable(con, "btc_daily", btc_daily, overwrite = TRUE)

# Disconnect from the database

dbDisconnect(con)


# Calculate and print the execution time

end_time <- Sys.time()
execution_time <- end_time - start_time
cat("Execution time:", execution_time, "\n")

