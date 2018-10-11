# sys6018-competition-blogger-characteristics
Data Mining Kaggle Competition

# Team Mates -
* Boda Ye (by8jj) - Data Exploration, Cleaning, TF-IDF, Sentiment Analysis
* Elena Gillis (emg3sc) - Data Exploration, Cleaning, TF-IDF
* Sri Vaishnavi Vemulapalli (sv2fr) - Data Exploration, Cleaning, TF-IDF

# Main Approaches
* We tried Sentiment Analysis on the text data but did not get a very good score (~11.0 and ~9.0). Ideally the data should have been labelled by a human, whereas in our case we got the sentiment using the NLTK package, so it was less accurate.
* For TF-IDF we tried removing words absent in 90% of the documents and then 70%. The model with 70% gave better prediction accuracy.
* Finally we performed 10-fold CV repeated 3 times and got MAE of 5.135081

# Description of files

## process_data_non_text.ipynb
- there are no missing or null values
- convert all text fields to lowercase
- strip white spaces for categorical variables
- convert categorical variables to factors
- output data to file

## process_data_text.ipynb
- combine reviews per user
- remove punctuation
- remove numbers
- convert to words
- remove stop words
- lemmatize words
- remove non-english words
- remove words less than one character in length
- get the word count
- output to file
- test_processed_text.csv - output from 
- train_processed_text.csv

## tfidf_70.R
- create corpus on train set
- tf-idf on train set
- retain 70% to reduce sparcity
- train simple linear regression model
- create corpus on test set
- tf-idf on test set
- retain 70% to reduce sparcity
- predict on test set

# tfidf.R
- same as tfidf_70.R but with removing words absent in 90% of the documents

# review_nlp.py
- data exploration
- sentiment analysis
