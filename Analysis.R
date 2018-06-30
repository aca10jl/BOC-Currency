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
gbp$发布时间 <- as.POSIXct(gbp$发布时间, format = "%Y.%m.%d %H:%M:%S", tz = "GMT")
usd$发布时间 <- as.POSIXct(usd$发布时间, format = "%Y.%m.%d %H:%M:%S", tz = "GMT")
gbp <- gbp[order(gbp$发布时间, decreasing = FALSE), ]
usd <- usd[order(usd$发布时间, decreasing = FALSE), ]

# plot
plot(gbp$现汇卖出价, type = "l", col = "red", xlab = "Time", ylab = "GBP", main = "Bank of China Currency") # ylim=c(600,900)
plot(usd$现汇卖出价, type = "l", col = "blue", xlab = "Time", ylab = "USD", main = "Bank of China Currency")

# save processed data back into original files
write.csv(gbp, file = "GBP.csv", row.names = FALSE)
write.csv(usd, file = "USD.csv", row.names = FALSE)
