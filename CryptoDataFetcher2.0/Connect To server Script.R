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


#-----------
data <- read.csv("H_all_coins.csv")



# Write data to the SQL database

dbWriteTable(con, "new_test", data, overwrite = TRUE)

