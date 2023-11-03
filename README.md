# 🚀 Database Query and Data Visualization Script

This is a script written in R for querying a MySQL database and creating a histogram of contract end dates. The script uses the `RMySQL` and `ggplot2` libraries for database connectivity and data visualization, respectively.

📊 **Data Visualization:** The script connects to a MySQL database, retrieves data based on a SQL query, and filters the data to find contracts that ended before their engagement date. It then creates a histogram to visualize the distribution of these contract end dates.

## 🧰 Prerequisites

Before running this script, make sure you have the following:

- **R** installed on your system.
- The **RMySQL** and **ggplot2** packages installed.

## 🔎 Instructions

1. Load the necessary R packages.
```R
library(RMySQL) # Load the RMySQL package
library(ggplot2)  # Add ggplot2 for data visualization
```

2. Load the database credentials from a configuration file. Ensure you have a file named `db_credentials.R` with the necessary database connection information.

3. Establish a database connection using the provided credentials.
```R
con <- dbConnect(MySQL(),
                 host = db_config$host,
                 port = db_config$port,
                 dbname = db_config$dbname,
                 user = db_config$username,
                 password = db_config$password)
```

4. Read the SQL query from a file named `query.sql`.
```R
query <- readLines("query.sql", warn = FALSE)
query <- paste(query, collapse = "\n")
```

5. Execute the SQL query and store the result in a data frame.
```R
data <- dbGetQuery(con, query)
```

6. Close the database connection.
```R
dbDisconnect(con)
```

7. Convert the `contractEndDate` and `contractEndEngagementDate` columns to Date objects for further analysis.
```R
data$contractEndDate <- as.Date(data$contractEndDate)
data$contractEndEngagementDate <- as.Date(data$contractEndEngagementDate)
```

8. Filter the data to select contracts that ended before their engagement date.
```R
data <- data[data$contractEndDate < data$contractEndEngagementDate, ]
```

9. Check if the 'result' directory exists, and create it if not.
```R
if (!dir.exists("./result")) {
  dir.create("./result")
}
```

10. Specify the file path for saving the histogram image.
```R
file_path <- "./result/contract_end_dates.png"
```

11. Create a histogram of filtered contract end dates using ggplot2.
```R
p <- ggplot(data, aes(x = contractEndDate)) +
  geom_histogram(binwidth = 30, fill = "#1d0086", color = "#000000") +
  labs(title = "Contracts Ended Before Engagement Date",
       x = "Date",
       y = "Count") +
  theme_minimal() +
  theme(panel.background = element_rect(fill = "white"))
```

12. Save the image to the specified file path.
```R
ggsave(file_path, plot = p)
```

## 🚴 Running the script

Run the script in your R environment to connect to the database, perform the data analysis, and generate the histogram.

Feel free to modify the SQL query in `query.sql` and adjust the visualization parameters in the script to suit your specific needs.

## 📜 License

This script is © 2023 by Arnaud Coral. It's licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Please refer to the license for permissions and restrictions.