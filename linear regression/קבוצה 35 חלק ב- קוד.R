#packages
install.packages("e1071")
install.packages("ggplot2")
install.packages("dbscan")
install.packages("strucchange")
#------------------------------
#library
library(ggplot2)
library(e1071)
library(dbscan)
library(strucchange)
#------------------------------
# Loading the data
Dataset <- read.csv(file.choose(), header=T, stringsAsFactors=FALSE, fileEncoding="latin1")
#getting rid of unwanted col
Dataset <- Dataset[, 1:12] 
Dataset <- Dataset[-99, ]  #delete row number 100
#---------2.1---------------------
# בחירת כל העמודות חוץ מ-"shazam"
dataset_selected <- Dataset[, !(names(Dataset) %in% c("mode","gender"))]
# מטריצת קורלציה
cor_matrix <- cor(dataset_selected)
lm_model <- lm(shazam ~mode+gender+youtube.views..m+ energy + loudness + speechiness + acousticness + liveness +valence + tempo + duration_ms, data = Dataset)
# summary of the nodel
summary(lm_model)
initData<-Dataset[, !(names(Dataset) %in% c("energy","duration_ms"))]
#---------2.2---------------------

datasetTest1 <- initData

#dividing Liveness for Categories
datasetTest1$liveness[datasetTest1 <- datasetTest1$liveness > 0.5] <- 1
datasetTest1$liveness[(datasetTest1$liveness > 0.2) & (datasetTest1$liveness <= 0.5)] <- 0.5
datasetTest1$liveness[datasetTest1$liveness <= 0.2] <- 0
cor(datasetTest1$shazam, datasetTest1$liveness)
lm_model_withChange <- lm(shazam ~ mode + gender + youtube.views..m + loudness + speechiness + acousticness + liveness +valence + tempo , data = datasetTest1)
summary(lm_model_withChange)
cor_matrix <- cor(datasetTest1)


# Before- Plot the scatter plot with colored dots
plot(Dataset$liveness, Dataset$shazam, xlab = "liveness", ylab = "shazam",
main = "Liveness By Shazam", col = ifelse(Dataset$liveness > 0.5, "red", ifelse(Dataset$liveness > 0.2, "blue", "green")))
legend("topright", legend = c("High Liveness", "Medium Liveness", "Low Liveness"), col = c("red", "blue", "green")
       , pch = 1, title = "Liveness Level")


# Create a color vector based on the dividing
dot_colors <- ifelse(datasetTest1$liveness > 0.5, "red", ifelse(datasetTest1$liveness > 0.2, "blue", "green"))
# After- Plot the scatter plot with colored dots
plot(datasetTest1$liveness, datasetTest1$shazam, xlab = "liveness", ylab = "shazam", main = "Liveness By Shazam", col = dot_colors)
legend("topright", legend = c("High Liveness", "Medium Liveness", "Low Liveness"), col = c("red", "blue", "green")
       , pch = 1, title = "Liveness Level")

datasetTest1.1 <- datasetTest1
datasetTest1.1$loudness <- as.numeric(datasetTest1.1$loudness)*-10
lm_model_withChange1 <- lm(shazam ~ mode + gender + youtube.views..m + loudness + speechiness + acousticness + liveness +valence + tempo ,data = datasetTest1.1)
summary(lm_model_withChange1)
cor_matrix <- cor(datasetTest1.1)

#--------------2.3---------------------

initData2.3 <- datasetTest1.1
initData2.3$gender<-factor(initData2.3$gender,levels = c(0,1))
initData2.3$mode<-factor(initData2.3$mode,levels = c(0,1))
initData2.3$liveness<-factor(initData2.3$liveness,levels = c(0,0.5,1))

#--------------2.4---------------------
#--------var By Mode
Model1 <- lm(formula = initData2.3$shazam ~ (initData2.3$speechiness * factor(initData2.3$mode)))
summary(Model1)
plot(initData2.3$ speechiness[initData2.3$mode==0] ,initData2.3$shazam[initData2.3$mode==0],  xlab = "speechiness",
    ylab = "shazam", main = "Shazam VS Speechiness By Mode categories", col = ifelse(initData2.3$mode == 0, "blue1", "red3"))
abline(a = 6.6850, b = -5.3249, col = "blue1")
abline(a = 6.6850 -0.6547 , b = -5.3249-6.4965, col = "red3")
# Create legend
legend("topright", 
       legend = c("Mode 0 (Blue Dots)", "Mode 1 (Red Dots)", "Regression Line"), 
       col = c("blue1", "red3", "blue1"),  # Use the color you assigned to the points and the line
       lty = c(0, 0, 1),  # 0 for points, 1 for line
       pch = c(1, 1, NA)  # 1 for points, NA for no symbol for the line
      )

Model2 <- lm(formula = initData2.3$shazam ~ (initData2.3$tempo * factor(initData2.3$mode)))
summary(Model2)

plot(initData2.3$tempo[initData2.3$mode == 0], initData2.3$shazam[initData2.3$mode == 0], 
     xlab = "tempo", ylab = "shazam", main = "Shazam VS Tempo By Mode categories", 
     col = ifelse(initData2.3$mode == 0, "blue1", "red3"))
# Add the regression lines for tempo
abline(a = 8.161e+00, b = -1.821e-02, col = "blue1")
abline(a = 8.161e+00-1.201e+00, b = -1.821e-02 + 2.934e-05, col = "red3")
legend("topright", 
       legend = c("Mode 0 (Blue Dots)", "Mode 1 (Red Dots)", "Regression Line"), 
       col = c("blue1", "red3", "blue1"),  # Use the color you assigned to the points and the line
       lty = c(0, 0, 1),  # 0 for points, 1 for line
       pch = c(1, 1, NA)  # 1 for points, NA for no symbol for the line
)

Model3 <- lm(formula = initData2.3$shazam ~ (initData2.3$valence * factor(initData2.3$mode)))
summary(Model3)
# Plotting Shazam vs Valence by Mode
plot(initData2.3$valence[initData2.3$mode == 0], 
     initData2.3$shazam[initData2.3$mode == 0],  
     xlab = "Valence",
     ylab = "Shazam", 
     main = "Shazam VS Valence By Mode categories", 
     col = "blue1")

points(initData2.3$valence[initData2.3$mode == 1], 
       initData2.3$shazam[initData2.3$mode == 1],  
       col = "red3")
# Adding regression lines
abline(a = 6.9259, b = -1.7828, col = "blue1")  # Regression line for mode = 0
abline(a = 6.9259 + 0.6673, b = -1.7828 - 4.2742, col = "red3")  # Regression line for mode = 1
# Create legend
legend("topright", 
       legend = c("Mode 0 (Blue Dots)", "Mode 1 (Red Dots)", "Regression Line (Mode 0)", "Regression Line (Mode 1)"), 
       col = c("blue1", "red3", "blue1", "red3"),  
       lty = c(0, 0, 1, 1),  
       pch = c(1, 1, NA, NA)  
)

#--------var By Gender
Model4 <- lm(formula = initData2.3$shazam ~ (initData2.3$speechiness * factor(initData2.3$gender)))
summary(Model4)
# Plotting Shazam vs Speechiness by Gender
plot(initData2.3$speechiness[initData2.3$gender == 0], 
     initData2.3$shazam[initData2.3$gender == 0],  
     xlab = "Speechiness",
     ylab = "Shazam", 
     main = "Shazam VS Speechiness By Gender categories", 
     col = "green")
points(initData2.3$speechiness[initData2.3$gender == 1], 
       initData2.3$shazam[initData2.3$gender == 1],  
       col = "pink")
# Adding regression lines
abline(a = 5.5579, b = -3.6536, col = "green")  # Regression line for gender = 0
abline(a = 5.5579 + 0.6647, b = -3.6536 - 3.5807, col = "pink")  # Regression line for gender = 1
# Create legend
legend("topright", 
       legend = c("Gender 0 (Green Dots)", "Gender 1 (Pink Dots)", "Regression Line (Gender 0)", "Regression Line (Gender 1)"), 
       col = c("green", "pink", "green", "pink"),  
       lty = c(0, 0, 1, 1),  
       pch = c(1, 1, NA, NA)  
)

Model5 <- lm(formula = initData2.3$shazam ~ (initData2.3$tempo * factor(initData2.3$gender)))
summary(Model5)
# Plotting Shazam vs Tempo by Gender
plot(initData2.3$tempo[initData2.3$gender == 0], 
     initData2.3$shazam[initData2.3$gender == 0],  
     xlab = "Tempo",
     ylab = "Shazam", 
     main = "Shazam VS Tempo By Gender categories", 
     col = "pink")
points(initData2.3$tempo[initData2.3$gender == 1], 
       initData2.3$shazam[initData2.3$gender == 1],  
       col = "green")
# Adding regression lines
abline(a = 3.07950, b = 0.01934, col = "pink")  # Regression line for gender = 0
abline(a = 3.07950 + 4.94600, b = 0.01934 - 0.04208, col = "green")  # Regression line for gender = 1
# Create legend
legend("topright", 
       legend = c("Gender 0 (Pink Dots)", "Gender 1 (Green Dots)", "Regression Line (Gender 0)", "Regression Line (Gender 1)"), 
       col = c("pink", "green", "pink", "green"),  
       lty = c(0, 0, 1, 1),  
       pch = c(1, 1, NA, NA)  
)

Model6 <- lm(formula = initData2.3$shazam ~ (initData2.3$valence * factor(initData2.3$gender)))
summary(Model6)
# Plotting Shazam vs Valence by Gender
plot(initData2.3$valence[initData2.3$gender == 0], 
     initData2.3$shazam[initData2.3$gender == 0],  
     xlab = "Valence",
     ylab = "Shazam", 
     main = "Shazam VS Valence By Gender categories", 
     col = "pink")
points(initData2.3$valence[initData2.3$gender == 1], 
       initData2.3$shazam[initData2.3$gender == 1],  
       col = "green")
# Adding regression lines
abline(a = 8.125, b = -5.059, col = "pink")  # Regression line for gender = 0
abline(a = 8.125 - 1.448, b = -5.059 + 2.154, col = "green")  # Regression line for gender = 1
# Create legend
legend("topright", 
       legend = c("Gender 0 (Pink Dots)", "Gender 1 (Green Dots)", "Regression Line (Gender 0)", "Regression Line (Gender 1)"), 
       col = c("pink", "green", "pink", "green"),  
       lty = c(0, 0, 1, 1),  
       pch = c(1, 1, NA, NA)  
)

#--------var By liveness
Model7 <- lm(formula = initData2.3$shazam ~ (initData2.3$tempo * factor(initData2.3$liveness)))
summary(Model7)
# Plotting Shazam vs Tempo by Liveness
plot(initData2.3$tempo[initData2.3$liveness == 0], 
     initData2.3$shazam[initData2.3$liveness == 0],  
     xlab = "Tempo",
     ylab = "Shazam", 
     main = "Shazam VS Tempo By Liveness categories", 
     col = "blue")
points(initData2.3$tempo[initData2.3$liveness == 0.5], 
       initData2.3$shazam[initData2.3$liveness == 0.5],  
       col = "orange")
points(initData2.3$tempo[initData2.3$liveness == 1], 
       initData2.3$shazam[initData2.3$liveness == 1],  
       col = "purple")
# Adding regression lines
abline(a = 7.644074, b = -0.018429, col = "blue")  # Regression line for liveness = 0
abline(a = 7.644074 - 0.514240 + 13.543381, b = -0.018429 - 0.001312 - 0.176377, col = "orange") # Regression line for liveness = 0.5
abline(a = 7.644074 + 13.543381, b = -0.018429 - 0.176377, col = "purple")  # Regression line for liveness = 1
# Create legend
legend("topright", 
       legend = c("Liveness 0 (Blue Dots)", "Liveness 0.5 (Orange Dots)",
                  "Liveness 1 (Purple Dots)", "Regression Line (Liveness 0)",
                  "Regression Line (Liveness 0.5)", "Regression Line (Liveness 1)"), 
       col = c("blue", "orange", "purple", "blue", "orange", "purple"),  
       lty = c(0, 0, 0, 1, 1, 1),  
       pch = c(1, 1, 1, NA, NA, NA)  
)

Model8 <- lm(formula = initData2.3$shazam ~ (initData2.3$speechiness * factor(initData2.3$liveness)))
summary(Model8)
# Plotting Shazam vs Speechiness by Liveness
plot(initData2.3$speechiness[initData2.3$liveness == 0], 
     initData2.3$shazam[initData2.3$liveness == 0],  
     xlab = "Speechiness",
     ylab = "Shazam", 
     main = "Shazam VS Speechiness By Liveness categories", 
     col = "brown")
points(initData2.3$speechiness[initData2.3$liveness == 0.5], 
       initData2.3$shazam[initData2.3$liveness == 0.5],  
       col = "blue")
points(initData2.3$speechiness[initData2.3$liveness == 1], 
       initData2.3$shazam[initData2.3$liveness == 1],  
       col = "purple")
# Adding regression lines
abline(a = 6.3981, b = -7.9350, col = "brown")  # Regression line for liveness = 0
abline(a = 6.3981 - 1.7648 - 30.5721, b = -7.9350 + 10.3310 + 286.1774, col = "blue")  # Regression line for liveness = 0.5
abline(a = 6.3981 - 30.5721, b = -7.9350 + 286.1774, col = "purple")  # Regression line for liveness = 1
# Create legend
legend("topright", 
       legend = c("Liveness 0 (Brown Dots)", "Liveness 0.5 (Blue Dots)", "Liveness 1 (Purple Dots)", "Regression Line (Liveness 0)", "Regression Line (Liveness 0.5)", "Regression Line (Liveness 1)"), 
       col = c("brown", "blue", "purple", "brown", "blue", "purple"),  
       lty = c(0, 0, 0, 1, 1, 1),  
       pch = c(1, 1, 1, NA, NA, NA)  
)

Model9 <- lm(formula = initData2.3$shazam ~ (initData2.3$valence * factor(initData2.3$liveness)))
summary(Model9)
# Plotting Shazam vs Valence by Liveness
plot(initData2.3$valence[initData2.3$liveness == 0], 
     initData2.3$shazam[initData2.3$liveness == 0],  
     xlab = "Valence",
     ylab = "Shazam", 
     main = "Shazam VS Valence By Liveness categories", 
     col = "brown")
points(initData2.3$valence[initData2.3$liveness == 0.5], 
       initData2.3$shazam[initData2.3$liveness == 0.5],  
       col = "blue")
points(initData2.3$valence[initData2.3$liveness == 1], 
       initData2.3$shazam[initData2.3$liveness == 1],  
       col = "purple")
# Adding regression lines
abline(a = 7.089, b = -3.375, col = "brown")  # Regression line for liveness = 0
abline(a = 7.089 - 1.163 + 1.918, b = -3.375 + 1.105 - 4.614, col = "blue")  # Regression line for liveness = 0.5
abline(a = 7.089 + 1.918, b = -3.375 - 4.614, col = "purple")  # Regression line for liveness = 1
# Create legend
legend("topright", 
       legend = c("Liveness 0 (Brown Dots)", "Liveness 0.5 (Blue Dots)", "Liveness 1 (Purple Dots)", "Regression Line (Liveness 0)", "Regression Line (Liveness 0.5)", "Regression Line (Liveness 1)"), 
       col = c("brown", "blue", "purple", "brown", "blue", "purple"),  
       lty = c(0, 0, 0, 1, 1, 1),  
       pch = c(1, 1, 1, NA, NA, NA)  
)
initData2.4 <- initData2.3
#union Liveness Categories
initData2.4$liveness[(initData2.4$liveness == 0.5) ] <- 1
lm_model_withChange <- lm(shazam ~ mode + gender + youtube.views..m + loudness + speechiness + acousticness + liveness
                          +valence + tempo , data = initData2.4)
summary(lm_model_withChange)
cor_matrix <- cor(initData2.4)
initData2.4$liveness<-factor(initData2.4$liveness,levels = c(0,1))

Model10 <- lm(formula = initData2.4$shazam ~ (initData2.4$speechiness * factor(initData2.4$liveness)))
summary(Model10)
# Plotting Shazam vs Speechiness by Liveness
plot(initData2.4$speechiness[initData2.4$liveness == 0], 
     initData2.4$shazam[initData2.4$liveness == 0],  
     xlab = "Speechiness",
     ylab = "Shazam", 
     main = "Shazam VS Speechiness By Liveness categories", 
     col = "brown")

points(initData2.4$speechiness[initData2.4$liveness == 1], 
       initData2.4$shazam[initData2.4$liveness == 1],  
       col = "purple")

# Adding regression lines
abline(a = 6.3981, b = -7.9350, col = "brown")  # Regression line for liveness = 0
abline(a = 6.3981 - 1.8138, b = -7.9350 + 10.4669, col = "purple")  # Regression line for liveness = 1

# Create legend
legend("topright", 
       legend = c("Liveness 0 (Brown Dots)", "Liveness 1 (Purple Dots)", "Regression Line (Liveness 0)"
                  , "Regression Line (Liveness 1)"), 
       col = c("brown", "purple", "brown", "purple"),  
       lty = c(0, 0, 1, 1),  
       pch = c(1, 1, NA, NA)  
)
Model11 <- lm(formula = initData2.4$shazam ~ (initData2.4$valence*factor(initData2.4$liveness)))
summary(Model11)
# Plotting shazam vs valence by liveness
plot(initData2.4$valence[initData2.4$liveness == 0],
     initData2.4$shazam[initData2.4$liveness == 0],
     xlab = "valence",
     ylab = "shazam",
     main = "Shazam VS Valence By Liveness categories",
     col = ifelse(initData2.4$liveness == 0, "brown", "purple"))
# Add regression lines
abline(a = 7.0886, b = -3.3749, col = "brown")
abline(a = 7.0886 - 0.9365, b = -3.3749 + 0.6095, col = "purple")
# Create legend
legend("topright",
       legend = c("Liveness 0 (Brown Dots)", "Liveness 1 (Purple Dots)", "No Liveness (Purple Dots)", "Regression Lines"),
       col = c("brown", "purple", "purple", "brown"),
       lty = c(0, 0, 0, 1),
       pch = c(1, 1, 1, NA))



Model12 <- lm(formula = initData2.4$shazam ~ (initData2.4$tempo * factor(initData2.4$liveness)))
summary(Model12)
# Plotting shazam vs tempo by liveness
plot(initData2.4$tempo[initData2.4$liveness == 0], initData2.4$shazam[initData2.4$liveness == 0],
     xlab = "tempo", ylab = "shazam", main = "Shazam VS Tempo By Liveness categories",
     col = ifelse(initData2.4$liveness == 0, "brown","orange" ))
# Add regression lines
abline(a = 7.6440739, b = -0.0184294, col = "brown")
abline(a = 7.6440739 - 0.8150347, b = -0.0184294 + 0.0005343, col = "orange")
# Create legend
legend("topright",
       legend = c("Liveness 0 (Brown Dots)", "Liveness 1 (Orange Dots)", "No Liveness (Brown Dots)", "Regression Lines"),
       col = c("brown", "orange", "brown", "orange"),
       lty = c(0, 0, 0, 1),
       pch = c(1, 1, 1, NA))


#-----------------------3.1-------------------------------
# הוספת עמודות לדאטה המכילות את המשתנים הרלוונטיים
dataset3.1 <- initData2.4 
lm_model3.1 <- lm(shazam ~   youtube.views..m + loudness + speechiness + acousticness + valence+ tempo+
                  mode+gender+liveness+
                  speechiness*mode + valence:mode + 
                   valence*gender + tempo*gender+
                   speechiness*liveness, data = dataset3.1)
summary(lm_model3.1)

# קבלת ערכי AIC ו-BIC
AIC_value <- AIC(lm_model3.1)
BIC_value <- BIC(lm_model3.1)

#-----------------stepwise regression--------------
#------backward
summary(lm_model3.1)
backwardmod <- step(lm_model3.1, direction='backward', scope=~1)
summary(backwardmod)
AIC(backwardmod)
BIC(backwardmod)

#------forward
emptyMod<-lm(shazam ~ 1,data=dataset3.1)
summary(emptyMod)
forwardmod <- step(emptyMod, direction='forward', scope= ~   youtube.views..m + loudness + speechiness +
                     acousticness + valence+ tempo+
                     mode+gender+liveness+
                     speechiness*mode + valence:mode + 
                     valence*gender + tempo*gender+
                     speechiness*liveness , data = dataset3.1)
summary(forwardmod)
AIC(forwardmod)
BIC(forwardmod)

#=-------stepwise

stepwisemod <- step(emptyMod, direction='both', scope= ~  youtube.views..m + loudness + speechiness + acousticness +
                      valence+ tempo+
                      mode+gender+liveness+
                      speechiness*mode + valence:mode + 
                      valence*gender + tempo*gender+
                      speechiness*liveness)
summary(stepwisemod)
AIC(stepwisemod)
BIC(stepwisemod)

#-----------------------3.2-------------------------
dataset3.2 <- dataset3.1 

Model_3.2<-lm(shazam ~ youtube.views..m + loudness + factor(mode) + valence ,data=dataset3.2)
dataset3.2$fitted<-fitted(Model_3.2) # predicted values
dataset3.2$residuals<-residuals(Model_3.2) # residuals
s.e_res <- sqrt(var(dataset3.2$residuals))
dataset3.2$stan_residuals<-(residuals(Model_3.2)/s.e_res)

#1.Linearity assumption test


# 2. Equality of variance test - we will examine the relationship between the prediction model and the standardized error
plot_data <- data.frame(
  Fitted_Values = dataset3.2$fitted,
  Standardized_Residuals = dataset3.2$stan_residuals
)
# Scatter diagram
ggplot(plot_data, aes(x = Fitted_Values, y = Standardized_Residuals)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +  # הוספת קו נוסף לצורך השוואה
  labs(title = "Scatter Plot of Normalized error vs Predicted Value",
       x = "Predicted Value",
       y = "Normalized error") +
  theme_minimal()




#3. 
# Create a QQ plot with custom point and line colors
qqnorm(dataset3.2$stan_residuals, col = "#e74c3c", main = "QQ Plot of Normalized Residuals",
       xlab = "Theoretical Quantiles", ylab = "Sample Quantiles")
# Add a line through the quantiles
abline(a=0, b=1)



# Plotting Histogram of Standardized Residuals as Density
hist(dataset3.2$stan_residuals, breaks = 30, main = "Histogram of normalized error",
     xlab = "Normalized error", col = "skyblue", freq = FALSE)

# Adding a density curve that matches the histogram
lines(density(dataset3.2$stan_residuals), col = "red", lwd = 2)



#-------------------3.3--------------------------
#ks test for normal distribution
ks.test(x= dataset3.2$stan_residuals,y="pnorm",alternative = "two.sided", exact = NULL)

#SW test for normal distribution
shapiro.test(dataset3.2$stan_residuals)

##linearity check : Chow-test
sctest(Model_3.2,type="chow") ## get pvalue











