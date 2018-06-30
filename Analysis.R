# set working environment
setwd("~/Dropbox/Apps/BOC-Currency")

# read data from CSV files
gbp <- read.csv("GBP.csv", header = TRUE)
usd <- read.csv("USD.csv", header = TRUE)

# remove duplicated rows
gbp <- gbp[!duplicated(gbp), ]
usd <- usd[!duplicated(usd), ]
rownames(gbp) <- 1:nrow(gbp)
rownames(usd) <- 1:nrow(usd)

# sort the two dataframe by date and time in increasing order
isDate <- function(mydate, date.format = "%Y-%m-%d %H:%M:%S") {
  tryCatch(!is.na(as.Date(mydate, date.format)),  
           error = function(err) {FALSE})  
}
if (length(which(!isDate(gbp$发布时间))) != 0) {
  gbp$发布时间 <- as.POSIXct(gbp$发布时间[which(!isDate(gbp$发布时间))], format = "%Y.%m.%d %H:%M:%S", tz = "CST")
  usd$发布时间 <- as.POSIXct(usd$发布时间[which(!isDate(usd$发布时间))], format = "%Y.%m.%d %H:%M:%S", tz = "CST")
}
gbp <- gbp[order(gbp$发布时间, decreasing = FALSE), ]
usd <- usd[order(usd$发布时间, decreasing = FALSE), ]

# plot
png(filename = "GBP.png")
plot(gbp$现汇卖出价, type = "l", col = "red", xlab = paste("Time from", as.character(gbp$发布时间[1]), "to", as.character(gbp$发布时间[nrow(gbp)]), sep=" "), ylab = "GBP", main = "GBP Exchange Rate (Bank of China)")
dev.off()
png(filename = "USD.png")
plot(usd$现汇卖出价, type = "l", col = "blue", xlab = paste("Time from", as.character(usd$发布时间[1]), "to", as.character(usd$发布时间[nrow(usd)]), sep=" "), ylab = "USD", main = "USD Exchange Rate (Bank of China)")
dev.off()

# save processed data back into original files
write.csv(gbp, file = "GBP.csv", row.names = FALSE)
write.csv(usd, file = "USD.csv", row.names = FALSE)

