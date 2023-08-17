# Header -----------
header <- dashboardHeader(title = "Análisis de población", titleWidth = 300
  
)

# Sidebar -----------
sidebar <- dashboardSidebar(width = 300,
                            sidebarMenu(id = "sidebar",
                                        menuItem("Presentación", tabName = "presentacion"),
                                        menuItem("Análisis de población", tabName = "Pob",
                                                 menuSubItem("Características de población", tabName = "unidad1"),
                                                 menuSubItem("Diversidad", tabName = "unidad2"),
                                                 menuSubItem("Muestreo", tabName = "unidad3"),
                                                 menuSubItem("Pruebas estadisticas", tabName = "unidad4")
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
    tabItem(tabName = "unidad1",
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
      tabName = 'unidad2'
    ),
    ## Unidad 3 -----------------
    tabItem(
      tabName = 'unidad3',
      box(
        title = 'Parametros',
        width = 12,
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
          numericInput(inputId = "N1", value = 20000, label = "Tamaño de la Población: N", min = 1,step = 1),
          numericInput(inputId = "Prev1", value = 15, label = "Prevalencia esperada (%): P"),
          numericInput(inputId = "E1", value = 10, label = "Error relativo (%): E")
        )
      )
    ),
    
    ## Unidad 4 --------------
    tabItem(
      tabName = 'unidad4'
    )
)
)


# Run the UI
dashboardPage(
  header = header, 
  sidebar = sidebar, 
  body = body
) %>% shinyUI()