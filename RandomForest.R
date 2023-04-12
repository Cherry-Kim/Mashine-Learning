RFE <- function(){
        #https://towardsdatascience.com/effective-feature-selection-recursive-feature-elimination-using-r-148ff998e4f7
        ### STEP1. Data Preparation ###
        # install.packages("devtools")
        #devtools::install_github("debruine/faux")
        #install.packages("DataExplorer")
        library(dplyr)
        library(faux)
        library(DataExplorer)
        library(caret)
        library(randomForest)

        # Import the dataset
        data <- read.csv('Top100_input.csv', header = TRUE)
        head(data[1:4])
        #   Group.1 class feature1 geature2
        #1 sample1     1           20.175468                 17.53386  
        #11 sample2     0           20.175468                 17.53386 
        
        # Exploratory Data Analysis 
        plot_intro(data)
        plot_bar(data)
        plot_correlation(data)

        ### STEP2. Feature Selection ###
        # Define the control using a random forest selection function
        control <- rfeControl(functions = rfFuncs, # random forest
                      method = "repeatedcv", # repeated cv
                      repeats = 100, # number of repeats
                      number = 3 # number of folds)
        # Features
        x <- data %>%
          select(-Group.1, -class) %>%
          as.data.frame()
        # Target variable
        y <- data$class

        # Training: 80%; Test: 20%
        set.seed(2023)
        inTrain <- createDataPartition(y, p = .80, list = FALSE)[,1]    

        x_train <- x[ inTrain, ]        
        x_test  <- x[-inTrain, ]        
        y_train <- y[ inTrain]  
        y_test  <- y[-inTrain]  

        # Run RFE
        result_rfe1 <- rfe(x = x_train, y = y_train,
                   sizes = c(1:100),
                   rfeControl = control)
        write.csv(result_rfe1$results, file = "selected_features.csv", row.names = FALSE)

        # Print the selected features
        predictors(result_rfe1)
        # Print the results visually
        ggplot(data = result_rfe1, metric = "RMSE") 
            + theme_bw()
            + theme(axis.title.y = element_text(size = 30), axis.title.x = element_text(size = 30)) + theme(axis.text.y = element_text(face="bold", color="black", size=30), axis.text.x = element_text(face="bold", color="black", size=30))+ xlab("Features")

        #we will visually examine variable importance for the selected features and see which features are more important for predicting the target variable
        importance <- data.frame(feature = row.names(varImp(result_rfe1))[1:100],
                           importance = varImp(result_rfe1)[1:100, 1])
        write.csv(importance, file = "importance.csv", row.names = FALSE, quote=F)

        varimp_data <- data.frame(feature = row.names(varImp(result_rfe1))[1:18],
                          importance = varImp(result_rfe1)[1:18, 1])
        ggplot(data = varimp_data,
         aes(x = reorder(feature, -importance), y = importance, fill = feature)) +
           geom_bar(stat="identity") + labs(x = "Features", y = "Variable Importance") 
           +  geom_text(aes(label = round(importance, 2)), vjust=1.6, color="black", size=10)         +  theme_bw() +theme(legend.position = "none")+ ylim(0,7.5)+ theme(axis.title.y = element_text(size = 30)) + theme(axis.text.y = element_text(face="bold", color="black", size=30), axis.text.x = element_text(face="bold", color="black", angle=45, vjust=.8, hjust=.8, size=16))+ xlab(NULL)

        saveRDS(result_rfe1, "result_rfe1.rds")
        #loaded_data <- readRDS("result_rfe1.rds")
} 
