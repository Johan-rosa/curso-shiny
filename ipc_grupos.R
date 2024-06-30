library(readxl)

url <- "https://cdn.bancentral.gov.do/documents/estadisticas/precios/documents/ipc_grupos_base_2019-2020.xls"
file_path <- "ipc_grupos.xls"

download.file(
  url = url,
  destfile = file_path,
  mode = "wb"
)

read_excel(
  path = file_path,
  skip = 7
) |>
  view()
