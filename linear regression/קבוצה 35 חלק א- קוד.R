#packages
install.packages("e1071")
install.packages("ggplot2")
install.packages("viridis")
install.packages("gridExtra")
install.packages("hexbin")

------------------------------------
#libraries
library(e1071)
library(ggplot2)
library(viridis) 
library(viridisLite) 
library(gridExtra)
library(hexbin)

# Loading the data
Dataset <- read.csv(file.choose(), header=T, stringsAsFactors=FALSE, fileEncoding="latin1")
#getting rid of unwanted col
Dataset <- Dataset[, 1:12] 
Dataset <- Dataset[-99, ]  #delete row number 100

#----------------Question 4-------------

# Building a new table with the five specified columns
dataset_selected <- Dataset[,(names(Dataset) %in%  c("youtube.views..m", "loudness", "speechiness", "energy", "duration_ms"))]
# Correlation matrix
cor_matrix_selected <- cor(dataset_selected)
# Graph - correlation matrix
plot(cor_matrix_selected, main = "Correlation Matrix - Selected Columns")
# Graphs - pairs of columns
pairs(dataset_selected, main = "Pairs Plot - Selected Columns")
summary(dataset_selected)

#----------------Question 5+6-------------

summary(Dataset)

#-------------------Youtube Views--------------------
youtube_views<- Dataset$youtube.views..m
sd(youtube_views)
skewness(youtube_views)
# Boxplot
bp<-boxplot(youtube_views, main="Boxplot - Youtube Views")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(youtube_views)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")

#-----------------------------energy-------------------------------
Energy<- Dataset$energy
sd(Energy)
skewness(Energy)
bp<-boxplot(Energy, main="Boxplot - energy")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Energy)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")
#-----------------------------loudness-------------------------------
Loudness<- Dataset$loudness
sd(Loudness)
skewness(Loudness)
bp<-boxplot(Loudness, main="Boxplot - loudness")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Loudness)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")
#--------------------------speechiness---------------------

Speechiness<- Dataset$speechiness
sd(Speechiness)
skewness(Speechiness)
bp<-boxplot(Speechiness, main="Boxplot - speechiness")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Speechiness)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")
#--------------------acousticness-------------------------

Acousticness<- Dataset$acousticness
sd(Acousticness)
skewness(Acousticness)
bp<-boxplot(Acousticness, main="Boxplot - acousticness")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Acousticness)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")

#------------------------liveness------------------------------
Liveness<- Dataset$liveness
sd(Liveness)
skewness(Liveness)
bp<-boxplot(Liveness, main="Boxplot - Liveness")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Liveness)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")

#----------------------valence--------------------
Valence<- Dataset$valence
sd(Valence)
skewness(Valence)
bp<-boxplot(Valence, main="Boxplot - valence")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Valence)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")

#----------------------tempo--------------------
Tempo<- Dataset$tempo
sd(Tempo)
skewness(Tempo)
bp<-boxplot(Tempo, main="Boxplot - tempo")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Tempo)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")

#-----------------------duration_ms-----------------------
Duration<- Dataset$duration_ms
sd(Duration)
skewness(Duration)
bp<-boxplot(Duration, main="Boxplot - duration_ms")
#Viewing values in a range
bp$stats 
#Viewing unusual values
bp$out
#Print the values by order
summary_stats <- summary(Duration)
cat("Minimum:", summary_stats[1], "\n")
cat("Q1:", summary_stats[2], "\n")
cat("Median:", summary_stats[3], "\n")
cat("Q3:", summary_stats[5], "\n")
cat("Maximum:", summary_stats[6], "\n")

#------------------------------mode ~ shazam-----------------------------------
#--------------minor-------------
#Database only with minors
minor_data <- Dataset[Dataset$mode == 0, ]
summary(minor_data)
sd <- sd(minor_data$shazam)
skewness <- skewness(minor_data$shazam)
cat("Standard Deviation:", sd, "\n")
cat("Skewness:", skewness, "\n")
cat("Minimum:",  min(minor_data$shazam), "\n")
cat("Q1:", quantile((minor_data$shazam), 0.25), "\n")
cat("Median:", median(minor_data$shazam), "\n")
cat("Mean:", mean(minor_data$shazam), "\n")
cat("Q3:", quantile((minor_data$shazam), 0.75), "\n")
cat("Maximum:", max(minor_data$shazam), "\n")

#--------------major-------------
#Database only with major
major_data <- Dataset[Dataset$mode == 1, ]
summary(major_data)
sd1 <- sd(major_data$shazam)
skewness1 <-skewness(major_data$shazam)
cat("Standard Deviation:", sd1, "\n")
cat("Skewness:", skewness1, "\n")
cat("Minimum:",  min(major_data$shazam), "\n")
cat("Q1:", quantile(major_data$shazam, 0.25), "\n")
cat("Median:", median(major_data$shazam), "\n")
cat("Mean:", mean(major_data$shazam), "\n")
cat("Q3:", quantile(major_data$shazam, 0.75), "\n")
cat("Maximum:", max(major_data$shazam), "\n")

#----------------------mode ~ shazam-------------------------

colors <- c("#9F6AF7", "#FEE090")
#Pie chart that aggregate shazam average values by minors & majors
table1 <- aggregate(x= Dataset$shazam,
                    by=list(Dataset$mode),
                    FUN=mean)
pie(table1$x,table1$Group.1, main="mode ~ shazam ",col=colors)
legend("right",legend=table1$x,fill=colors,cex=0.8)

#-----------------------Question 7----------------------
#Function that receive dataset, column name and then plot the histogram and ecdf:
plotHistogramAndECDF <- function(dataset, column_name) {
  # Check if the column exists in the dataset
  if (!column_name %in% names(dataset)) {
    stop("Column name does not exist in the dataset")
  }
  
  # Extract the column data
  column_data <- dataset[[column_name]]
  
  # Set up the plotting area to have 2 plots side by side
  par(mfrow = c(1, 2))
  
  # Histogram with density
  hist(column_data, main = paste("Histogram -", column_name), xlab = column_name, ylab = "Density", col = "lightblue", border = "black", freq = FALSE)
  lines(density(column_data), col = "blue", lwd = 2)
  
  
  # ECDF with normal curve
  plot(ecdf(column_data), main = paste("ECDF -", column_name), xlab = column_name, ylab = "Cumulative Probability", col = "green", do.points = FALSE)
  curve(pnorm(x, mean = mean(column_data), sd = sd(column_data)), add = TRUE, col = "blue", lwd = 2)
  
  
  # Reset the plotting layout
  par(mfrow = c(1, 1))
}

#--------------- youtube.views..m---------------
plotHistogramAndECDF(Dataset, "youtube.views..m")

#-------------------- loudness-------------------
plotHistogramAndECDF(Dataset, "loudness")

#-------------------- energy---------------------
plotHistogramAndECDF(Dataset, "energy")

#------------------- valence---------------------
plotHistogramAndECDF(Dataset, "valence")

#---------------------Question 8----------------------

# Subset of necessary columns (mode, energy, loudness)
plot_data <- Dataset[, c("mode", "energy", "loudness")]

# Convert 'mode' from numeric to factor for clearer categorization in the plot
plot_data$mode <- factor(plot_data$mode, levels = c(0, 1), labels = c("Minor", "Major"))

# Create the scatterplot
with(plot_data, {
  # Plot points with color by 'mode'
  plot(energy, loudness, col = ifelse(mode == "Major", "red", "blue"),
       xlab = "Energy", ylab = "Loudness", pch = ifelse(mode == "Major", 19, 17),
       main = "Scatterplot of Energy vs. Loudness by Mode")
  
  # Add legend
  legend("topleft", legend = c("Minor", "Major"), col = c("blue", "red"), pch = c(17, 19))
})

#---------------------Question 9----------------------
#----------------graph 1:
# Hexbin plot for Speechiness vs Energy
hex_plot <- ggplot(Dataset, aes(x = speechiness, y = energy)) +
  geom_hex(bins = 30) +
  labs(x = "Speechiness", y = "Energy") +
  theme_minimal() +
  scale_fill_viridis_c()
hex_plot

# Histogram for Energy without labels and axes
energy_hist <- ggplot(Dataset, aes(x = energy)) +
  geom_histogram(fill = viridis::viridis(1, begin = 0.85, end = 0.95, option = "D"), color = "black", bins = 30) +
  labs(x = NULL, y = NULL) +  # Remove x and y axis labels
  theme_void() + # Remove axis lines and ticks
  coord_flip() 

# Histogram for Speechiness without labels and axes
speechiness_hist <- ggplot(Dataset, aes(x = speechiness)) +
  geom_histogram(fill = viridis::viridis(1, begin = 0.85, end = 0.95, option = "D"), color = "black", bins = 30) +
  labs(x = NULL, y = NULL) +  # Remove x and y axis labels
  theme_void()   # Remove axis lines and ticks

# Create empty plot placeholders for spacing
empty_plot <- ggplot() + theme_void()

# Arrange the plots
grid.arrange(
  arrangeGrob(
    speechiness_hist, 
    empty_plot, 
    widths = c(1, 1)
  ),
  arrangeGrob(
    hex_plot, 
    energy_hist, 
    widths = c(1, 1)
  ),
  layout_matrix = rbind(c(1, 1), c(2, 2))
)

#----------------graph 2:

# division of the mode variables by colors
colors <- c("0" = "green", "1" = "blue")

# violin plot- Distribution of Energy by Mode
ggplot(Dataset, aes(x = as.factor(gender), y = energy, fill = as.factor(gender))) +
  geom_violin(trim = FALSE) +
  scale_fill_manual(values = colors) +
  labs(title = "Distribution of Energy by gender", x = "gender", y = "Energy") +
  theme_minimal()

#---------------------Question 10----------------------
# One-dimensional frequency table for the variable mode
mode_freq_table <- table(Dataset$mode)
print(mode_freq_table)

# One-dimensional frequency table for the variable gender
mode_freq_table <- table(Dataset$gender)
print(mode_freq_table)


# Two-dimensional frequency table for mode and gender
mode_gender_freq_table <- table(Dataset$gender, Dataset$mode)
print(mode_gender_freq_table)

