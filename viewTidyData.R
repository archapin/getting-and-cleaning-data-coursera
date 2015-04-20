address <- "https://s3.amazonaws.com/coursera-uploads/user-67e793ab66595d75900a9df1/973500/asst-3/77d38620e71811e48d3409aae8342d67.txt"
address <- sub("^https", "http", address)
dataARHC <- read.table(url(address), header = TRUE)
View(dataARHC)