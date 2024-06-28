# Paquetes ----------------------------------------------------------------
library(sf)
library(glue)
library(stringr)
library(dplyr)
library(leaflet)

# Información territorial -------------------------------------------------
provincias_metadata <- tibble::tribble(
  ~region_code,                  ~region_label, ~provincia_code,         ~provincia_label,
          "10", "Región Ozama O Metropolitana",            "01",      "Distrito Nacional",
          "05",              "Región Valdesia",            "02",                   "Azua",
          "06",            "Región Enriquillo",            "03",                "Baoruco",
          "06",            "Región Enriquillo",            "04",               "Barahona",
          "04",        "Región Cibao Noroeste",            "05",                "Dajabón",
          "03",        "Región Cibao Nordeste",            "06",                 "Duarte",
          "07",              "Región El Valle",            "07",             "Elías Piña",
          "08",                  "Región Yuma",            "08",               "El Seibo",
          "01",           "Región Cibao Norte",            "09",              "Espaillat",
          "06",            "Región Enriquillo",            "10",          "Independencia",
          "08",                  "Región Yuma",            "11",          "La Altagracia",
          "08",                  "Región Yuma",            "12",              "La Romana",
          "02",             "Región Cibao Sur",            "13",                "La Vega",
          "03",        "Región Cibao Nordeste",            "14", "María Trinidad Sánchez",
          "04",        "Región Cibao Noroeste",            "15",           "Monte Cristi",
          "06",            "Región Enriquillo",            "16",             "Pedernales",
          "05",              "Región Valdesia",            "17",                "Peravia",
          "01",           "Región Cibao Norte",            "18",           "Puerto Plata",
          "03",        "Región Cibao Nordeste",            "19",       "Hermanas Mirabal",
          "03",        "Región Cibao Nordeste",            "20",                 "Samaná",
          "05",              "Región Valdesia",            "21",          "San Cristóbal",
          "07",              "Región El Valle",            "22",               "San Juan",
          "09",               "Región Higuamo",            "23",   "San Pedro De Macorís",
          "02",             "Región Cibao Sur",            "24",        "Sanchez Ramírez",
          "01",           "Región Cibao Norte",            "25",               "Santiago",
          "04",        "Región Cibao Noroeste",            "26",     "Santiago Rodríguez",
          "04",        "Región Cibao Noroeste",            "27",               "Valverde",
          "02",             "Región Cibao Sur",            "28",         "Monseñor Nouel",
          "09",               "Región Higuamo",            "29",            "Monte Plata",
          "09",               "Región Higuamo",            "30",             "Hato Mayor",
          "05",              "Región Valdesia",            "31",       "San José De Ocoa",
          "10", "Región Ozama O Metropolitana",            "32",          "Santo Domingo"
)

# Importando data y shapefiles --------------------------------------------

municipios_sf <- sf::read_sf("data/shapefiles/municipio/MUNCenso2010.shp") |>
  st_transform(crs = 4326) |>
  janitor::clean_names()

## sp::spTransform(sp::CRS("+proj=longlat +datum=WGS84"))
municipios_sf |>
  leaflet::leaflet() |>
  addTiles() |>
  addPolygons(label = ~toponimia)

# Agregar información sobre la división política --------------------------
municipios_sf <- municipios_sf %>%
  dplyr::select(
    id = enlace,
    region_code = reg,
    provincia_code = prov,
    municipio_code = mun,
    municipio_label = toponimia,
    geometry) %>%
  mutate(municipio_label = str_to_title(municipio_label)) %>%
  left_join(provincias_metadata, by = c("region_code", "provincia_code")) %>%
  select(
    id, region_code, region_label,
    provincia_code, provincia_label,
    municipio_code, municipio_label,
    geometry
  )

