# Header -----------
header <- dashboardHeader(title = "Medicina de conservación", titleWidth = 300
  
)

# Sidebar -----------
sidebar <- dashboardSidebar(width = 300,
                            sidebarMenu(id = "sidebar",
                                        menuItem("Presentación", tabName = "presentacion"),
                                        menuItem("Análisis de población", tabName = "Pob",
                                                 menuSubItem("Características de población", tabName = "PropEdadSexo"),
                                                 menuSubItem("Muestreo", tabName = "Muestra")
                                                 )
                                        )
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