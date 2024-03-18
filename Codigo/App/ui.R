# Header -----------
header <- dashboardHeader(title = "Medicina de conservación y ecologia de enfermedades", titleWidth = 550)

# Sidebar -----------
sidebar <- dashboardSidebar(width = 300,
                            sidebarMenu(id = "sidebar",
                                        menuItem("Presentación", tabName = "presentacion", icon = icon ("circle-info")),
                                        menuItem("Análisis de población", tabName = "Sub4_1", icon = icon("feather-pointed"),
                                                 menuSubItem("Estructura de la población", tabName = "Sub4_1_1"),
                                                 menuSubItem("Tamaño de muestra", tabName = "Sub4_1_2")),
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
    
    
    ## Subunidad 4.1 ------------
    # Analisis de poblaciones: 
    # Proporción de sexo, proporción de edades, densidad poblacional, tamaño mínimo de muestra, prevalencias ponderadas, esfuerzo de muestreo
    tabItem(tabName = "Sub4_1_1",
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
    tabItem(
      tabName = "Sub4_1_2",
      wellPanel(
        tags$h3(tags$b("Calculadora del tamaño de muestra en poblaciones"), align ="center"),
        tags$h4("Esta calculadora se utiliza para cuando se quiere muestrear un grupo de animales (N) y estar 
               seguros de que, con un determinado nivel de confianza, nuestra estimación de prevalencia se acerca 
               al valor real de la población"),
        helpText("Nota: La estimación del tamaño de muestra se fundamenta en la premisa de una prueba de 
            diagnóstico perfecta, basándose en la detección de la enfermedad en uno o varios animales.")),
      fluidRow(
        column(width = 3,
               h4(tags$b("Parámetros para calcular el tamaño de muestra")),
               selectInput(inputId = "CL1", choices = list("99" = 99, "95" = 95, "90" = 90), selected = 95, 
                           label = "Nivel de confianza (%): p"),
               numericInput(inputId = "N1", value = 20000, label = "Tamaño de la Población: N", min = 1,step = 1),
               numericInput(inputId = "Prev1", value = 15, label = "Prevalencia esperada (%): P"),
               numericInput(inputId = "E1", value = 10, label = "Error relativo (%): E")
               ),
        column(width = 9,
               wellPanel(
               h4(tags$b("Por ejemplo:")),
               h4("Se desea saber cuántos venados en una UMA se deben muestrear y analizar 
             para estar seguros al 95% de que nuestra estimación de prevalencia se sitúa dentro del 10% del 
             valor real de la población. Se cree que la prevalencia esperada en una población de 
             venados es del orden del 15%. El tamaño de la población en la UMA (N) es de 20,000 venados"),
             br(),
             DTOutput("Resultados"),
             plotlyOutput("Graph1"),
             withMathJax(),
             h5("Esta calculadora del tamaño de la muestra está diseñada para calcular el tamaño mínimo de la 
             muestra necesario para estimar la prevalencia de una enfermedad en una población. La fórmula utilizada es:"), 
             helpText('$$n\\geq \\frac{Z_{1-(\\alpha/2)}^2NP_y(1-P_y)}{[(N-1)\\epsilon_{r}^{2}P_{y}^{2}]+
                   Z_{1-(\\alpha/2)}^2P_y(1-P_y)}$$'),
             h5("Donde:"),
             helpText("\\(n=\\) El número de individuos de la muestra."),
             helpText("\\(N=\\) El tamaño de la población."),
             helpText("\\(P_y=\\) La prevalencia estimada de la población."),
             helpText("\\(\\epsilon_r=\\) El error relativo."),
             helpText("\\(Z_{1-(\\alpha/2)}=\\) Nivel de confianza deseado (curva normal estandar).")
             )
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
    
    ## Subunidad 4.3 Gráficos --------------
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
                             helpText("Gráfico de barras: son una herramienta visual utilizada para representar datos categóricos con barras rectangulares 
                                      cuyas longitudes son proporcionales a los valores que representan. Este tipo de gráfico es particularmente útil para 
                                      comparar información entre diferentes grupos o categorías de manera clara y directa. Las barras pueden orientarse 
                                      tanto horizontal como verticalmente, ofreciendo una comparación fácil de entender de cantidades o números entre diferentes 
                                      categorías. Por ejemplo, un gráfico de barras puede usarse para mostrar la cantidad de ventas de diferentes productos, 
                                      facilitando la identificación del producto más o menos vendido en un periodo específico."),
                             helpText("Gráfico de línea: el gráfico es ideal para mostrar tendencias o cambios en los datos a lo largo del tiempo, 
                                      conocido también como línea temporal. Este gráfico utiliza puntos conectados por líneas para representar la evolución 
                                      de una o más variables numéricas. La línea temporal permite a los espectadores ver rápidamente cómo los valores cambian 
                                      en un intervalo, identificar picos o caídas en los datos y observar tendencias a largo plazo. Este tipo de visualización 
                                      es común en el análisis financiero, meteorológico o cualquier otro campo donde el factor tiempo y la evolución de los 
                                      datos son cruciales para la interpretación y toma de decisiones."),
                             hr(),
                             tags$h4(tags$b("Preguntas para análisis e interpretación: "), "Cambia el sitio de muestreo y las especies para analizar 
                                     la información presentada en las gráficas:"),
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
                             selectInput("S431_g2reg", label = "Seleccione el sitio de muestreo:", choices = regiones),
                             selectInput("S431_g2esp", label = "Seleccione la especie:",choices = especies, multiple = TRUE, selected = especies),
                             helpText("Gráficos de dispersión (scatterplot): son una herramienta visual utilizada en estadística y 
                                     análisis de datos para representar la relación entre dos variables numéricas. Este tipo de gráfico muestra puntos de datos 
                                     en un sistema de coordenadas cartesianas, donde cada eje representa una de las variables en estudio. 
                                     La posición de cada punto en el gráfico indica los valores de las dos variables para un dato en particular."),
                             helpText("La principal utilidad de los gráficos de dispersión es identificar patrones, tendencias o correlaciones entre las 
                                      variables analizadas. Por ejemplo, si los puntos tienden a agruparse de manera que forman una línea ascendente de 
                                      izquierda a derecha, esto sugiere una correlación positiva, lo que significa que a medida que una variable aumenta, 
                                      la otra también tiende a hacerlo. Por el contrario, una línea descendente indica una correlación negativa. Si los puntos 
                                      están dispersos de manera uniforme sin una dirección clara, esto podría indicar que no hay una relación lineal fuerte 
                                      entre las variables."),
                             hr(),
                             tags$h4(tags$b("Preguntas para análisis e interpretación: "), "Cambia el sitio de muestreo y las especies para analizar 
                                     la información presentada en las gráficas:"),
                             tags$h4("¿Cómo describiría la influencia de la densidad poblacional de osos sobre la incidencia de la enfermedad?"),
                             tags$h4("¿¿Cómo interpretaría la relación entre la temperatura ambiental y la incidencia de la enfermedad?")),
            conditionalPanel("input.S4_3_1Grafico == 3",
                             tags$h4(tags$b("Gráficos de composición: "), "Los gráficos de composición son útiles para visualizar la 
                                     proporción de diferentes categorías o grupos en un conjunto de datos. En ecología de enfermedades y 
                                     medicina de conservación, estos gráficos pueden utilizarse para mostrar la composición de especies, 
                                     comunidades o hábitats."),
                             tags$h4("Ejemplo: Supongamos que estás analizando la composición de especies de aves en un área 
                                     protegida. Podrías usar un gráfico de pastel para mostrar la proporción de especies endémicas, 
                                     migratorias y residentes, lo que te proporcionaría información sobre la diversidad y la estructura de 
                                     la comunidad de aves en el área de estudio."),
                             selectInput("areaSeleccionada",  label = "Seleccione el Área Protegida:", choices = c("Todas", unique(especies_aves$AreaProtegida))),
                             helpText("Gráfico de pastel: El gráfico divide un círculo en sectores que representan proporciones de un total, ideal para visualizar 
                                      la composición porcentual de categorías dentro de un conjunto, como la distribución del mercado entre diferentes empresas. 
                                      Su simplicidad facilita la identificación de las partes más grandes del todo, pero puede complicarse con muchas categorías 
                                      o diferencias pequeñas."),
                             helpText("Gráfico de área apilada: El gráfico muestra la evolución de múltiples variables a lo largo del tiempo, apilando los valores para 
                                      reflejar el total y la contribución relativa de cada categoría. Permite observar tendencias generales y cambios en la 
                                      composición de esas categorías, útil para analizar cómo varios segmentos contribuyen a un agregado a lo largo del tiempo."),
                             hr(),
                             tags$h4(tags$b("Preguntas para análisis e interpretación: "), "Cambia el área protegida para analizar la información presentada en las gráficas:"),
                             tags$h4("¿Cuál de los tres tipos de aves representa la mayor proporción del total observado?"),
                             tags$h4("¿Cómo varía el número de observaciones de cada tipo de ave a lo largo del año ?")),
            conditionalPanel("input.S4_3_1Grafico == 4",
                             tags$h4(tags$b("Gráficos de distribución: "), "En el análisis de datos, estos gráficos muestran la distribución de una variable 
                                     en una población, ayudando a comprender cómo se distribuyen los valores y si existen patrones o 
                                     desviaciones significativas."),
                             tags$h4("Ejemplo: Un histograma podría utilizarse para representar la distribución del número de observaciones de aves en un área natural protegida. 
                                     Esto podría revelar si el número de avistamientos sigue una distribución normal entre sitios o si existen anomalías en la distribución que podrían indicar factores subyacentes."),
                             selectInput("Variables", "Seleccione la variable a mostrar:",choices = list("Area protegida" = 1, "Categoria de especie" = 2)),
                             helpText("Boxplot (Diagrama de caja): Este gráfico muestra la distribución de un conjunto de datos y resalta su mediana, cuartiles y valores atípicos. 
                                      La línea central de cada caja indica la mediana de los datos, mientras que los bordes de la caja representan el primer y tercer cuartil. 
                                      Las líneas que se extienden desde las cajas (bigotes) indican la variabilidad fuera de los cuartiles superiores e inferiores, 
                                      y cualquier punto fuera de estos representa un valor atípico, indicando datos que difieren significativamente del resto de la distribución."),
                             helpText("Histograma de densidad: Es una representación gráfica de la distribución de un conjunto de datos que muestra la frecuencia de observaciones dentro de un rango específico. 
                                      La línea del histograma representa la frecuencia (cantidad de veces que ocurren) de datos dentro de un intervalo particular. Los histogramas son útiles para entender la 
                                      forma de la distribución de los datos, como identificar si la distribución es simétrica, sesgada, tiene uno o varios picos, etc."),
                             hr(),
                             tags$h4(tags$b("Preguntas para análisis e interpretación: "), "Cambia las variables para analizar la información presentada en las gráficas:"),
                             tags$h4("¿Qué áreas protegidas muestran una mayor variabilidad en la cantidad de observaciones de aves?"),
                             tags$h4("¿Cómo difieren las distribuciones de las observaciones entre áreas protegidas y categorías?"))),
            column(width = 6,
                   conditionalPanel("input.S4_3_1Grafico == 1",
                                    tags$h4(tags$b("Promedio de incidencia entre especies y sitios (gráfico de barras)"), align="center"),
                                    plotlyOutput("barras"),
                                    br(),
                                    tags$h4(tags$b("Evolución de la incidencia a lo largo del tiempo (gráfico de lineas)"),  align="center"),
                                    plotlyOutput("linea_tiempo")),
                   conditionalPanel("input.S4_3_1Grafico == 2",
                                    tags$h4(tags$b("Relación entre la densidad poblacional de las especies y la incidencia de la enfermedad (gráfico de dispersión)"), align="center"),
                                    plotOutput("scatter_density"),
                                    br(),
                                    tags$h4(tags$b("Influencia de la temperatura ambiental en la incidencia de la enfermedad (gráfico de dispersión)"), align="center"),
                                    plotOutput("scatter_temperature")
                                    ),
                   conditionalPanel("input.S4_3_1Grafico == 3",
                                    tags$h4(tags$b("Distribución de Aves por Tipo: Migratorias, Endémicas y Residentes (gráfico de pastel)"), align="center"),
                                    plotOutput("plotPastel"),
                                    br(),
                                    tags$h4(tags$b("Evolución Anual de Observaciones: Aves Migratorias, Endémicas y Residentes (gráfico de área apilada)"), align="center"),
                                    plotOutput("plotArea")
                   ),
                   conditionalPanel("input.S4_3_1Grafico == 4",
                                    tags$h4(tags$b("Distribución de observaciones de aves (boxplot)"), align="center"),
                                    plotOutput("boxplot"),
                                    br(),
                                    tags$h4(tags$b("Distribución de observaciones de aves (histograma de densidad)"), align="center"),
                                    plotOutput("histograma")
                                    )
                   )
                   )
            )
            ),
    ## Subunidad 4.3 Pruebas paramétricas y no paramétricas --------------
    tabItem(tabName = "Sub4_3_2",
            box(title = "Introducción a las pruebas paramétricas y no paramétricas", width = 12, collapsed = TRUE, collapsible = TRUE, solidHeader = TRUE, status = "primary",
              tags$h4("Las pruebas paramétricas se basan en supuestos específicos sobre la distribución de los datos, 
                      como la normalidad y la homogeneidad de la varianza, lo que las hace más potentes cuando se cumplen estos supuestos. 
                      Por otro lado, las pruebas no paramétricas son más flexibles y no requieren supuestos estrictos sobre la distribución 
                      de los datos, lo que las hace útiles cuando los datos no siguen una distribución normal o cuando se trabaja con muestras 
                      pequeñas."),
              tags$h4("La elección adecuada entre estos dos tipos de pruebas impacta directamente en la interpretación de resultados y, 
                      en última instancia, en las decisiones de aplicación de medidas de conservación y control de enfermedades. Esta aplicación 
                      proporcionará una comprensión clara de ambos tipos de pruebas y te orientará sobre la elección del análisis de datos en 
                      ecología de enfermedades y medicina de conservación."),
              hr(),
              tags$h3(tags$b("Acerca del ejercicio:"), align ="center"),
              tags$h4("Esta aplicación interactiva está diseñada para explorar y comparar la potencia estadística de dos pruebas comúnmente 
                      utilizadas en análisis de datos: la prueba t de Student y la prueba de Wilcoxon. La potencia de una prueba estadística 
                      es la probabilidad de rechazar correctamente la hipótesis nula cuando es falsa, es decir, la capacidad de la prueba 
                      para detectar un efecto real cuando existe. Mediante simulaciones, esta herramienta permite visualizar cómo la potencia 
                      de estas pruebas cambia en función del tamaño de la muestra y la diferencia real entre los grupos, ofreciendo insights 
                      valiosos para la planificación de estudios y la interpretación de resultados estadísticos")),
              br(),
            usageInstructions,
            fluidRow(
              column(width = 3, 
                     wellPanel(
                     sliderInput("sampleSizeRange", "Rango de tamaño de muestra por grupo:", 
                                 min = 25, max = 250, value = c(25, 250), step = 25),
                     sliderInput("meanDiffRange", "Rango de diferencia de medias:", 
                                 min = 0, max = 0.5, value = c(0, 0.5), step = 0.05),
                     numericInput("iterations", "Número de iteraciones:", 20, min = 10, step = 100),
                     actionButton("runSim", "Ejecutar Simulación")
            
            )),
            column(width = 9,
                   plotOutput("powerPlot"))
            )
            )
    )
)


# Run the UI
dashboardPage(header = header, sidebar = sidebar, body = body) %>% shinyUI()