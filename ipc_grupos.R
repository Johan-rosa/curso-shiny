library(readxl)

url <- "https://cdn.bancentral.gov.do/documents/estadisticas/precios/documents/ipc_grupos_base_2019-2020.xls"
file_path <- "ipc_grupos.xls"

download.file(
  url = url,
  destfile = file_path,
  mode = "wb"
)

contenido <- read_excel(
  path = file_path,
  skip = 7,
  col_names = FALSE
)

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
