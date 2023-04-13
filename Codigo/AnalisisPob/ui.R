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
  tabItems(
    tabItem(tabName = "presentacion",
            tags$h3(tags$b("Universidad Nacional Autónoma del México"), align = "center"),
            tags$h3(tags$b("Facultad de Medicina Veterinaria y Zootécnia"), align = "center"),
            tags$h3(tags$b("Departamento de etología, fauna silvestre y animales de laboratorio"), align = "center"),
            br(),
            tags$div(style = "text-align: center;",
            tags$img(src = "leeyus.png", align = "center")),
            hr(),
            tags$h2(tags$b("Plataforma interactiva para la asignatura de prácticas de temas selectos de salud
                           pública: medicina de conservación y ecología de enfermedades"), align = "center")
            ),
    tabItem(tabName = "PropEdadSexo",
  fluidRow(
    box(
      ## Input de la variable -----------
      shiny::selectInput(inputId = 'var', label = 'Variable', choices = colnames(mosquitos)),
      
      ## Output del grid ----------
      plotlyOutput('Bar'),
      plotlyOutput('Grid'),
     hr() 
    ),
    box(
      ## Input de la variable -----------
      shiny::sliderInput(inputId = 'sample_size', label = 'Tamaño de muestra', min = 0, max = 722, value = 100) 
    )
  )
  
)
)
)


# Run the UI
dashboardPage(
  header = header, 
  sidebar = sidebar, 
  body = body
) %>% shinyUI()