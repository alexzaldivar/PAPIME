library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)
library(plotly)
library(DT)
library(plotly)
library(mathjaxr)
library(mc2d)
library(ggplot2)

mosquitos <- read.csv('www/Base_mosquitos.csv')

# create ids in a grid
nr <- ceiling(sqrt(nrow(mosquitos))) # Create combinations for the (x,y) grid
# Add x,y to the df
mosquitos <- mosquitos %>% 
  cbind(expand.grid(x = 1:nr, y = 1:nr)[1:nrow(mosquitos),])

# Tema para los graficos
th <- theme(
  panel.background = element_rect(fill = 'grey95'),
  panel.border = element_rect(fill = NA, color = 'black'), panel.grid = element_line(color = 'grey90')
)





####### Datos sub unidad 4.3 selección de graficos --------
# Definir regiones y especies
set.seed(123)
regiones <- c("Sitio A", "Sitio B", "Sitio C")
especies <- c("Osos", "Ciervos", "Zorros")

# Crear un dataframe con todas las combinaciones posibles de región, especie y periodo
datos <- expand.grid(Region = regiones,
                     Especie = especies,
                     Periodo = seq(as.Date("2020-01-01"), as.Date("2022-12-31"), by = "month"))

# Generar incidencia simulada
datos <- datos %>%
  mutate(Incidencia = case_when(
    Region == "Sitio A" & Especie == "Osos" ~ ifelse(Periodo >= as.Date("2021-01-01") & Periodo <= as.Date("2021-12-31"), rpois(n(), lambda = 40), rpois(n(), lambda = 20)),
    Region == "Sitio A" & Especie != "Osos" ~ rpois(n(), lambda = 20),
    Region != "Sitio A" ~ rpois(n(), lambda = 20)),
    Densidad = ifelse(regiones == "Sitio A" & Especie == "Osos",
                           rpert(n(), min = 10, max = 100, mode = 50),
                           rpert(n(), min = 10, max = 100, mode = 80)),
                           Temperatura = rnorm(n(), mean = 20, sd = 5))
