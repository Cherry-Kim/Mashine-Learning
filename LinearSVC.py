import numpy as np
import pandas as pd
from tpot import TPOTClassifier
from sklearn.feature_selection import RFE
from sklearn.linear_model import LogisticRegression
from IPython.display import display
from csv import writer
from sklearn.model_selection import train_test_split
from sklearn.svm import LinearSVC
from sklearn.impute import SimpleImputer
from sklearn.metrics import plot_roc_curve
import matplotlib.pyplot as plt
import sys

def STEP1_LinearSVC():
    tpot_data = pd.read_csv("ccle48_TFactivityProfile2.csv")   
    tpot_data = tpot_data.set_index('Group.1')
    #print(tpot_data.head(5))
    #            class     gene1
#Group.1                                ...                              
#sample1     1  0.523747 

    features = tpot_data.drop('class', axis=1)
    training_features, testing_features, training_target, testing_target = train_test_split(features, tpot_data['class'], random_state=0)

    training_features = pd.DataFrame(training_features, columns = training_features.columns)
    testing_features = pd.DataFrame(testing_features, columns=testing_features.columns)

    imputer = SimpleImputer(strategy="median")
    imputer.fit(training_features)
    training_features = imputer.transform(training_features)
    testing_features = imputer.transform(testing_features)

    #Feature extraction
    exported_pipeline = LinearSVC(C=1.0, dual=False, loss= "squared_hinge", penalty="l2", tol=0.001)
    #exported_pipeline = LinearSVC(C=1.0, dual=True, loss="hinge", penalty="l2", tol=0.0001)
    fit = exported_pipeline.fit(training_features, training_target)
    ##plot_roc_curve(exported_pipeline, testing_features, testing_target)

    feat_dict= {}
    for col,val in sorted(zip(features.columns, exported_pipeline.coef_[0]),key=lambda x:x[1],reverse=True):
        feat_dict[col]=val
    feat_df = pd.DataFrame({'Feature':feat_dict.keys(),'Importance':feat_dict.values(),})
    print(feat_df)
    feat_df.to_csv("Feature_Importance_LinearSVC.csv")

def main():
    STEP1_LinearSVC()
main()
