data <- read.table("T.txt", header = TRUE, sep = "\t")
head(data[1:5,1:5])

numeric_data <- data[,-c(1)]
head(numeric_data[1:5,1:5])


replace_na_with_median <- function(row) {
  row[is.na(row)] <- median(row, na.rm = TRUE)
  return(row)
}

numeric_data <- t(apply(numeric_data, 1, replace_na_with_median))

data[,-c(1)] <- numeric_data

N <- read.table("N.txt", header = TRUE, sep = "\t")
head(N[1:5,1:5])
N_data <- t(apply(N, 1, replace_na_with_median))
a <- cbind(data,N_data)
write.csv(t(a), "tpot_input.NA.csv",  quote = FALSE)
