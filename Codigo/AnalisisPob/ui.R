# Header -----------
header <- dashboardHeader(title = "Análisis de población", titleWidth = 300
  
)

# Sidebar -----------
sidebar <- dashboardSidebar(width = 300,
                            sidebarMenu(id = "sidebar",
                                        menuItem("Presentación", tabName = "presentacion"),
                                        menuItem("Análisis de población", tabName = "Pob",
                                                 menuSubItem("Características de población", tabName = "PropEdadSexo"),
                                                 menuSubItem("Diversidad", tabName = "Diversidad"),
                                                 menuSubItem("Muestreo", tabName = "Muestra"),
                                                 menuSubItem("Pruebas estadisticas", tabName = "Estadistica")
                                                 )
                                        )
                            )

# Body --------
body <- dashboardBody(
  tabItems(
    ## Intro ----------------
    tabItem(tabName = "presentacion",
            tags$div(style = "text-align: center;",
                     tags$img(src = "leeyus.png", align = "center", height = 150),
                     tags$img(src = "dgapa_unam.png", align = "center", height = 150)),
            hr(),
            tags$h2(tags$b("Prácticas de temas selectos de salud pública: medicina de conservación y 
                           ecología de enfermedades"), align = "center"),
            'Aqui va el contexto'
            ),
    ## Subunidad 1 ------------
    # Analisis de poblaciones: 
    # Proporción de sexo, proporción de edades, densidad poblacional, tamaño mínimo de muestra, prevalencias ponderadas, esfuerzo de muestreo
    tabItem(tabName = "PropEdadSexo",
            fluidRow(
              ### Seleccion de la variable -----------
              box(
                title = "Seleccion de variable",
                width = 12,
                shiny::selectInput(inputId = 'var', label = 'Variable', choices = colnames(mosquitos)),
                'Esto es texto'
              ),
              ### Figuras del grid ----------
              box(plotlyOutput('Bar')),
              box(plotlyOutput('Grid')),
              box(
                width = 12,
                ### Seleccion de tamaño de muestra -----------
                shiny::sliderInput(inputId = 'sample_size', label = 'Tamaño de muestra', min = 0, max = 722, value = 100) 
              )
            )
          ),
    ## Unidad 2 -----------------
    # Analisis de comunidades:
    # Riqueza, curvas de acumulación de riqueza, rarefacción de riqueza, diversidad alfa, diversidad beta
    tabItem(
      tabName = 'Diversidad'
    )
    ## Unidad 3 -----------------
),
tabItem(tabName = 'Estadistica')
)


# Run the UI
dashboardPage(
  header = header, 
  sidebar = sidebar, 
  body = body
) %>% shinyUI()