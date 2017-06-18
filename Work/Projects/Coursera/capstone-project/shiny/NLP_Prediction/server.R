#
# This is the server logic of a Shiny web application named Tiny Word Prediction App. 
# This app takes the user text input words and tries to predict the next word using my implementation of
# the Katz back off logic. The predicted word is displayed below the user input field, followed by the full sentence using the user input
# and the predicted word. If no word is found, the sentence field will display the "No Word Found".
#

#load the required libraries
suppressPackageStartupMessages(library(stringr))
library(tm)
library(shiny)

#load the pre-processed tokenized corpus data for bi, tri and quad grams.
# these data sets are already grouped and sorted by the number of frequency of the tokens occurrances.
biSplitFinal <- readRDS(file="BiSplitFinal.RDS")
triSplitFinal <- readRDS(file="TriSplitFinal.RDS")
quadSplitFinal <- readRDS(file="QuadSplitFinal.RDS")

# function to match the top most bi gram data
predictBiGram <- function(x) {
  filteredBi <- biSplitFinal[grepl(paste('^',x[[1]][1], '$', sep=""), biSplitFinal$t1), ]
  filteredBi[1,2]
}

# function to match the top most tri gram data
predictTriGram <- function(x) {
  filteredTri <- triSplitFinal[(grepl(paste('^',x[[1]][1], '$', sep=""), triSplitFinal$t1) & grepl(paste('^',x[[1]][2],'$',sep=""), triSplitFinal$t2)), ]
  filteredTri[1,3]
}

# function to match the top most quad gram data
predictQuadGram <- function(x) {
  filteredQuad <- quadSplitFinal[(grepl(paste('^',x[[1]][1], '$', sep=""), quadSplitFinal$t1) & grepl(paste('^',x[[1]][2],'$',sep=""), quadSplitFinal$t2) & grepl(paste('^',x[[1]][3],'$',sep=""),quadSplitFinal$t3)), ]
  filteredQuad[1,4]
}


predictedSent <- ' '

# Define server logic required to predict the next word for the user input
shinyServer(function(input, output, session) {
  
  observe ({
    
    output$predictedWord <- renderText({
      
      # capture the user input words
      enteredValue <- input$caption
      rawInput <- enteredValue
      #clean up the user input
      enteredValue <- removeNumbers(enteredValue)
      enteredValue <- removePunctuation(enteredValue)
      enteredValue <- tolower(enteredValue)
      
      #tokenize the user input and check in n-grams for matching next word. If not found, just display the word "No Word Found"
      inputTokens <- strsplit(enteredValue, " ")
      predictedDefault <- 'No Word Found'
      predictedWord <- " "
      if (length(inputTokens[[1]]) == 1) {
        filteredBi <- predictBiGram(inputTokens)
        if (!is.na(filteredBi)) {
          predictedWord <- as.character(filteredBi)
        }
      } else if (length(inputTokens[[1]]) == 2) {
        filteredTri <- predictTriGram(inputTokens)
        if (is.na(filteredTri)) {
          filteredTri <- predictBiGram(as.list(c(inputTokens[[1]][2])))
        }
        if (!is.na(filteredTri)) {
          predictedWord <- as.character(filteredTri)
        }
      } else if (length(inputTokens[[1]]) >= 3) {
        tokensToParse <- inputTokens
        tokenLen <- length(tokensToParse[[1]])
        if (tokenLen > 3) {
          tokensToParse <- as.list(c(inputTokens[[1]][tokenLen-2], inputTokens[[1]][tokenLen-1],inputTokens[[1]][tokenLen]))
        }
        filteredQuad <- predictQuadGram(tokensToParse)
        if (is.na(filteredQuad)) {
          filteredQuad <- predictTriGram(as.list(c(tokensToParse[[1]][2], tokensToParse[[1]][3])))
          if (is.na(filteredQuad)) {
            filteredQuad <- predictBiGram(as.list(c(tokensToParse[[1]][3])))
          }
        } 
        if (!is.na(filteredQuad)) {
          predictedWord <- as.character(filteredQuad)
        } 
      } 
      if (predictedWord == " ") {
         predictedSent <- predictedDefault
      } else {
        predictedSent <- paste(rawInput,predictedWord, sep = " ")
      }
      updateTextInput(session, "predictedSent", value = predictedSent)
     
      predictedWord
    })
    
  })
  
})
