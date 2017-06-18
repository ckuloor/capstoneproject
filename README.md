### Introduction
This repository has the resouces used in developing the shiny word prediction application required for the data science capstone project. 

The goal of the final capstone project is to develop a data product using the natural language processing algorithms that will predict the next word given one or more phrase input by the user. A database with text messages from the twitter, blog and news site provided by the coursera team will be used for this project. 

The Tiny Word Prediction App is a simple web application that takes one or more words as input from the user and outputs the next word as predicted by the algorithm.  The app also displays the user input combied with the predicted word as a sentence when there is a prediction available. When there are no predicted words available it simply displays "No Word Found".

### Files 
* ui.R file has UI code
* server.R file has the R code the server side logic including the prediction algorithm.
* Data_Processing.R file has the R code used to load, clean and pre-process the data corpus.
* BiSplitFinal.RDS - Tokenized Bi-Gram data frame saved in R binary format. 
* TriSplitFinal.RDS - Tokenized Tri-Gram data frame saved in R binary format. 
* QuadSplitFinal.RDS - Tokenized Quad-Gram data frame saved in R binary format. 
