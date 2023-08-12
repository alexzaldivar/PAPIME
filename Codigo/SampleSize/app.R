

library(shiny)
library(DT)
library(plotly)
library(mathjaxr)

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
            h5("Esta calculadora se utiliza para cuando se quiere muestrear un grupo de animales (N) y estar 
               seguros de que, con un determinado nivel de confianza, nuestra estimación de prevalencia se acerca 
               al valor real de la población"),
            br(),
            h5(tags$b("Nota:"), "La estimación del tamaño de muestra se fundamenta en la premisa de una prueba de 
            diagnóstico perfecta, basándose en la detección de la enfermedad en uno o varios animales."),
            hr(),
            selectInput(inputId = "CL1", choices = list("99" = 99, "95" = 95, "90" = 90), selected = 95, 
                        label = "Nivel de confianza (%): p"),
            numericInput(inputId = "N1", value = 10000, label = "Tamaño de la Población: N", min = 1,step = 1),
            numericInput(inputId = "Prev1", value = 50, label = "Prevalencia esperada (%): P"),
            numericInput(inputId = "E1", value = 10, label = "Error relativo (%): E")
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
          conditionalPanel(
            condition = "input.SampleType == 1",
          h4("Por ejemplo:"),
          h5("Se desea saber cuántos venados en una UMA se deben muestrear y analizar 
             para estar seguros al 95% de que nuestra estimación de prevalencia se sitúa dentro del 10% del 
             valor real de la población. Se cree que la prevalencia esperada en una población de 
             venados es del orden del 15%. El tamaño de la población en la UMA (N) es de 20,000 venados"),
          br(),
           DTOutput("Resultados"),
           plotlyOutput("Graph1"),
          h4("Ecuación:"),
          withMathJax(),
          h5("La fórmula utilizada para calcular el tamaño de la muestra es:")
          )
          )
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

  n <- reactive({
    Z <- qnorm(1 - (1-(as.numeric(input$CL1)/100))/2)^2
    P <- input$Prev1/100
    E <- input$E1/100

    n <- round((Z * input$N1 * P * (1-P)) / (((input$N1-1) * E^2 * P^2) + Z * P * (1-P)))
    
  })

  output$Resultados <- renderDT({
    datatable(data.frame(
      n = n(),
      DiseasedAnim = (input$Prev1*input$N1)/100,
      FracSamp = (n()/input$N1)*100), 
      rownames = FALSE, 
      options = list(paging=FALSE, searching=FALSE,
                     columnDefs = list(
                       list(targets = 0, title = "Tamaño mínimo de muestra"),
                       list(targets = 1, title = "Número de animales enfermos"),
                       list(targets = 2, title = "Fracción de muestreo (%)")
                       )
                     )
      )
  })

  output$Graph1 <- renderPlotly({
    Z <- qnorm(1 - (1-(as.numeric(input$CL1)/100))/2)^2
    E <- input$E1/100
    prev <- seq(0.01:1, by= 0.01)
    
    result <- c()
    
    for (i in prev) {
      n <- round((Z * input$N1 * prev * (1-prev)) / (((input$N1-1) * E^2 * prev^2) + Z * prev * (1-prev)))
      result <- c(n)
    }
    
    data <- data.frame(Prevalencia = prev*100,
                       n = result,
                       label = paste("Prevalencia: ", prev*100, "%", "<br>",
                                     "n: ",result))
    a <- list(
      x = input$Prev1,
      y = n(),
      text = paste("Prevalencia: ", input$Prev1,"%", "<br>",
                   "n: ",n()),
      xref = "x",
      yref = "y",
      showarrow = TRUE,
      arrowhead = 7,
      ax = 50,
      ay = -30
      )
    
    fig <- plotly::plot_ly(data, x = ~Prevalencia, y = ~n, hoverinfo = 'text', text = ~label, 
                           type = 'scatter', mode = 'lines+markers')
    
    fig <- fig %>% layout(annotations = a)
    
    fig
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
