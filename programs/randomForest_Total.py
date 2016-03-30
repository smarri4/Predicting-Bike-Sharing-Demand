import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn import preprocessing
from sklearn.cross_validation import train_test_split
from sklearn.svm import SVC # "Support Vector Classifier"
from sklearn.svm import SVR #"Support Vector Regression"
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression

from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report

from sklearn.metrics import accuracy_score
from sklearn.cross_validation import cross_val_score
import warnings

def processData():
    data = pd.read_csv('/home/avp/academics/sem1/412/project/notebook/hour.csv')
    total_count_column=data['cnt']
    sortedData=data.sort(['cnt'],ascending=True)
    sortedData.cnt.cumsum()
    indices=np.arange(1,17380,1)
    sortedData['index']=indices
    indexedData=sortedData.set_index('index')
    labels=["{0}-{1}".format(i,i+1000) for i in range(0,17340,1000)]
    indexedData['group']=pd.cut(indexedData.index,range(0,19000,1000),right=False, labels=labels)
    target=indexedData.group
    numerical_features=data[['season','yr','mnth','weekday','holiday','workingday','temp','hum','windspeed']]
    Xval,y=numerical_features.values,target
    X_train, X_test, y_train, y_test = train_test_split(Xval, y, test_size=0.20,
                                                        random_state=0)
	
    rf=RandomForestClassifier(n_estimators=100)
    scores=cross_val_score(rf,Xval,target,cv=10,n_jobs=4,scoring='precision')
    print(scores.min())
    print(scores.max())
    print(scores.mean())
    y_true, y_pred = y_test, clf.predict(X_test)
    print(classification_report(y_true, y_pred))
    print()

def main():
    processData()

if __name__== "__main__" :
    main()
