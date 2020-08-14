#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Check for needed packages
#and install the ones missing:

packages = c('shiny','FactoMineR','proxy','plotly', 'tidyr')
package.check <- lapply(
    packages,
    FUN = function(x) {
        if (!require(x, character.only = TRUE)) {
            install.packages(x, dependencies = TRUE)
            #library(x, character.only = TRUE)
        }
    }
)

library(shiny)
library(FactoMineR)
library(proxy)
library(tidyr)
library(plotly)

source("helper.R")

#load data set.  The encoding is so it picks up the symbols and accents.
players <- read.csv("data/data.csv",header=TRUE,encoding="UTF-8")

#Cleaning up the data set
#dropping variables I won't use
players <- players[,!names(players) %in% c("X.U.FEFF","Photo","Flag","Club.Logo","Special","Work.Rate","Body.Type",
                       "Real.Face","Jersey.Number","Joined","LS","ST","RS","LW","LF","CF","RF","RW","LAM","CAM",
                       "RAM","LM","LCM","CM","RCM","RM","LWB","LDM","CDM","RDM","RWB","LB","LCB","CB","RCB","RB")]

#dropping players without stats
players <- players %>% drop_na("Crossing", "Finishing", "HeadingAccuracy",
                               "ShortPassing", "Volleys", "Dribbling",
                               "Curve", "FKAccuracy", "LongPassing",
                               "BallControl", "Acceleration", "SprintSpeed",
                               "Agility", "Reactions", "Balance",
                               "ShotPower", "Jumping", "Stamina",
                               "Strength", "LongShots", "Aggression",
                               "Interceptions", "Positioning", "Vision",
                               "Penalties", "Composure", "Marking",
                               "StandingTackle", "SlidingTackle", "GKDiving",
                               "GKHandling", "GKKicking", "GKPositioning",
                               "GKReflexes")

#PCA needs to be run only once.  
pcaplayers <- playerspca(players)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("FIFA 19 Player Options"),
    helpText(p("This application helps you find alternative players whenever
               the one you were looking for can't be purchased (i.e. its club won't sell him)")
             ),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            uiOutput("teamDrop"),
            uiOutput("nameDrop"),
            numericInput("nout",label="How many optional players you want to see?",value=10,min=1,max=15),
            #actionButton("Start","Find your players!") #Button added to remove the flash error at the beginning
            #tags$li("test")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("plot",width="100%"),
            div(tableOutput("table"), style="font-size:90%"),
            
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    #Get the list of teams available for the widget
    teams <- unique(pcaplayers$Club)
    output$teamDrop <- renderUI({selectInput("team",label="Please choose your player's team",
                                              choices=teams)
        })
    
    #Get the list of names within the team for the second widget
    names <- reactive({pcaplayers[pcaplayers$Club == input$team,]$Name})
    output$nameDrop <- renderUI({selectInput("name",label="Please choose your player",
                                             choices=names())
    })
    
    #get the ID of the player to compare
    reference <- reactive({pcaplayers[pcaplayers$Club == input$team & 
                                          pcaplayers$Name == input$name,]$ID})
    
    similarplayers <- reactive({req(reference())
        measuredist(pcaplayers,reference(),input$nout)})
    
    output$table <- renderTable({
        similarplayers()[,c("Name","Age","Nationality","Club","Preferred.Foot",
                            "Position","Contract.Valid.Until","Overall","Value",
                            "Wage","Release.Clause")]
        },spacing="xs",striped=TRUE,bordered=TRUE)
    
    playersplot <- reactive({plotting(similarplayers())})
    output$plot <- renderPlotly({playersplot()})
    
}

# Run the application 
shinyApp(ui = ui, server = server)
