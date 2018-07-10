# set working environment
rm(list=ls())
setwd("~/Dropbox/Apps/Bank-of-China-Exchange-Rate")
require(plotrix)

# read data from CSV files
gbp <- read.csv("Data/GBP.csv", header = TRUE, stringsAsFactors = FALSE)
usd <- read.csv("Data/USD.csv", header = TRUE, stringsAsFactors = FALSE)

# remove duplicated rows
gbp <- gbp[!duplicated(gbp), ]
usd <- usd[!duplicated(usd), ]
rownames(gbp) <- 1:nrow(gbp)
rownames(usd) <- 1:nrow(usd)

# sort the two dataframe by date and time in increasing order
gbp <- gbp[order(gbp$发布时间, decreasing = FALSE), ]
usd <- usd[order(usd$发布时间, decreasing = FALSE), ]

# plot
png(filename = "Figure/BOC.png")
twoord.plot(1:nrow(gbp), gbp$现汇卖出价, 1:nrow(usd), usd$现汇卖出价, 
            xlab = paste(as.character(gbp$发布时间[1]), "-", as.character(gbp$发布时间[nrow(gbp)]), sep="  "),
            ylab = "GBP", rylab = "USD", lcol = 4, type = "l",
            main = "Bank of China Exchange Rate",
            do.first = "plot_bg();grid(col=\"white\",lty=1)")
dev.off()

# save processed data back into original files
gbp <- gbp[order(gbp$发布时间, decreasing = TRUE), ]
usd <- usd[order(usd$发布时间, decreasing = TRUE), ]
write.csv(gbp, file = "Data/GBP.csv", row.names = FALSE)
write.csv(usd, file = "Data/USD.csv", row.names = FALSE)

