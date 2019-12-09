library("shiny")
library("ggplot2")
library("dplyr")
library("lubridate")
library("rlang")
library(datasets)


ui <- 
        fluidPage(
                
                # App title ----
                titlePanel("Airquality Dataset plotting app!"),
                p("This is a very simple Shiny app where you can select the axis you want to vizualize in the graph.
                  Data sourced from 'Airquality' datasets."),
                
                # Sidebar layout with input and output definitions ----
                sidebarLayout(
                        
                        # Sidebar panel for inputs ----
                        sidebarPanel(
                                
                                # Input: Slider for the number of bins ----
                                selectInput("X_ax", "X_ax", choices = "date" )
                        ),
                        sidebarPanel(
                                
                                # Input: Slider for the number of bins ----
                                selectInput("Y_ax", "y_ax", choices = "Wind")
                        )
                        
                ),
                
                # Main panel for displaying outputs ----
                mainPanel(
                        
                        # Output: Histogram ----
                        mainPanel( plotOutput("myPlot") )
                        
                )
        )


server <- function(input, output, session) {
        df <- datasets::airquality %>%
                mutate(date = ymd(paste("1979", Month, Day, sep = "-")))
        
        rf <- reactive({
                # req(input$data_input)
                updateSelectInput(session, "X_ax", choices = colnames(df))
                updateSelectInput(session, "Y_ax", choices = colnames(df)[1:4])
                df
        })
        
        observeEvent(rf(),{
                
        })
        
        
        output$myPlot = renderPlot({
                x = parse_quo(input$X_ax, env = caller_env())
                y = parse_quo(input$Y_ax, env = caller_env())
                ggplot(data = isolate(rf()), aes(x = !!x, y = !!y)) + geom_point() + theme_classic()
        })
        
        
}

shinyApp(ui, server)