# LiverDiseasePrediction
Using XGBoost (eXtreme Gradient Boosting) algorithm to predict liver disease risk in patients. 

## Context
Patients with Liver disease have been continuously increasing because of excessive consumption of alcohol, inhale of harmful gases, intake of contaminated food, pickles and drugs. This dataset was used to evaluate prediction algorithms in an effort to reduce burden on doctors. 

## Content
This data set contains 416 liver patient records and 167 non liver patient records collected from North East of Andhra Pradesh, India. The "Dataset" column is a class label used to divide groups into liver patient (liver disease) or not (no disease). This data set contains 441 male patient records and 142 female patient records.

Any patient whose age exceeded 89 is listed as being of age "90".

Columns:

    Age of the patient
    Gender of the patient
    Total Bilirubin
    Direct Bilirubin
    Alkaline Phosphotase
    Alamine Aminotransferase
    Aspartate Aminotransferase
    Total Protiens
    Albumin
    Albumin and Globulin Ratio
    Dataset: field used to split the data into two sets (patient with liver disease, or no disease)

Acknowledgements

This dataset was uploades originally on the UCI ML Repository and is downloaded from https://www.kaggle.com/uciml/indian-liver-patient-records.

We have used XGBoost library for training the prediction model. 
Official documentation can be found here: https://github.com/dmlc/xgboost
