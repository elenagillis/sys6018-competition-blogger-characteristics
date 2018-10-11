library(tm)
library(topicmodels)

# read in cleaned data
train <- read.csv('train_processed_text.csv', header = TRUE)
test <- read.csv('test_processed_text.csv', header = TRUE)

# rename for tm
names(train)[names(train) == 'userid'] <- 'doc_id'
names(test)[names(test) == 'userid'] <- 'doc_id'

# remove rows with zero word count in train
train_del <- train[train$word_count != 0, ]

# remove rows with less than 10 words in train
train_del <- train[train$word_count > 10, ]

# generage the corpus
corpus <- VCorpus(DataframeSource(rbind(train_del)))

# generate tf-idf
tfidf <- DocumentTermMatrix(corpus, control = list(weighting = weightTfIdf))

# remove words absent in 90% of the documents
tfidf.90 = removeSparseTerms(tfidf, 0.90)  # remove terms that are absent from at least 90% of documents (keep most terms)
tfidf.90

# parametric linear model
train_tfidf <- cbind(train_del, as.matrix(tfidf.90))
train_tfidf_model_data <- train_tfidf
train_tfidf_model_data$doc_id <- NULL
train_tfidf_model_data$text <- NULL
train_tfidf_model_data$word_count <- NULL

linear_model_basic <- lm(age ~ ., data = train_tfidf_model_data)

# predict on test set
test.corpus <- VCorpus(DataframeSource(test))
test.tfidf <- DocumentTermMatrix(test.corpus, control = list(weighting = weightTfIdf))
test.tfidf.90 = removeSparseTerms(test.tfidf, 0.90)
test.tfidf.90

test_tfidf <- cbind(test, as.matrix(test.tfidf.90))
test_tfidf$doc_id <- NULL
test_tfidf$text <- NULL
test_tfidf$word_count <- NULL

test_tfidf$`'actually',` <- 0
test_tfidf$`'always',` <- 0
test_tfidf$`'another',` <- 0
test_tfidf$`'anyway',` <- 0
test_tfidf$`'around',` <- 0
test_tfidf$`'away',` <- 0
test_tfidf$`'bad',` <- 0
test_tfidf$`'best',` <- 0
test_tfidf$`'better',` <- 0
test_tfidf$`'big',` <- 0
test_tfidf$`'blog',` <- 0
test_tfidf$`'came',` <- 0
test_tfidf$`'end',` <- 0
test_tfidf$`'enough',` <- 0
test_tfidf$`'ever',` <- 0
test_tfidf$`'every',` <- 0
test_tfidf$`'find',` <- 0
test_tfidf$`'fun',` <- 0
test_tfidf$`'getting',` <- 0
test_tfidf$`'girl',` <- 0
test_tfidf$`'give',` <- 0
test_tfidf$`'great',` <- 0
test_tfidf$`'guess',` <- 0
test_tfidf$`'guy',` <- 0
test_tfidf$`'home',` <- 0
test_tfidf$`'hope',` <- 0
test_tfidf$`'hour',` <- 0
test_tfidf$`'keep',` <- 0
test_tfidf$`'least',` <- 0
test_tfidf$`'left',` <- 0
test_tfidf$`'let',` <- 0
test_tfidf$`'long',` <- 0
test_tfidf$`'look',` <- 0
test_tfidf$`'lot',` <- 0
test_tfidf$`'made',` <- 0
test_tfidf$`'man',` <- 0
test_tfidf$`'many',` <- 0
test_tfidf$`'may',` <- 0
test_tfidf$`'maybe',` <- 0
test_tfidf$`'mean',` <- 0
test_tfidf$`'na',` <- 0
test_tfidf$`'next',` <- 0
test_tfidf$`'nice',` <- 0
test_tfidf$`'nothing',` <- 0
test_tfidf$`'oh',` <- 0
test_tfidf$`'old',` <- 0
test_tfidf$`'part',` <- 0
test_tfidf$`'person',` <- 0
test_tfidf$`'place',` <- 0
test_tfidf$`'pretty',` <- 0
test_tfidf$`'probably',` <- 0
test_tfidf$`'put',` <- 0
test_tfidf$`'read',` <- 0
test_tfidf$`'said',` <- 0
test_tfidf$`'school',` <- 0
test_tfidf$`'someone',` <- 0
test_tfidf$`'start',` <- 0
test_tfidf$`'stuff',` <- 0
test_tfidf$`'sure',` <- 0
test_tfidf$`'talk',` <- 0
test_tfidf$`'tell',` <- 0
test_tfidf$`'though',` <- 0
test_tfidf$`'two',` <- 0
test_tfidf$`'wanted',` <- 0
test_tfidf$`'week',` <- 0
test_tfidf$`'went',` <- 0
test_tfidf$`'whole',` <- 0
test_tfidf$`'world',` <- 0

age <- predict(linear_model_basic, newdata = test_tfidf)
age <- round(age)

predictions <- data.frame('user.id' <- test$doc_id, 'age' <- age)
colnames(predictions) <- c('user.id', 'age')

write.csv(predictions, file = 'predictions_2.csv', row.names = F)
