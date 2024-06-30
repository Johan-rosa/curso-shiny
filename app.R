library(shiny)
library(tidyverse)

set.seed(123)

stock <- tibble(
  company = rep(c("Google", "Tesla", "nVidia", "Coca Cola"), each = 100),
  day = rep(1:100, times = 4)
) %>%
  group_by(company) %>%
  mutate(
    price = day + cumsum(rnorm(n = 100, mean = 0, sd = 5))
  )

ui <- fluidPage(
  selectInput(
    inputId = "company",
    label = "Compañía",
    choices = unique(stock$company),
    selected = "Google",
    multiple = TRUE
  ),
  plotOutput("plot")
)

server <- function(input, output, session) {

  output$plot <- renderPlot({
    stock %>%
      filter(company %in% input$company) %>%
      ggplot(aes(x = day, y = price, color = company)) +
      geom_line() +
      labs(title = input$company)
  })
}

shinyApp(ui, server)
