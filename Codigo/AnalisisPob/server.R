# Server --------------
function(input, output){
  
  # Reactividad ------------
  
  
  
  # Outputs ------------
  output$Bar <- renderPlotly({
    # Grafico con intervalos
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
    
    ggplotly(p)
  })
  
  output$Grid <- renderPlotly({
    p <- mosquitos %>%
      ggplot() +
      geom_tile(aes(x = x, y = y, fill = !!sym(input$var)), col = 'black') +
      theme_void()

    ggplotly(p)
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
  
} %>% 
  shinyServer()