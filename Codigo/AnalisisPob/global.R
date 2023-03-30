library(shiny)
library(shinydashboard)
library(dplyr)
library(plotly)

mosquitos <- read.csv('www/Base_mosquitos.csv')

# create ids in a grid
nr <- ceiling(sqrt(nrow(mosquitos))) # Create combinations for the (x,y) grid
# Add x,y to the df
mosquitos <- mosquitos %>% 
  cbind(expand.grid(x = 1:nr, y = 1:nr)[1:nrow(mosquitos),])

