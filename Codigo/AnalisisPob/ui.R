# Header -----------
header <- dashboardHeader(title = "Medicina de conservación y ecologia de enfermedades", titleWidth = 550)

# Sidebar -----------
sidebar <- dashboardSidebar(width = 300,
                            sidebarMenu(id = "sidebar",
                                        menuItem("Presentación", tabName = "presentacion", icon = icon ("circle-info")),
                                        menuItem("Análisis de población", tabName = "Sub4_1", icon = icon("feather-pointed")),
                                        menuItem("Análisis de comunidades", tabName = "Sub4_2", icon = icon("circle-nodes")),
                                        menuItem("Selección de herramientas estadísticas", tabName = "Sub4_3", icon = icon("chart-pie"),
                                                 menuSubItem("Gráficos", tabName = "Sub4_3_1"),
                                                 menuSubItem("Pruebas paramétricas y no paramétricas", tabName = "Sub4_3_2"))
                                        )
                            )

# Body --------
body <- dashboardBody(
  tabItems(
    ## Intro ----------------
    tabItem(tabName = "presentacion",
            tags$div(style = "text-align: center;",
                     tags$img(src = "leeyus.png", align = "center", height = 200)),
            hr(),
            tags$h1("Prácticas de temas selectos de salud pública: medicina de conservación y 
                           ecología de enfermedades.", align = "center"),
            hr(),
            tags$h3("Bienvenido a nuestra aplicación web educativa, diseñada específicamente para abordar los desafíos relacionados 
                    con el análisis de datos en estudios de enfermedades en fauna silvestre. En esta plataforma, nos enfocamos en 
                    proporcionar herramientas y conocimientos básicos que permitan a los alumnos una integración efectiva 
                    entre los datos recopilados en el campo, el análisis de datos y la interpretación de los resultados en el campo
                    de la ecologia de las enfermedades."),
            tags$h3("Nuestra aplicación se efoca en la Unidad 4 del curso, que se centra en la integración y análisis de datos en 
                    estudios de enfermedades en fauna silvestre. En esta unidad, nos adentramos en tres subunidades principales:"),
            tags$h3(tags$b("Subunidad 4.1 Análisis de Población: "), "Aquí abordamos aspectos como la proporción de sexo, proporción 
                    de edades, densidad poblacional, tamaño mínimo de muestra, prevalencias ponderadas y esfuerzo de muestreo. 
                    Estas métricas son fundamentales para comprender la dinámica de las poblaciones de vida silvestre y son cruciales 
                    para la toma de decisiones en la gestión de la conservación y la salud de la fauna."),
            tags$h3(tags$b("Subunidad 4.2 Análisis de Comunidades: "), "En esta sección, nos adentramos en conceptos como la riqueza, 
                    las curvas de acumulación de riqueza, la rarefacción de riqueza, la diversidad alfa y la diversidad beta. 
                    Estos análisis nos permiten comprender la estructura y la diversidad de las comunidades de vida silvestre, 
                    lo que es esencial para evaluar la salud y la estabilidad de los ecosistemas."),
            tags$h3(tags$b("Subunidad 4.3 Selección de Pruebas Estadísticas: "), "Aquí nos centramos en la selección adecuada de pruebas 
                    estadísticas, tanto paramétricas como no paramétricas, así como en la interpretación de gráficos. Estas habilidades 
                    son cruciales para analizar y comunicar de manera efectiva los datos recopilados en estudios de enfermedades en fauna 
                    silvestre, ayudando a extraer conclusiones significativas y respaldadas por evidencia."),
            tags$h3("Únete a nosotros en esta emocionante exploración del análisis de datos en la medicina veterinaria de la fauna silvestre. 
                    Nuestra aplicación te proporcionará las herramientas y el conocimiento necesario para realizar análisis robustos y avanzados, 
                    contribuyendo así al avance de la comprensión y conservación de la vida silvestre en nuestro entorno natural. 
                    ¡Comencemos a explorar juntos!"),
            tags$div(style = "text-align: center;",
                     tags$img(src = "dgapa_unam.png", align = "center", height = 200))
            ),
    
    
    ## Subunidad 1 ------------
    # Analisis de poblaciones: 
    # Proporción de sexo, proporción de edades, densidad poblacional, tamaño mínimo de muestra, prevalencias ponderadas, esfuerzo de muestreo
    tabItem(tabName = "Sub4_1",
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
    
    ## Subunidad 4.3 --------------
    tabItem(tabName = "Sub4_3_1",
            wellPanel(
            tags$h3(tags$b("Objetivo de los gráficos"), align ="center"),
            tags$h4("Los gráficos son herramientas fundamentales en el análisis de datos en medicina de conservación y 
                    ecología de enfermedades. Permiten visualizar patrones, tendencias y relaciones entre variables, 
                    lo que ayuda a comprender mejor los fenómenos estudiados y tomar decisiones informadas. La elección del tipo 
                    de gráfico depende de la naturaleza de los datos y de las preguntas específicas de investigación que se estén abordando"),
            tags$h4("A continuación, elige una actividad de gráficos para explorar más:"),
            radioGroupButtons(size = "lg",
              inputId = "S4_3_1Grafico", label = tags$h4(tags$b("¿Qué te gustaria mostrar?")), 
              choices = list("Comparación" = 1, "Relación" = 2, "Composición" = 3, "Distribución" = 4),
              selected = 0,status = "primary"),
            fluidRow(
              column(width = 6,
            conditionalPanel("input.S4_3_1Grafico == 1",
                             tags$h4(tags$b("Gráficos de comparación: "), "En el ámbito de la ecología de enfermedades y medicina de conservación, los gráficos de 
                                     comparación son esenciales para contrastar y visualizar diferencias entre diferentes grupos 
                                     o categorías de datos. Estos gráficos permiten identificar patrones epidemiológicos y 
                                     diferencias significativas entre poblaciones, especies, lugares o tiempo."),
                             tags$h4("Ejemplo: Supongamos que estás estudiando la incidencia de una enfermedad en diferentes 
                                     especies de mamíferos en un área de conservación. Podrías usar un gráfico de barras para comparar 
                                     la prevalencia de la enfermedad entre las especies como osos, ciervos y zorros. También podrias observar
                                     como esa incidencia evoluciona a lo largo de un periodo de tiempo."),
                             selectInput("S431_g1reg", "Selecciona el sitio de muestreo:", choices = regiones),
                             selectInput("S431_g1esp", "Seleccione la especie:", choices = especies, multiple = TRUE, selected = especies),
                             hr(),
                             tags$h4(tags$b("Preguntas de análisis e interpretación: "), "Varía el sitio de muestreo y las especies para analizar la información presentada en las gráficas:"),
                             tags$h4("¿Qué especie muestra un aumento significativo en la incidencia de la enfermedad?"),
                             tags$h4("¿En qué sitio de muestreo se observa el aumento de la incidencia de la enfermedad?"),
                             tags$h4("¿Qué conclusiones puedes sacar al observar ambas gráficas en conjunto?")),
            conditionalPanel("input.S4_3_1Grafico == 2",
                             tags$h4(tags$b("Gráficos de relación: "), " Los gráficos de relación son útiles para visualizar la relación 
                                     entre variables biológicas, ambientales o epidemiológicas. Estos gráficos ayudan a identificar 
                                     relaciones causa-efecto, correlaciones y patrones de interacción entre factores."),
                             tags$h4("Ejemplo: Imagina que estás investigando la relación entre la temperatura ambiental, la densidad de población y 
                                     la propagación de una enfermedad entre las especies como osos, ciervos y zorros. Podrías usar un gráfico de 
                                     dispersión para visualizar cómo varía la incidencia de la enfermedad en función de las fluctuaciones de 
                                     temperatura y densidad de población, lo que te permitiría identificar posibles asociaciones con la transmisión 
                                     de la enfermedad."),
                             selectInput("S431_g2reg", "Seleccione el sitio de muestreo:", choices = regiones),
                             selectInput("S431_g2esp", "Seleccione la especie:",choices = especies, multiple = TRUE, selected = especies)),
            conditionalPanel("input.S4_3_1Grafico == 3",
                             tags$h4(tags$b("Gráficos de composición: "), "Los gráficos de composición son útiles para visualizar la 
                                     proporción de diferentes categorías o grupos en un conjunto de datos. En ecología de enfermedades y 
                                     medicina de conservación, estos gráficos pueden utilizarse para mostrar la composición de especies, 
                                     comunidades o hábitats."),
                             tags$h4("Ejemplo: Supongamos que estás analizando la composición de especies de aves en un área 
                                     protegida. Podrías usar un gráfico de pastel para mostrar la proporción de especies endémicas, 
                                     migratorias y residentes, lo que te proporcionaría información sobre la diversidad y la estructura de 
                                     la comunidad de aves en el área de estudio.")),
            conditionalPanel("input.S4_3_1Grafico == 4",
                             tags$h4(tags$b("Gráficos de distribución: "), "En el análisis de datos, estos gráficos muestran la distribución de una variable 
                                     en una población, ayudando a comprender cómo se distribuyen los valores y si existen patrones o 
                                     desviaciones significativas."),
                             tags$h4("Ejemplo: Un histograma podría utilizarse para representar la distribución de tamaños de colonias de 
                                     un patógeno en una población de huéspedes. Esto podría revelar si la carga parasitaria sigue una distribución normal 
                                     o si existen anomalías en la distribución que podrían indicar factores subyacentes."))),
            column(width = 6,
                   conditionalPanel("input.S4_3_1Grafico == 1",
                                    tags$h4(tags$b("Promedio de incidencia entre especies y sitios (gráfico de barras)"), align="center"),
                                    plotlyOutput("barras"),
                                    br(),
                                    tags$h4(tags$b("Evolución de la incidencia a lo largo del tiempo (gráfico de lineas)"),  align="center"),
                                    plotlyOutput("linea_tiempo")),
                   conditionalPanel("input.S4_3_1Grafico == 2",
                                    plotOutput("scatter_density"),
                                    br(),
                                    plotOutput("scatter_temperature")
                                    )
                   )
            )
            )
            )
    )
  )


# Run the UI
dashboardPage(header = header, sidebar = sidebar, body = body) %>% shinyUI()