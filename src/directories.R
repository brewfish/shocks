# Sets file paths for commonly used directories on the NCEAS Aurora server, where raw data and processed data are stored.

# # Aurora server data directories
dir_server <- file.path("","home","shares","clean-seafood") # Top level of clean seafood project in Aurora server
dir_data <- file.path("","home","shares","clean-seafood","data") # Processed data directory
dir_raw_data <- file.path("","home","shares","clean-seafood","raw_data") # Raw data directory
dir_iucn <- file.path("","home","shares","aquaculture","ARF","iucn") # IUCN data (from outside clean seafood project)

# # Once defined, the safest way to call a something within
# # one of the below directories in your code is as follows:
# # e.g. file.path(dir_raw_data, "name_of_subdirectory", "name_of_file.csv"