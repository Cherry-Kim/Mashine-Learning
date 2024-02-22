import numpy as np
import pandas as pd
from tpot import TPOTClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import log_loss, make_scorer
import sys

tpot_data = pd.read_csv("sig_class.csv")  #[115 rows x 402 columns]
#                                  Group.1  ...  chr8.9906276.9906912
#0                      sample1_Tumor_T  ...             12.545256

features = tpot_data.drop(['Group.1','class'], axis=1)
labels = np.unique(tpot_data['class'])  #[0 1]
print(labels)
X_train, X_test, y_train, y_test = train_test_split(features, tpot_data['class'])
print(X_train.shape, X_test.shape, y_train.shape, y_test.shape)

tpot = TPOTClassifier(generations=20, population_size=20, verbosity=2,cv=3, n_jobs=4)
tpot.fit(X_train, y_train)
print(tpot.score(X_test, y_test))
