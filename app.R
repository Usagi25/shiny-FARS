# Shiny App displaying some FARS data plots
# Andrew Zalesak, July 17th, 2021

################################################################################
# What I want: This first simple app will allow the user to produce plots and
# tables of various aspects of the data, such as hour of the day crashes occur,
# day of the week they occur, and other things, and each can be set to show
# crashes with drunk drivers, no drunk drivers, and all crashes.
################################################################################

# Import packages ----
library(shiny)
library(dplyr)

# Load data ----
crash_data <- read.csv("accident.csv")

# Define ui ----
ui <- fluidPage(
  
  titlePanel("Fatal Analysis Reporting System Data"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      radioButtons("involving", label = "Show crashes involving:",
                   choices = c("Drunk driver(s)" = "drunk",
                               "No drunk drivers" = "no_drunk",
                               "Any drivers" = "any")),
      
      selectInput("selection", label = "Display by:",
                  choices = c("Month" = "MONTH",
                              "Hour" = "HOUR"))
      
    ),
    
    mainPanel(
      
      tabsetPanel(
        
        tabPanel("Plot", plotOutput("barplot"))
        
      )
      
    )
    
  )
  
)

# Define server logic to produce plots ----
server <- function(input, output) {
  
  output$barplot <- renderPlot({
    
    plot_data <- crash_data
    
    involving <- input$involving
    
    if (involving == "drunk") {
      plot_data <- crash_data[crash_data$DRUNK_DR > 0,]
    } else if (involving == "no_drunk") {
      plot_data <- crash_data[crash_data$DRUNK_DR == 0,]
    }
    
    selection <- input$selection
    
    barplot(table(plot_data[selection]))
    
  })
  
}

# Create Shiny app
shinyApp(ui = ui, server = server)