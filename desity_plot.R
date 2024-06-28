library(shiny)
library(ggplot2)

ui <- fluidPage(
  numericInput(
    inputId = "size",
    label = "Tamaño",
    value = 500,
    min = 100,
    max = 1000,
    step = 100
  ),
  plotOutput("plot")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    data <- data.frame(x = rnorm(n = input$size))
    ggplot(data, aes(x = x)) +
      geom_histogram()
  })
}

shinyApp(ui, server)
