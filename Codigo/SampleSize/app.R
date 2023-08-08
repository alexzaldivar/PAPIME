#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Calculadora del tamaño de muestra en poblaciones"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "SampleType", label = "Elige el tamaño de muestra a calcular",
                      choices = list("Para detectar una enfermedad en una población" = 1,
                                     "Para estimar una proporción" = 2,
                                     "Para estimar una media" = 3,
                                     "Para comparar proporciones" = 4,
                                     "Para comparar medias" = 5), selected = 1
          ),
          conditionalPanel(
            condition = "input.SampleType == 1",
            h5("Esta calculadora se utiliza para cuando se quiere saber si un grupo de animales con 
               una población finita (N) tiene una enfermedad"),
            h5(tags$b("Por ejemplo:"), "Si deseas saber cuántos venados en una UMA deben diagnosticarse 
            para detectar la presencia o ausencia de una enfermedad."),
            br(),
            h5(tags$b("Nota:"), "La estimación del tamaño de muestra se fundamenta en la premisa de una prueba de 
            diagnóstico perfecta, basándose en la detección de la enfermedad en uno o varios animales."),
            hr(),
            selectInput(inputId = "CL1", choices = list("99" = 99, "95" = 95, "90" = 90), selected = 95, 
                        label = "Nivel de confianza (%): p"),
            numericInput(inputId = "N1", value = 10000, label = "Tamaño de la Población: N", min = 1,step = 1),
            numericInput(inputId = "Prev1", value = 50, label = "Prevalencia esperada (%): P")
          ),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           tableOutput("Resultados")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$n <-
    

  
  
  output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
