
library(shiny)

ui <- fluidPage(
  h1("Registro al curso de programación con Shiny"),
  h2("Sección 1 - 23 y 28 de junio 2024s"),
  textInput(inputId = "nombre", label = "Nombre", value = "Johan"),
  textInput(inputId = "apellido", label = "Apellido"),
  selectInput(
    inputId = "sexo",
    label = "Sexo label",
    choices = c("Masculino", "Femenino")
  ),
  dateInput(
    inputId = "fecha_nacimiento",
    label = "Fecha de nacimiento",
    value = "1992-01-01"
  ),
  numericInput(
    inputId = "semestre",
    label = "Semestre",
    min = 4,
    max = 8,
    value = 5
  ),
  textOutput("resultado")
)

server <- function(input, output, session) {
  output$resultado <- renderText({
    uppercase_name <- toupper(input$nombre)
    uppercase_lastname <- toupper(input$apellido)

    edad <- as.numeric((Sys.Date() - input$fecha_nacimiento) / 365) |>
      round()

    paste(
      "Hola",
      uppercase_name,
      uppercase_lastname, "\n", edad, "años",
      "Sexo:", input$sexo
      )
  })
}

shinyApp(ui, server)

