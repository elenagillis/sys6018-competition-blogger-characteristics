import pandas as pd
import matplotlib.pyplot as plt




data=pd.read_csv('train.csv')
# matplotlib histogram
plt.hist(data['age'], color = 'blue', edgecolor = 'black',bins = int(180/5))
plt.show()


data['topic'].value_counts().plot(kind='bar')

data['sign'].value_counts().plot(kind='bar')

def sent_analysis(train_x):
    from nltk.sentiment.vader import SentimentIntensityAnalyzer
    sid = SentimentIntensityAnalyzer()
    neg,neu,pos,compound=[],[],[],[]
    i=0
    for sentence in train_x['text']:
        print(i)
        ss = sid.polarity_scores(str(sentence))
        neg.append(ss['neg'])
        neu.append(ss['neu'])
        pos.append(ss['pos'])
        compound.append(ss['compound'])
        i+=1


    return pd.DataFrame({'neg':neg,'neu':neu,'pos':pos,'compound':compound})


