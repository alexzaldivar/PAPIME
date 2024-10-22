# Server --------------
function(input, output){
  

  ###### Subunidad 4.1. Analisis de poblacion  ------
  output$Bar <- renderPlot({
    
    if (input$Sample_effect == TRUE) {
      
    # Grafico con intervalos
    s <- mosquitos[sample(1:nrow(mosquitos), input$sample_size),]
    
    p <- s %>% 
      count(!!sym(input$var)) %>% 
      mutate(N = sum(n)) %>% 
      rowwise() %>% 
      mutate(tst = list(broom::tidy(prop.test(n, N, conf.level=0.95)))) %>%
      tidyr::unnest(tst) %>% 
      mutate(p = n/sum(n)) %>% 
      ggplot(aes(x = !!sym(input$var))) +
      geom_bar(aes(y = p, fill = !!sym(input$var)), stat = 'identity') +
      geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.5) +
      labs(title = paste0('Proporción de mosquitos por ', input$var), x = input$var, y = 'Proporción') +
      th
    
    p
    } else {
      
      p <- mosquitos %>% 
        count(!!sym(input$var)) %>% 
        mutate(N = sum(n)) %>% 
        rowwise() %>% 
        mutate(tst = list(broom::tidy(prop.test(n, N, conf.level=0.95)))) %>%
        tidyr::unnest(tst) %>% 
        mutate(p = n/sum(n)) %>% 
        ggplot(aes(x = !!sym(input$var))) +
        geom_bar(aes(y = p, fill = !!sym(input$var)), stat = 'identity') +
        geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.5) +
        labs(title = paste0('Proporción de mosquitos por ', input$var), x = input$var, y = 'Proporción') +
        th
      
      p
      
    }
    #ggplotly(p)
  })
  
  output$Grid <- renderPlot({
    
    if (input$Sample_effect == TRUE) {
    s <- mosquitos[sample(1:nrow(mosquitos), input$sample_size),]
    
    p <- s %>%
      ggplot() +
      geom_tile(aes(x = x, y = y, fill = !!sym(input$var)), col = 'black') +
      theme_void()

    p
    
    } else {
      
      p <- mosquitos %>%
        ggplot() +
        geom_tile(aes(x = x, y = y, fill = !!sym(input$var)), col = 'black') +
        theme_void()
      
      p
      
    }
    #ggplotly(p)
  })
  
  ###### Subunidad 4.1. Tamaño mínimo de muestra ------
  
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
    
    fig <- fig %>% layout(annotations = a, title = 'Tamaños de muestra alternativos')
    
    fig
    
  })
  
  ###### Subunidad 4.2 ------- Diversidad
  
  observeEvent(input$btn_analizar, {
    

    
    # Preparación de datos
    mosquitos$N <- rep(1, nrow(mosquitos))
    com <- makecommunitydataset(mosquitos, row = "SITIO", column = "NOMBRE", value = "N", drop = TRUE)
    com[com > 1] <- 1
    
    # Diversidad Beta - Índice de Jaccard
    j <- betadiver(com, method = "j")
    
    output$plot_dendrograma_jaccard <- renderPlot({
      plot(hclust(1 - j), hang = -1, main = "Dendrograma - Índice de Jaccard")
    })
    
    # Diversidad Beta - Análisis de Componentes
    bm <- beta.multi(com, index.family = "sorensen")
    
    output$resultados_diversidad <- renderPrint({
      list(
        beta_total = bm$beta.SOR,
        recambio = bm$beta.SIM,
        anidamiento = bm$beta.SNE
      )
    })
    
    # Diversidad Beta - Recambio
    bp <- beta.pair(com, index.family = "sorensen")
    
    output$plot_dendrograma_recambio <- renderPlot({
      plot(hclust(bp$beta.sim), hang = -1, main = "Dendrograma - Recambio de Especies")
    })
  })
  
  
  ## Subunidad 4.3 --------------
  # Filtrar datos según la selección del usuario
  sub4_3graficos <- reactive({
    if (input$S4_3_1Grafico == 1) {
      datos %>%
        filter(Region == input$S431_g1reg) %>%
        filter(Especie %in% input$S431_g1esp)
    } else {
      datos %>%
        filter(Region == input$S431_g2reg) %>%
        filter(Especie %in% input$S431_g2esp)
    }
    
  })
  
  # Grafico de barras
  output$barras <- renderPlotly({
    df <-  sub4_3graficos() %>%
      group_by(Especie) %>%
      summarise(Incidencia = mean(Incidencia))
    
    plot_ly(df, x = ~Especie, y = ~Incidencia, type = "bar",
            color = ~Especie, colors = "Set1") %>%
      layout(xaxis = list(title = "Especie"),
             yaxis = list(title = "Incidencia"))
  })
  
  # Grafico de linea de tiempo
  output$linea_tiempo <- renderPlotly({
    plot_ly(sub4_3graficos(), x = ~Periodo, y = ~Incidencia, type = "scatter",
            mode = "lines+markers", color = ~Especie, colors = "Set1") %>%
      layout(xaxis = list(title = "Periodo"),
             yaxis = list(title = "Incidencia"))
  })
  
  # Gráfico scatter plot 1  Densidad de poblacions vs incidencia
  output$scatter_density <- renderPlot({
    ggplot(sub4_3graficos(), aes(x = Densidad, y = Incidencia, color = Especie)) +
      geom_point(size = 3) +
      stat_smooth(method = "lm", se = TRUE) +
      labs(title = "Densidad vs. Incidencia",
           x = "Densidad", y = "Incidencia") +
      theme_minimal()
  })
  
  # Gráfico scatter plot 2  Temperatura vs incidencia
  output$scatter_temperature <- renderPlot({
    ggplot(sub4_3graficos(), aes(x = Temperatura, y = Incidencia, color = Especie)) +
      geom_point(size = 3) +
      stat_smooth(method = "lm", se = TRUE) +
      labs(title = "Temperatura vs. Incidencia",
           x = "Temperatura", y = "Incidencia") +
      theme_minimal()
  })
  
  # Gráfico de pastel
  output$plotPastel <- renderPlot({
    data <- especies_aves
    if (input$areaSeleccionada != "Todas") {
      data <- data[data$AreaProtegida == input$areaSeleccionada, ]
    }
    dataSum <- aggregate(Cantidad ~ Categoria, data, sum)
    
    ggplot(dataSum, aes(x="", y=Cantidad, fill=Categoria)) +
      geom_bar(width = 1, stat = "identity") +
      coord_polar("y", start=0) +
      theme_void() +
      labs(fill="Categoría", title=paste("Proporción de Categorías de Aves en", input$areaSeleccionada))
  })
  
  # Gráfico de área apilada
  output$plotArea <- renderPlot({
    data <- especies_aves
    if (input$areaSeleccionada != "Todas") {
      data <- data[data$AreaProtegida == input$areaSeleccionada, ]
    }
    
    ggplot(data, aes(x=Fecha, y=Cantidad, fill=Categoria)) +
      geom_area(position='stack') +
      labs(x="Fecha", y="Cantidad", fill="Categoría", title=paste("Estacionalidad de Especies de Aves en", input$areaSeleccionada)) +
      theme_minimal() +
      scale_x_date(date_labels="%b", date_breaks="1 month") +
      theme(axis.text.x=element_text(angle=45, hjust=1))
  })
  
  
  output$boxplot <- renderPlot({
    
    if (input$Variables == 1) {
      
    ggplot(especies_aves, aes(x = AreaProtegida, y = Cantidad2, fill = AreaProtegida)) + 
      geom_boxplot() + 
      theme_minimal() + 
      labs(title = "Distribución de frecuencia de observaciones por área protegida",
           y = "Cantidad de observaciones", x = "Área protegida") +
      scale_fill_discrete(name = "Área protegida")
    } else {
    
      ggplot(especies_aves, aes(x = Categoria, y = Cantidad2, fill = Categoria)) + 
        geom_boxplot() + 
        theme_minimal() + 
        labs(title = "Distribución de frecuencia de observaciones por categoria de aves",
             y = "Cantidad de observaciones", x = "Categoria de aves") +
        scale_fill_discrete(name = "Categorias")
    }
  })
  
  output$histograma <- renderPlot({
    
    if (input$Variables == 1) {
    ggplot(especies_aves, aes(x = Cantidad2, fill = AreaProtegida)) + 
      geom_density(alpha = 0.7, color = "black") + 
      theme_minimal() + 
      facet_wrap(~AreaProtegida, ncol = 3) +
      labs(title = "Histograma de observaciones por área protegida",
           y = "Cantidad de observaciones", x = "Área protegida") +
      scale_fill_discrete(name = "Área Protegida")
    }else {
      ggplot(especies_aves, aes(x = Cantidad2, fill = Categoria)) + 
        geom_density(alpha = 0.7, color = "black") + 
        theme_minimal() + 
        facet_wrap(~Categoria, ncol = 3) +
        labs(title = "Histograma de observaciones por categoria de aves",
             y = "Cantidad de observaciones", x = "Categoria de aves") +
        scale_fill_discrete(name = "Categorias")
      
    }
  })
  
  
  observeEvent(input$runSim, {
    ns <- seq(input$sampleSizeRange[1], input$sampleSizeRange[2], by = 25)
    mdiffs <- seq(input$meanDiffRange[1], input$meanDiffRange[2], by = 0.05)
    iters <- input$iterations
    
    # Preparar un dataframe vacío para almacenar los resultados
    results_df <- data.frame(n = integer(), mdiff = numeric(), test = character(), power = numeric())
    
    for (n in ns) {
      for (mdiff in mdiffs) {
        sim_result <- t_wmw_pwr_sim_exp(n_per_grp = n, mdiff = mdiff, iters = iters)
        # Asegurarse de que los nombres de las columnas sean consistentes
        results_df <- rbind(results_df, data.frame(n = n, mdiff = mdiff, test = "t-test", power = sim_result['t_pwr']))
        results_df <- rbind(results_df, data.frame(n = n, mdiff = mdiff, test = "Wilcoxon", power = sim_result['wmw_pwr']))
      }
    }
    
    output$powerPlot <- renderPlot({
      results_df %>%
        ggplot(aes(x = mdiff, y = power, color = test)) +
        geom_line() +
        facet_wrap(~n, scales = "free_x") +
        labs(title = "Comparación de Potencia: Prueba t vs. Wilcoxon",
             x = "Diferencia de medias", y = "Potencia") +
        scale_color_manual(values = c("t-test" = "salmon", "Wilcoxon" = "cornflowerblue")) +
        theme_minimal()
    })
  })
  
} %>% 
  shinyServer()