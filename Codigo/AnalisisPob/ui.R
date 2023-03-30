# Header -----------
header <- dashboardHeader(
  
)

# Sidebar -----------
sidebar <- dashboardSidebar(
  
)

# Body --------
body <- dashboardBody(
  fluidRow(
    box(
      ## Input de la variable -----------
      shiny::selectInput(inputId = 'var', label = 'Variable', choices = colnames(mosquitos)),
      
      ## Output del grid ----------
      plotlyOutput('Grid'),
     hr() 
    ),
    box(
      ## Input de la variable -----------
      shiny::sliderInput(inputId = 'sample_size', label = 'Tamaño de muestra', min = 0, max = 722, value = 100) 
    )
  )
  
)


# Run the UI
dashboardPage(
  header = header, 
  sidebar = sidebar, 
  body = body
) %>% shinyUI()