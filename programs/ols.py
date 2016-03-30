from __future__ import print_function

import IPython as ip
import numpy as np
import scipy as scp
import matplotlib as plt
import sklearn as skl
import pandas as pd
import math
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor
from fig_code import visualize_tree, plot_tree_interactive
from sklearn.metrics import accuracy_score
from sklearn.cross_validation import train_test_split
from pandas.stats.api import ols
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

df=pd.read_csv('hour.csv')
dataframe=df
dataframe=dataframe.drop(dataframe.columns[[0,3]], axis=1)
#dataframe.head(2)


dataframe['log_count']=dataframe['cnt'].apply(lambda x: math.log(x+1.0))
dataframe=dataframe.set_index('dteday')
#dataframe.head(2)

dataframe['winter']=dataframe.season.apply(lambda x: 1 if x==1 else 0)
dataframe['spring']=dataframe.season.apply(lambda x: 1 if x==2 else 0)
dataframe['summer']=dataframe.season.apply(lambda x: 1 if x==3 else 0)
dataframe['fall']=dataframe.season.apply(lambda x: 1 if x==4 else 0)
#dataframe.head(2)

dataframe['logcasual']=dataframe['casual'].apply(lambda x: math.log(x+1.0))
dataframe['log_registered']=dataframe['registered'].apply(lambda x: math.log(x+1.0))
dataframe['winter_weather']=dataframe.winter*dataframe.weathersit
dataframe['spring_weather']=dataframe.spring*dataframe.weathersit
dataframe['summer_weather']=dataframe.summer*dataframe.weathersit
dataframe['fall_weather']=dataframe.fall*dataframe.weathersit
dataframe['winter_temp']=dataframe.winter*dataframe.atemp
dataframe['sprint_temp']=dataframe.spring*dataframe.atemp
dataframe['summer_temp']=dataframe.summer*dataframe.atemp
dataframe['fall_temp']=dataframe.fall*dataframe.atemp
dataframe.head(2)

numerical_features=dataframe[['season','mnth','weekday','holiday', 'workingday','temp','hum','windspeed',
                                   'weathersit', 'atemp','winter','spring','summer','fall',
                                                                  'winter_weather','spring_weather','summer_weather','fall_weather','winter_temp','sprint_temp','summer_temp','fall_temp', 'hr']]

train, test = train_test_split(dataframe, test_size=0.15, random_state=0)
print (dataframe.shape)
print (train.shape)
print (test.shape)

seasons=['spring','summer','winter','fall']
seasonweather=['winter_weather','spring_weather','summer_weather','fall_weather']
seasontemp=['winter_temp','sprint_temp','summer_temp','fall_temp']
features=seasons+seasonweather+seasontemp+['holiday','weekday', 'workingday', 'weathersit','temp',
                                              'atemp','hum','windspeed']
print (len(features))
print (features)

hour=0
casualCoeff=[]                                      # coefficients for the log of no. of casual users
registeredCoeff=[]                                  # same for registered users
totalCoeff=[]

# Regression model
def calcCoef(hour,label):                                 # Will calculate coefficients for each bin
    return ols(y=train[(train.hr==hour)][label], 
            x=train[(train.hr==hour)][features]).beta

    while hour<24:
        casualCoeff.append(calcCoef(hour,'casual'))
        registeredCoeff.append(calcCoef(hour,'registered'))
        totalCoeff.append(calcCoef(hour, 'cnt'))
        hour+=1

def calcCount(coef, data):
    res=coef['intercept']
    for i in features:
        res += coef[i]*data[i]
    return round(res)

#test=test.reset_index()
test['regPredict']=test.apply(lambda x: calcCount(registeredCoeff[x['hr']],x[features]) ,axis=1)
test['casPredict']=test.apply(lambda x: calcCount(casualCoeff[x['hr']],x[features]) ,axis=1)
test['totPredict']=test.apply(lambda x: calcCount(totalCoeff[x['hr']],x[features]) ,axis=1)
print (test.columns)

results=test[['casual', 'casPredict', 'registered', 'regPredict', 'cnt', 'totPredict']]
results.head()
