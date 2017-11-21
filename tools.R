plotfd = function(row, ...)
{
    with(row, lines(c(0, leftx, rightx, 1)
                    , c(0, lefty, righty, 0), ...))
}


# Add the color in at this point
#display.brewer.all(colorblindFriendly = TRUE)

#nclust = length(unique(station_cluster$cluster))
#
#colors = RColorBrewer::brewer.pal(nclust, "Dark2")
#
## Maybe just 2 colors, brewer.pal always gives 3
#colors = colors[1:nclust]

# Generated from RColorBrewer
colors = c("#1B9E77", "#D95F02")

# Trim quantiles
qtrim = function(x, lower = 0.025, upper = 0.975)
{
    x[(quantile(x, lower) < x) & (x < quantile(x, upper))]
}


