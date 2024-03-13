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
library(mathjaxr)

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

# # Crear un data frame para los graficos de la unidad 4.3 (comparación y relación)
datos <- expand.grid(Region = regiones,
                     Especie = especies,
                     Periodo = seq(as.Date("2020-01-01"), as.Date("2022-12-31"), by = "month"))

# Generar incidencia simulada para los graficos de la unidad 4.3 (comparación y relación)
datos <- datos %>%
  mutate(Incidencia = case_when(
    Region == "Sitio A" & Especie == "Osos" ~ ifelse(Periodo >= as.Date("2021-01-01") & Periodo <= as.Date("2021-12-31"), rpois(n(), lambda = 40), rpois(n(), lambda = 20)),
    Region == "Sitio A" & Especie != "Osos" ~ rpois(n(), lambda = 20),
    Region != "Sitio A" ~ rpois(n(), lambda = 20)),
    Densidad = ifelse(regiones == "Sitio A" & Especie == "Osos",
                           rpert(n(), min = 10, max = 100, mode = 50),
                           rpert(n(), min = 10, max = 100, mode = 80)),
                           Temperatura = rnorm(n(), mean = 20, sd = 5))

# Crear un data frame para los graficos de la unidad 4.3 (composición)
especies_aves <- data.frame(
  Fecha = seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day"),
  Categoria = sample(c("Endémica", "Migratoria", "Residente"), 365, replace = TRUE),
  Cantidad = sample(1:10, 365, replace = TRUE),
  Cantidad2 = sample(1:10, 365, replace = TRUE),
  AreaProtegida = sample(c("Area1", "Area2", "Area3"), 365, replace = TRUE)
)

# Ajustar cantidades para reflejar estacionalidad de aves migratorias
especies_aves$Cantidad[especies_aves$Categoria == "Migratoria" & format(especies_aves$Fecha, "%m") %in% c("04", "05", "09", "10")] <- especies_aves$Cantidad[especies_aves$Categoria == "Migratoria" & format(especies_aves$Fecha, "%m") %in% c("04", "05", "09", "10")] * 2

# Ajustar cantidades (ahora llamada Cantidad2) para simular diferencias significativas entre áreas
especies_aves$Cantidad2 <- ifelse(especies_aves$AreaProtegida == "Area1", especies_aves$Cantidad2 * runif(1, 1.5, 2),
                                  ifelse(especies_aves$AreaProtegida == "Area2", especies_aves$Cantidad2 * runif(1, 0.5, 1),
                                         especies_aves$Cantidad2 * runif(1, 2, 3)))
