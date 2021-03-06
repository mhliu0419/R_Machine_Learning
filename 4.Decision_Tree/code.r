# Get the Data

## Call the ISLR library and check the head of College (a built-in data frame with ISLR, use data() to check this.) Then reassign College to a dataframe called df
library(ISLR)
df <- College
head(df)


# EDA

## Create a scatterplot of Grad.Rate versus Room.Board, colored by the Private column.

library(ggplot2)

ggplot(data = df, aes(x = Room.Board, y = Grad.Rate)) + geom_point(aes(color = Private))

## Create a histogram of full time undergrad students, color by Private.


ggplot(data = df, aes(x = F.Undergrad)) + geom_histogram(color = 'black', aes(fill = Private))

## Create a histogram of Grad.Rate colored by Private. You should see something odd here.


ggplot(data = df, aes(x = Grad.Rate)) + geom_histogram(color = 'black', aes(fill = Private), bins = 50)


## What college had a Graduation Rate of above 100% ?
library(dplyr)

filter(df,df[,'Grad.Rate'] > 100)
subset(df, Grad.Rate > 100)

## Change that college's grad rate to 100%

df[row.names(filter(df,df[,'Grad.Rate'] > 100)),'Grad.Rate'] <- 100


# Train Test Split

## Split your data into training and testing sets 70/30. Use the caTools library to do this.

library(caTools)
set.seed(101)

sample <- sample.split(df, SplitRatio = 0.7)
train <- subset(df, sample == TRUE)
test <- subset(df, sample == FALSE)



#Decision Tree

##Use the rpart library to build a decision tree to predict whether or not a school is Private. Remember to only build your tree off the training data.

library(rpart)

tree <- rpart(Private ~ ., data = train)

##Use predict() to predict the Private label on the test data.

tree.preds <- predict(tree, test)

##Check the Head of the predicted values. You should notice that you actually have two columns with the probabilities.

head(tree.preds)

##Turn these two columns into one column to match the original Yes/No Label for a Private column.

typeof(tree.preds)
tree.preds <- as.data.frame(tree.preds)

classifer <- function(x){
  if (x >= 0.5){
    return('Yes')
  }
  else{
    return('No')
  }
}

tree.preds$Private <- sapply(tree.preds$Yes, classifer)

head(tree.preds)

##Now use table() to create a confusion matrix of your tree model.

table(test$Private, tree.preds$Private)


##Use the rpart.plot library and the prp() function to plot out your tree model.

library(rpart.plot)

prp(tree)


#Random Forest

library(randomForest)

##Now use randomForest() to build out a model to predict Private class. Add importance=TRUE as a parameter in the model. (Use help(randomForest) to find out what this does.

rf.model <- randomForest(Private ~ ., data = train, importance = T)

##What was your model's confusion matrix on its own training set?

rf.model$confusion

##Grab the feature importance.

rf.model$importance



# Predictions

##Now use your random forest model to predict on your test set!

p <- predict(rf.model, test)

table(p, test$Private)

##MeanDecreaseAccuracy
##MeanDecreaseGini


##It should have performed better than just a single tree, how much better depends on whether you are emasuring recall, precision, or accuracy as the most important measure of the model.






























































