import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.cross_validation import train_test_split
from sklearn.svm import SVC # "Support Vector Classifier"
from sklearn.svm import SVR #"Support Vector Regression"
from sklearn.svm import NuSVR #"Support Vector Regression"
from sklearn import preprocessing
from sklearn.metrics import classification_report

from sklearn.kernel_ridge import KernelRidge
from sklearn.grid_search import GridSearchCV
from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report

from sklearn.metrics import accuracy_score
from sklearn.cross_validation import cross_val_score
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.ensemble import RandomForestClassifier
import warnings
from sklearn.cross_validation import ShuffleSplit
from sklearn.learning_curve import learning_curve
from sklearn import preprocessing

def readCSV():
    data = pd.read_csv('C:/PythonProgram/Machine Learning/BikeSharing/hour.csv')
    total_count_column=data['cnt']
    m=data.sort(['cnt'],ascending=True)
    m.cnt.cumsum()
    g=np.arange(1,17380,1)
    m['index']=g
    q=m.set_index('index')
    labels=["{0}-{1}".format(i,i+1000) for i in range(0,17340,1000)]
    q['group']=pd.cut(q.index,range(0,19000,1000),right=False, labels=labels)
    target=q.group
    numerical_features=data[['season','yr','mnth','weekday','holiday','workingday','temp','hum','windspeed']]
    Xval,y=numerical_features.values,target
    X_train, X_test, y_train, y_test = train_test_split(Xval, y, test_size=0.20,
                                                        random_state=0)
	
	rf=RandomForestClassifier(n_estimators=100)
	scores=cross_val_score(rf,Xval,target,cv=10,n_jobs=4,scoring='precision')
	print(scores.min())
	print(scores.max())
	print(scores.mean())
    # tuned_parameters = [{'kernel': ['rbf'], 'gamma': [1e-3, 1e-4],
                         # 'C': [1, 10, 100, 1000]},
                        # {'kernel': ['linear'], 'C': [1, 10, 100, 1000]}]
    # scores = ['precision', 'recall']
    # for score in scores:
        # print("# Tuning hyper-parameters for %s" % score)
        # print()
        # clf = GridSearchCV(SVC(C=1), tuned_parameters, cv=5, scoring=score)
        # clf.fit(X_train, y_train)
        # print("Best parameters set found on development set:")
        # print()
        # print(clf.best_estimator_)
        # print()
        # print("Grid scores on development set:")
        # print()
        # for params, mean_score, scores in clf.grid_scores_:
            # print("%0.3f (+/-%0.03f) for %r"% (mean_score, scores.std() / 2, params))
        # print()
        # print("Detailed classification report:")
        # print()
        # print("The model is trained on the full development set.")
        # print("The scores are computed on the full evaluation set.")
        # print()
        # y_true, y_pred = y_test, clf.predict(X_test)
        # print(classification_report(y_true, y_pred))
        # print()

def main():
    readCSV()

if __name__== "__main__" :
    main()
