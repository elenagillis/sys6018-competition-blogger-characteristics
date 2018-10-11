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
tfidf.70 = removeSparseTerms(tfidf, 0.70)
tfidf.70

# parametric linear model
train_tfidf <- cbind(train_del, as.matrix(tfidf.70))
train_tfidf_model_data <- train_tfidf
train_tfidf_model_data$doc_id <- NULL
train_tfidf_model_data$text <- NULL
train_tfidf_model_data$word_count <- NULL
colnames(train_tfidf_model_data) <- c('gender', 'topic', 'sign', 'age', 'day', 'get', 'go', 'know', 'like', 'one', 'really', 'thing', 'think', 'time', 'well')

linear_model_basic <- lm(age ~ ., data = train_tfidf_model_data)

# predict on test set
test.corpus <- VCorpus(DataframeSource(test))
test.tfidf <- DocumentTermMatrix(test.corpus, control = list(weighting = weightTfIdf))
test.tfidf.70 = removeSparseTerms(test.tfidf, 0.70)
test.tfidf.70

test_tfidf <- cbind(test, as.matrix(test.tfidf.70))
test_tfidf$doc_id <- NULL
test_tfidf$text <- NULL
test_tfidf$word_count <- NULL

test_tfidf[, 5:14] <- 0
colnames(test_tfidf) <- c('gender', 'topic', 'sign', 'like', 'day', 'get', 'go', 'know', 'one', 'really', 'thing', 'think', 'time', 'well')

age <- predict(linear_model_basic, newdata = test_tfidf)
age <- round(age)

predictions <- data.frame('user.id' <- test$doc_id, 'age' <- age)
colnames(predictions) <- c('user.id', 'age')

write.csv(predictions, file = 'predictions_3.csv', row.names = F)
