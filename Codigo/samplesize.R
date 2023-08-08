if (interactive()) {
  library(shiny)
  
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput("opcion", "Selecciona una opción:", c(1, 2, 3))
      ),
      mainPanel(
        tableOutput("tabla_resultados")
      )
    )
  )
  
  server <- function(input, output) {
    
    output$tabla_resultados <- renderTable({
      opcion_seleccionada <- as.numeric(input$opcion)
      muestra_calculada <- calcularTamanoMuestra(opcion_seleccionada)  # Función que calcula el tamaño de muestra
      
      data.frame(
        Opcion_Seleccionada = opcion_seleccionada,
        Tamano_Muestra = muestra_calculada
      )
    })
    
    calcularTamanoMuestra <- function(opcion) {
      # Lógica para calcular el tamaño de muestra
      # Puedes reemplazar esto con tu fórmula de cálculo real
      tamano_muestra <- opcion * 10
      return(tamano_muestra)
    }
  }
  
  shinyApp(ui, server)

}
