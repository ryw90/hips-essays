# Load required packages
# install.packages('ggplot2')
require(ggplot2)

# Bring in data
data <- read.csv('posting-times.csv', stringsAsFactors=F)
data <- subset(data, id!='prof')

# Format assignment
data <- subset(data, assignment > 1 & assignment < 10) # drop assignments 1 & 10
data$assignment <- paste('Assignment ', data$assignment, sep='')

# Format date/times
data$date <- as.Date(data$date, format="%m/%d/%Y")
data$time <- unlist(lapply(strsplit(data$time1, ":"), function(x) as.integer(x[1]) + as.integer(x[2])/60))
data$time <- data$time - 12 * as.integer(data$time > 12)
data$time24 <- data$time + 12 * as.integer(data$ampm == "PM")
data$time24 <- data$time24 - 12 * as.integer(data$ampm == "AM" & floor(data$time) == 12)
data$am <- as.integer(data$ampm == "AM")

# Calculate time to deadline
deadline <- data.frame( as.Date('2011-04-07', format='%Y-%m-%d') + seq(0,56,7),
                        paste('Assignment', 2:10) )
names(deadline) <- c('deadline', 'assignment')
data <- merge(data, deadline, all.x=T)
data$to_deadline <- as.double((data$deadline - data$date) * 24 - data$time24 + 9)
quantile(data$to_deadline, 1:10*.1)
data <- subset(data, to_deadline <= 24 & to_deadline >= -1 ) # within band around deadline  
data$to_deadline2 <- 24 - data$to_deadline

# Plot in polar coordinates
p1 <- ggplot(data, aes(x=time, y=to_deadline2, color=ampm, ymin=-2, ymax=35)) + 
      scale_x_continuous(limits=c(0,12), breaks=0:11, labels=c(12, 1:11)) + 
      theme(panel.grid.major=element_blank(), 
            panel.grid.minor=element_blank(), 
            axis.ticks=element_blank(), 
            axis.text.y=element_blank()) + 
      xlab('') +
      ylab('') +      
      geom_point() + 
      coord_polar(theta='x') +
      facet_grid(~assignment, labeller=function(x) paste('Assignment',x)) +
      facet_wrap(~assignment, ncol=3)
ggsave(plot=p1, filename='posting-times.png', height=7, width=7)
