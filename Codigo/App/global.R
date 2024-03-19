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
library(vegan)
library(betapart)
library(BiodiversityR)

mosquitos <- read.csv('data/Base_mosquitos.csv')

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


usageInstructions <- div(
  tags$h3("Instrucciones de Uso:"),
  tags$ul(
    tags$li("Ajuste el 'Rango de tamaño de muestra por grupo' para definir los tamaños de muestra con los que desea trabajar."),
    tags$li("Modifique el 'Rango de diferencia de medias' para establecer el rango de diferencias medias entre los grupos a explorar."),
    tags$li("Especifique el 'Número de iteraciones' para controlar la precisión de las simulaciones. Un número mayor de iteraciones puede ofrecer resultados más precisos pero requerirá más tiempo de procesamiento."),
    tags$li("Haga clic en 'Ejecutar Simulación' para iniciar la simulación con los parámetros especificados. Los resultados se visualizarán en el gráfico debajo, mostrando la potencia de las pruebas t de Student y de Wilcoxon en función de las diferencias medias seleccionadas y los tamaños de muestra.")
  )
)

# Definimos la función para realizar las simulaciones de potencia
t_wmw_pwr_sim_exp <- function(n_per_grp = 100, rate = 1, mdiff = .25, iters = 5000) {
  res <- replicate(iters, {
    y_a <- rexp(n_per_grp, rate)
    y_b <- rexp(n_per_grp, rate) + mdiff
    t_res <- t.test(y_a, y_b, var.equal = TRUE)
    wmw_res <- wilcox.test(y_a, y_b)
    list(t_pwr = t_res$p.value, wmw_pwr = wmw_res$p.value)
  }, simplify = FALSE)
  
  c(t_pwr = mean(sapply(res, function(x) x$t_pwr < 0.05)),
    wmw_pwr = mean(sapply(res, function(x) x$wmw_pwr < 0.05)))
}
