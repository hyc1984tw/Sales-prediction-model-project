# Code you have previously used to load data
import pandas as pd
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor

# Path of the file to read
sales_file_path = '/dkl_product_sales_data.csv'

sales_data = pd.read_csv(sales_file_path)
# Create target object and call it y
print(sales_data.head())
y = sales_data.sales_n
# Create X
features = ['temp_n', 'rainfall_n', 'bb_trend_n1', 'nba_trend_n1', 'hbl_trend_n1', 'temp_n1', 'rainfall_n1', 'bb_trend_n2', 'nba_trend_n2', 'hbl_trend_n2', 'temp_n2', 'rainfall_n2']
X = sales_data[features]


# Split into validation and training data
train_X, val_X, train_y, val_y = train_test_split(X, y, random_state=1)

from sklearn.ensemble import RandomForestClassifier 

# Define the model. Set random_state to 1
rf_model = RandomForestClassifier(n_estimators = 50)  

# fit your model
rf_model.fit(train_X, train_y)

rf_y_pred = rf_model.predict(val_X) 

# metrics are used to find accuracy or error 
from sklearn import metrics   
print() 
  
# using metrics module for accuracy calculation 
print("ACCURACY OF THE MODEL: ", metrics.accuracy_score(val_y, rf_y_pred)) 

print(val_y)
print(rf_y_pred)

# Check model efficiency

from sklearn.metrics import confusion_matrix

def confusion(classifier, X_test, y_test):
    y_pred  = classifier.predict(X_test)
    return confusion_matrix(y_test, y_pred).ravel()

def show(tn,fp,fn,tp):
    print("TN:" + str(tn) + " FP:" + str(fp) + " FN:" + str(fn) + " TP:" + str(tp) + 
          " FNR=" + str(fn/(fn+tp)) + " FPR=" + str(fp/(fp+tn)))
          
show(*confusion(RandomForestClassifier(random_state=0, n_jobs=-1, n_estimators=10).fit(train_X, train_y),val_X,val_y))

show(*confusion(RandomForestClassifier(random_state=0, n_jobs=-1, n_estimators=10, class_weight="balanced").fit(train_X, train_y),val_X,val_y))

show(*confusion(RandomForestClassifier(random_state=0, n_jobs=-1, n_estimators=10, class_weight="balanced_subsample").fit(train_X, train_y),val_X,val_y))


#https://www.kaggle.com/christiantheilhave/class-imbalance-with-weighted-random-forest


