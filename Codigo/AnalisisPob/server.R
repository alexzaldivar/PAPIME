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
  
  
} %>% 
  shinyServer()