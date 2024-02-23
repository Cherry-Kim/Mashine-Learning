import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_auc_score
from sklearn.metrics import roc_curve, auc
import matplotlib.pyplot as plt
import sys
import matplotlib
matplotlib.use('Agg')  # Use Agg backend
import matplotlib.pyplot as plt

tpot_data = pd.read_csv('tpot_input.csv')
features = tpot_data.drop(['reg','class'], axis=1)

training_features, testing_features, training_target, testing_target = \
            train_test_split(features, tpot_data['class'].values, random_state=None)


exported_pipeline = LogisticRegression(C=0.0001, dual=False, penalty="l2")

exported_pipeline.fit(training_features, training_target)
#results = exported_pipeline.predict(testing_features)


importance_df = pd.DataFrame({
        'Feature': features.columns,
            'Importance': exported_pipeline.coef_[0]
            })

importance_df = importance_df.sort_values(by='Importance', ascending=False)
#print(importance_df)
importance_df.to_csv("Feature_Importance.csv")


#Calculate the AUC using the predicted probabilities and the actual labels of the test set
# Predict probabilities for the test set
predicted_probabilities = exported_pipeline.predict_proba(testing_features)

# Extract probabilities of positive class
predicted_probabilities_positive_class = predicted_probabilities[:, 1]

# Calculate ROC curve
fpr, tpr, thresholds = roc_curve(testing_target, predicted_probabilities_positive_class)

# Calculate AUC
roc_auc_score = auc(fpr, tpr)  # Change variable name to avoid conflict

# Plot ROC curve
plt.figure()
plt.plot(fpr, tpr, color='darkorange', lw=2, label='AUC: %0.2f)' % roc_auc_score)
plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.legend(loc="lower right")
plt.savefig('roc_curve.png')

