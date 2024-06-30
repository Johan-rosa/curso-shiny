library(forecast)
library(readxl)
library(tidyverse)
library(echarts4r)

url <- "https://cdn.bancentral.gov.do/documents/estadisticas/precios/documents/ipc_grupos_base_2019-2020.xls"
file_path <- "ipc_grupos.xls"

# download.file(
#   url = url,
#   destfile = file_path,
#   mode = "wb"
# )

grupos <- c(
  "ayb",
  "bebidas_alcoholicas",
  "prendas_de_vestir",
  "vivienda",
  "muebles",
  "salud",
  "transporte",
  "comunicaciones",
  "recreacion_cultura",
  "educacion",
  "restaurantes_hoteles",
  "bienes_diversos"
)

names <- c(
  "mes",
  paste0(rep(grupos, each = 2), c("", "_vm"))
)

ipc_grupos <- read_excel(
  path = file_path,
  skip = 7,
  col_names = FALSE
) |>
  select(1:25) |>
  setNames(names) |>
  mutate(
    year = ifelse(mes %in% 1999:2024, mes, NA)
    #year = str_extract(mes, "^\\d*$")
  ) |>
  fill(year) |>
  filter(!is.na(ayb)) |>
  relocate(year) |>
  mutate(
    across(-c(year, mes), as.numeric),
    fecha = seq(as.Date("1999-01-01"), by = "month", length.out = n())
  ) |>
  relocate(fecha)

fc_functions <- list(
  Arima = auto.arima,
  ETS = ets
)

library(shiny)

ui <- fluidPage(
  titlePanel("Forecast IPC - Curso Shiny"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(
        inputId = "grupo", label = "Grupo IPC", choices = grupos, selected = "ayb"),
        selectInput('year', "Año de inicio", choices = 1999:2024, selected = 2016),
        numericInput("h", "Horizonte de pronóstico", value = 6),
        radioButtons(
          inputId = "model", "Modelo", choices = c("Arima", "ETS"), selected = "ETS")
    ),
    mainPanel = mainPanel(
      plotOutput("indice_plot"),
      fluidRow(
        column(plotOutput("vm_plot"), width = 6),
        column(plotOutput("forecast_plot"), width = 6)
      ),
      tags$style("h2 {color: #ffb0cb;}")

    )
  )
)

server <- function(input, output, session) {
  ipc_data <- reactive({
    ipc_grupos |>
      filter(year >= input$year)
  })

  ipc_ts <- reactive({
    ipc_data() |>
      select(any_of(paste0(input$grupo, "_vm"))) |>
      ts(start = c(input$year, 1), frequency = 12)
  })

  fc_model <- reactive({
    fn <- fc_functions[[input$model]]
    fn(ipc_ts())
  })

  fc_forecast <- reactive({
    forecast(fc_model(), h = input$h)
  })

  output$indice_plot <- renderPlot({
    ipc_data() |>
      ggplot(aes(x = fecha, y = .data[[input$grupo]])) +
      geom_line() +
      labs(title = paste("Índice IPC -", input$grupo))
  })

  output$vm_plot <- renderPlot({
    ipc_data() |>
      ggplot(aes(x = fecha, y = .data[[paste0(input$grupo, "_vm")]])) +
      geom_line() +
      labs(title = paste("Variación mensual IPC", input$grupo))
  })

  output$forecast_plot <- renderPlot({
    autoplot(fc_forecast(), title = "Forecast")
  })

}

shinyApp(ui, server)

