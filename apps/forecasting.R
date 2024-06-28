library(databcrd)
library(shiny)
library(tidyverse)
library(forecast)

ipc_grupos <- get_ipc_data("grupos") |>
  filter(fecha >= "2012-12-01")

ipc_grupos_ts <- ipc_grupos |>
  select(-c(fecha, year, mes)) |>
  ts(start = c(1990, 01), frequency = 12)

group_selected <- ipc_grupos_ts[, 'ipc_ayb_vm']

group_selected |>
  auto.arima() |>
  forecast(h = 6) |>
  autoplot()

group_selected |>
  forecast::ets() |>
  forecast::forecast(h = 6) |>
  autoplot()

forecast(model, h = 8) |>
  autoplot()

residuals(model) |>
  autoplot()

residuals(model) |>
  ggAcf()
