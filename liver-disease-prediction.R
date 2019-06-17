#This is the R code for the prediction of liver disease using the XGBoost algorithm.

#Loadin required libraries
library(tidyverse)
library(caret)  
library(xgboost)
library(methods)

#Reading data file stored in the "data" folder of the project LiverDiseasePrediction
data <- read.csv('data/indian_liver_patient.csv')
head(data)
summary(data)
#Exploring the structure of data.
#We see 583 observations of 11 variables.
str(data)   #glimpse(data)
#column names
names(data) 

#Replacing NAs in Albumin_and_Globulin_Ratio by it's mean value i.e. 0.9470639
data$Albumin_and_Globulin_Ratio[is.na(data$Albumin_and_Globulin_Ratio)] <- mean(data$Albumin_and_Globulin_Ratio, na.rm = TRUE)

# Converting strings to integer for variable Gender: Female : 1  and  Male : 2
str2int <- function(df) {
  strings=sort(unique(df))
  numbers=1:length(strings)
  names(numbers)=strings
  return(numbers[df])
}
data$Gender <- str2int(data$Gender)

#correlation between the features 
tmp <- cor(data)
tmp[!lower.tri(tmp)] <- 0
data.new <- data[,!apply(tmp,2,function(x) any(x > 0.8))]
data = data.new

#The feauture 'Dataset' tells us if the person has a liver disease or not.
#Let's change the values: 0 : liver disease, 1: no liver disease.
data$Dataset <- data$Dataset - 1

#Now let's create train and test sets. The train set will be 75% of the original dataset and test set will be 25%
sample_size <- floor(0.75 * nrow(data))
set.seed(123)
train_ind <- sample(seq_len(nrow(data)), size = sample_size)  #indexes of train set observations
train <- data[train_ind, ]      # train set : 437 observations
test <- data[-train_ind, ]      # test set : 146 observations

#labels: if the person has liver disease or not : 0 (disease), 1 (No disease)
train_label <- as.numeric(train$Dataset)   
test_label <- as.numeric(test$Dataset)

#converting train and test sets to Formal class dgcMatrix  (sparse numeric matrices )
train <- as(as.matrix(train[ , -which(names(train) %in% c("Dataset"))]), "dgCMatrix")
test <- as(as.matrix(test[ , -which(names(test) %in% c("Dataset"))]), "dgCMatrix")

#creating xgb.DMatrix for train and test data: External pointers of class 'xgb.DMatrix'
dtrain <- xgb.DMatrix(data = train, label=train_label)
dtest <- xgb.DMatrix(data = test, label=test_label)    
watchlist <- list(train=dtrain, test=dtest)


#XGBoost Model

# We use xgb.train() function. It is an advance function to train XGBoost model
#Parameters used:
# max.depth: maximum depth of tree
#eta: controls learning rate (lower eta implies more robust but slow model)
# nthread: number of threads
# nrounds: lower eta implies larger values for nrounds
# early_stopping_rounds: If set to an integer k, training with a validation set will stop if the performance doesn't improve for k rounds. 

xgbModel <- xgb.train(data = dtrain, max.depth = 100, eta = 0.001, 
                      nthread = 2,  nround = 10000, 
                      watchlist=watchlist, objective = "binary:logistic", early_stopping_rounds = 500)

#creating Formal class dgcMatrix  (sparse numeric matrix)
fulldata <- as(as.matrix(data[ , -which(names(data) %in% c("Dataset"))]), "dgCMatrix")
test_pred <- predict(xgbModel, newdata = fulldata)

# Confusion Matrix
confusionMatrix(as.factor(round(test_pred)), as.factor(data$Dataset))

#Analysis of what feautres were the most important to our model when it made the prediction of whether a patient has liver disease or not. 
xgb.importance(colnames(fulldata), model = xgbModel)

