#
# This is the UI fields/logic of a Shiny web application named Tiny Word Prediction App. 
# This app takes the user text input words and tries to predict the next word using my implementation of
# the Katz back off logic. The predicted word is displayed below the user input field, followed by the full sentence using the user input
# and the predicted word. If no word is found, the sentence field will display the "No Word Found".
#
#

library(shiny)

# Define UI for the Tiny Word Prediction App.
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tiny Word Prediction App"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("caption", "Please enter a word.", ""),
      tags$head(tags$style("#predictedWord{color: red;
                                 text-align: center;
                                 font-size: 20px;
                             font-style: italic;
                             }"
      )
      ),
      h4("The predicted word is: "),
      h3(textOutput("predictedWord")),
      h4("The sentence with predicted word is:"),
      textInput("predictedSent","")
    ),
    
    mainPanel(
    )
  )
))
