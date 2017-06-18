suppressPackageStartupMessages(library(tm))
suppressPackageStartupMessages(library(dplyr))
options(java.parameters = "-Xmx8g")
suppressPackageStartupMessages(library(RWeka))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(R.utils))
library(stringr)

if(!file.exists("swiftkey-dataset.zip")) {
  url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
  download.file(url, destfile = "swiftkey-dataset.zip")
  unzip("swiftkey-dataset.zip", exdir = ".")
}

fileNames <- c ("en_US.blogs.txt","en_US.news.txt","en_US.twitter.txt")
filePath <- "./final/en_US/"
# load each file and count the number of rows
con=file(paste(filePath,fileNames[1], sep=""),open="r")
blogLines = readLines(con, skipNul = TRUE) 
blogNumOfLines=length(blogLines)
close(con)
con=file(paste(filePath,fileNames[2], sep=""),open="r")
newsLines=readLines(con,skipNul = TRUE) 
newsNumOfLines=length(newsLines)
close(con)
con=file(paste(filePath,fileNames[3], sep=""),open="r")
twtLines=readLines(con,skipNul = TRUE) 
twtsNumOfLines=length(twtLines)
close(con)


percentLines <- 0.01
blogSamples <- sample(blogLines, blogNumOfLines * percentLines)
newsSamples <- sample(newsLines, newsNumOfLines * percentLines)
twitterSamples <- sample(twtLines, twtsNumOfLines * percentLines)

# build a combied data set of the 3 samples subsets above for our analysis
allSamples <-  c(blogSamples, newsSamples, twitterSamples)

#Build the data corpus from the allSamples data set. While doing so, we also remove numbers, punctuations 
# and white spaces. Let us also convert all characters to lower case as well.
nplCorpus <- VCorpus(VectorSource(allSamples))
nplCorpus <- tm_map(nplCorpus, content_transformer(tolower))
nplCorpus <- tm_map(nplCorpus, removeNumbers) 
nplCorpus <- tm_map(nplCorpus, removePunctuation)
nplCorpus <- tm_map(nplCorpus, stripWhitespace)
nplCorpusDf <-data.frame(text=unlist(sapply(nplCorpus, `[`, "content")), stringsAsFactors=F)

# implement a function for tokenization
# create 2, 3 and 4 tokens matrix

biGramTokens <- NGramTokenizer(nplCorpusDf, Weka_control(min = 2, max = 2))
# convert the tokens into a data frame and sort by frequencies
biGramDF <- data.frame(table(biGramTokens))
biGramDF <- biGramDF[order(biGramDF$Freq,decreasing = TRUE),]
biSplit <- strsplit(as.character(biGramDF$biGramTokens), " ")
biSplitFinal <- as.data.frame(do.call(rbind, biSplit))
biSplitFinal$count <-biGramDF$Freq
colnames(biSplitFinal) <- c("t1", "t2","count")

#saving the bi-gram R data frame to be used in the Tiny Word Prediction Shiny App later.
saveRDS(biSplitFinal, "BiSplitFinal.RDS")


triGramTokens <- NGramTokenizer(nplCorpusDf, Weka_control(min = 3, max = 3))
triGramDF <- data.frame(table(triGramTokens))
triGramDF <- triGramDF[order(triGramDF$Freq,decreasing = TRUE),]
triSplit <- strsplit(as.character(triGramDF$triGramTokens), " ")
triSplitFinal <- as.data.frame(do.call(rbind, triSplit))
triSplitFinal$count <- triGramDF$Freq
colnames(triSplitFinal) <- c("t1", "t2","t3","count")

#saving the tri-gram R data frame to be used in the Tiny Word Prediction Shiny App later.
saveRDS(triSplitFinal, "TriSplitFinal.RDS")

quadGramTokens <- NGramTokenizer(nplCorpusDf, Weka_control(min = 4, max = 4)) 
quadGramDF <- data.frame(table(quadGramTokens))
quadGramDF <- quadGramDF[order(quadGramDF$Freq,decreasing = TRUE),]

quadSplit <- strsplit(as.character(quadGramDF$quadGramTokens), " ")
quadSplitFinal <- as.data.frame(do.call(rbind, quadSplit))
quadSplitFinal$count <-quadGramDF$Freq
colnames(quadSplitFinal) <- c("t1", "t2","t3","t4","count")

#saving the bi-gram R data frame to be used in the Tiny Word Prediction Shiny App later.
saveRDS(quadSplitFinal, "QuadSplitFinal.RDS")
