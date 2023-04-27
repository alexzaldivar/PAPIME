if (interactive()) {
library(shiny)
library(pwr)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "p", label = "Proporción verdadera", min = 0.1, max = 0.9, value = 0.5, step = 0.05),
      sliderInput(inputId = "d", label = "Diferencia deseada", min = 0.01, max = 0.5, value = 0.05, step = 0.01),
      sliderInput(inputId = "alpha", label = "Nivel de significancia", min = 0.01, max = 0.1, value = 0.05, step = 0.01),
      sliderInput(inputId = "power", label = "Potencia del estudio", min = 0.5, max = 0.99, value = 0.8, step = 0.01)
    ),
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    p <- input$p
    d <- input$d
    alpha <- input$alpha
    power <- input$power
    
    n <- pwr.p.test(h = ES.h(p, p + d), n = NULL, sig.level = alpha, power = power, alternative = "two.sided")$n
    
    plot_prop(p, d, alpha, power, n)
  })
  
}

plot_prop <- function(p, d, alpha, power, n) {
  p_values <- seq(from = p - d, to = p + d, length.out = 100)
  sample_sizes <- sapply(p_values, function(p_val) {
    pwr.p.test(h = ES.h(p_val, p_val + d), n = NULL, sig.level = alpha, power = power, alternative = "two.sided")$n
  })
  
  plot(p_values, sample_sizes, type = "l", xlab = "Proporción verdadera", ylab = "Tamaño de muestra necesario", main = "Tamaño de muestra necesario para proporciones")
  abline(h = n, lty = "dashed")
}

shinyApp(ui = ui, server = server)

}
