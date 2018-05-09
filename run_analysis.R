# Read the data
test <- read.table('test/X_test.txt',stringsAsFactors = FALSE)
train <- read.table('train/X_train.txt',stringsAsFactors = FALSE)


# Merge train and test datasets
all <- bind_rows(train, test)

# We stick only with measurements on the mean and standard deviation
features <- read.table('features.txt', stringsAsFactors = FALSE)
indices <- grep('mean\\()|std\\()', features$V2)
reduced <- all[,indices]
colnames(reduced) <- features$V2[indices]

# Read subject data
subject_train <- read.table('train/subject_train.txt', stringsAsFactors = FALSE)
subject_test <- read.table('test/subject_test.txt', stringsAsFactors = FALSE)
subjects <- bind_rows(subject_train, subject_test)

# Read activities
activities_train <- read.table('train/y_train.txt', stringsAsFactors = FALSE)
activities_test <- read.table('test/y_test.txt', stringsAsFactors = FALSE)
activities <- bind_rows(activities_train, activities_test)
activity_names <- read.table('activity_labels.txt', stringsAsFactors = FALSE)

reduced <- bind_cols(subjects, activities, reduced)
names(reduced)[1] <- 'subject'
names(reduced)[2] <- 'activity'
names(reduced) <- tolower(sub('\\()', '', names(reduced)))
reduced$activity <- activity_names$V2[reduced$activity]

reduced <- reduced[order(reduced$subject),]

# Create tidy dataset
tidy <- melt(reduced, id = c('subject', 'activity'))
tidy <- dcast(tidy, subject + activity ~ variable, mean)

write.table(tidy, 'tidy.txt', row.names = FALSE) 
