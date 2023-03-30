# Server --------------
function(input, output){
  
  # Reactividad ------------
  
  
  
  # Outputs ------------
  output$Grid <- renderPlotly({
    p <- mosquitos %>%
      ggplot() +
      geom_tile(aes(x = x, y = y, fill = !!sym(input$var)), col = 'black') +
      # facet_wrap(~SITIO) + #
      theme_void()

    ggplotly(p)
  })
  
  
} %>% 
  shinyServer()