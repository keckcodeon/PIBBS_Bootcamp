setwd("~/Desktop/codeon/ml101") # set working directory
install.packages("randomForest", dependencies = TRUE) 
install.packages("caret", dependencies = TRUE) 
install.packages("e1071", dependencies = TRUE) # install packages as needed
library(reshape2)
library(plyr)
library(dplyr)
#library(ggplot2)
library(randomForest)
library(caret)
library(e1071)

# import data
her2_dataset = read.delim("her2_data_bbx138_Supp.txt", sep = "\t", header=TRUE)
# Since we are only interested in prediction on her2_status, remove columns we don't need. 
View(her2_dataset)
her2_df <- subset(her2_dataset, select = -c(er_status, pr_status))
View(her2_df)
barplot(table(her2_df$her2_status))
dev.off()

# seeding, for reproducibility. Any seed will work
set.seed(101) 
# set training and test sets (using base R)
df_sampled <- sample(nrow(her2_df), nrow(her2_df) * 0.75 ) # 75% of data will be used for training. Pareto principle
her2_train <- her2_df[df_sampled, ]
her2_test <- her2_df[-df_sampled, ]
nrow(her2_train) 

# train RF model
RF_model <- randomForest(her2_status~ ., data=her2_train, importance=TRUE, ntree=2000)
RF_model
plot(RF_model)

# predict on unseen data: "validation" 
pred_RF_model <- predict(RF_model, her2_test)
RF_conf_matrix <- confusionMatrix(pred_RF_model, her2_test$her2_status) # create confusion matrix to check accuracy
RF_conf_matrix
# Look at the variable importance/feature ranking
varImpPlot(RF_model)

## Looks like some expression level of select genes is determinant of HER2 status!! 





### Deep Learning

setwd("~/Desktop/codeon/deep_learning")
#' Train a simple deep CNN on the CIFAR10 small images dataset.
# adapted from: https://keras.rstudio.com/ (consider having this in your browser during exercise)
install.packages("keras")
library(keras)
install_keras() # this step loads all the datasets and enviroment settings

# Processing MNIST data: loads and create inputs for training and testing  
mnist <- dataset_mnist() # loads data
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

# converts the 3d arrays into flat matrices: with reshape package
x_train <- array_reshape(x_train, c(nrow(x_train), 784))
x_test <- array_reshape(x_test, c(nrow(x_test), 784))
# rescale greyscale from integers to floats 
x_train <- x_train / 255
x_test <- x_test / 255

# encodes vectors into binary class matrices 
y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)

# create a sequenctial model and add layers
model <- keras_model_sequential() 
model %>%  
  layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 10, activation = 'softmax')

# look at the layers and parameters/features 

# create the NN model; add 
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)

# train the CNN 
history <- model %>% fit(
  x_train, y_train, 
  epochs = 30, batch_size = 128, 
  validation_split = 0.2
)

# plot the learning "trajectory" 
plot(history)

# evaluate the model performance on out-of-the-box test set
model %>% evaluate(x_test, y_test)

# Use model to predict 
model %>% predict_classes(x_test)
