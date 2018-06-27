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

# save processed data back into original files
write.csv(gbp, file = "GBP.csv", row.names = FALSE)
write.csv(usd, file = "USD.csv", row.names = FALSE)

# sort the two data by row names in decreasing order
gbp <- gbp[order(as.numeric(rownames(gbp)), decreasing = TRUE), ]
usd <- usd[order(as.numeric(rownames(usd)), decreasing = TRUE), ]

# plot
plot(gbp$现汇卖出价, type="l", col="red") # ylim=c(600,900)
plot(usd$现汇卖出价, type="l", col="blue")
