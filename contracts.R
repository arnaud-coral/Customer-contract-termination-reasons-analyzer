library(RMySQL) # Load the RMySQL package
library(ggplot2)  # Add ggplot2 for data visualization

# Load database credentials from the configuration file
source("db_credentials.R")

# Establish a database connection
con <- dbConnect(MySQL(),
                 host = db_config$host,
                 port = db_config$port,
                 dbname = db_config$dbname,
                 user = db_config$username,
                 password = db_config$password)

# Read the SQL query from the file
query <- readLines("query.sql", warn = FALSE)
query <- paste(query, collapse = "\n")

# Execute the query and store the result in a data frame
data <- dbGetQuery(con, query)

# Close the database connection
dbDisconnect(con)

# Convert contractEndDate and contractEndEngagementDate to Date objects
data$contractEndDate <- as.Date(data$contractEndDate)
data$contractEndEngagementDate <- as.Date(data$contractEndEngagementDate)

# Filter data for contracts that ended before the engagement date
data <- data[data$contractEndDate < data$contractEndEngagementDate, ]

# Check if the 'result' directory exists, and create it if not
if (!dir.exists("./result")) {
  dir.create("./result")
}

# Specify the file path for saving the image
file_path <- "./result/contract_end_dates.png"

# Create a histogram of filtered contract end dates
p <- ggplot(data, aes(x = contractEndDate)) +
  geom_histogram(binwidth = 30, fill = "#1d0086", color = "#000000") +
  labs(title = "Contracts Ended Before Engagement Date",
       x = "Date",
       y = "Count") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "white"))

# Save the image to the specified file path
ggsave(file_path, plot = p)