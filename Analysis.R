# set working environment
rm(list=ls())
setwd("~/Dropbox/Apps/BOC-Currency")
require(plotrix)

# read data from CSV files
gbp <- read.csv("GBP.csv", header = TRUE, stringsAsFactors = FALSE)
usd <- read.csv("USD.csv", header = TRUE, stringsAsFactors = FALSE)

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
invalidDate <- which(!isDate(gbp$发布时间))
if (length(invalidDate) > 0) {
  gbp$发布时间[invalidDate] <- as.character(as.POSIXct(gbp$发布时间[invalidDate], format = "%Y.%m.%d %H:%M:%S", tz = "CST"))
}
invalidDate <- which(!isDate(usd$发布时间))
if (length(invalidDate) > 0) {
  usd$发布时间[invalidDate] <- as.character(as.POSIXct(usd$发布时间[invalidDate], format = "%Y.%m.%d %H:%M:%S", tz = "CST"))
}
gbp <- gbp[order(gbp$发布时间, decreasing = FALSE), ]
usd <- usd[order(usd$发布时间, decreasing = FALSE), ]

# plot
png(filename = "BOC.png")
twoord.plot(1:nrow(gbp), gbp$现汇卖出价, 1:nrow(usd), usd$现汇卖出价, 
            xlab = paste(as.character(gbp$发布时间[1]), "-", as.character(gbp$发布时间[nrow(gbp)]), sep="  "),
            ylab = "GBP", rylab = "USD", lcol = 4, type = "l",
            main = "Bank of China Exchange Rate",
            do.first = "plot_bg();grid(col=\"white\",lty=1)")
dev.off()

# save processed data back into original files
write.csv(gbp, file = "GBP.csv", row.names = FALSE)
write.csv(usd, file = "USD.csv", row.names = FALSE)

