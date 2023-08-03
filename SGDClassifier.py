from sklearn.linear_model import SGDClassifier
import matplotlib.pyplot as plt
import time
from sklearn.model_selection import GridSearchCV
from sklearn.preprocessing import Binarizer
from sklearn.pipeline import make_pipeline
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import pandas as pd
import numpy as np
import sys
from skrebate import ReliefF
from sklearn.preprocessing import StandardScaler
#https://michael-fuchs-python.netlify.app/2019/11/11/introduction-to-sgd-classifier/

# Load the data from a CSV file
data = pd.read_csv('a.csv')
#       Group.1  class      geneq  ...     gene#     gene      gene
#0   sample1      3  0.523747  ... -0.522639  8.275252  2.620917

# Separate the features and target variable
x = data.drop(['Group.1','class'], axis=1)
y = data['class']

# Split the dataset into training and test sets
trainX, testX, trainY, testY = train_test_split(x, y)
#trainX, testX, trainY, testY = train_test_split(x, y, test_size = 0.2)
##X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.75, test_size=0.25)

#"Feature Scaling with Scikit-Learn”
scaler = StandardScaler()
scaler.fit(trainX)
trainX = scaler.transform(trainX)
testX = scaler.transform(testX)

# Create a pipeline that first applies binarization and then fits the classifier
clf = SGDClassifier(alpha=0.001, eta0=0.01, fit_intercept=True, l1_ratio=0.25, learning_rate='constant', loss='squared_hinge', penalty='elasticnet', power_t=0.1)

# Train the classifier on the data
clf.fit(trainX, trainY)

y_pred = clf.predict(testX)
print('Accuracy: {:.2f}'.format(accuracy_score(testY, y_pred)))

feature_importances = clf.coef_[0]
feature_names = x.columns

# Create a DataFrame to store the feature importances with their names
feature_importance_df = pd.DataFrame({'Feature': feature_names, 'Importance': feature_importances})

# Sort the features by importance in descending order
feature_importance_df = feature_importance_df.sort_values(by='Importance', ascending=False)
print(feature_importance_df)
feature_importance_df.to_csv("Feature_Importance_SGDClassifier.csv")

