---
  title: "Project1"
author: "Tanishka"
date: "2023-03-11"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(lubridate)
library(stringr)
library(readxl)
library(ggplot2)
library(reshape2)
library(ggalluvial)
library(highcharter)
library(plotly)
library(ggraph)
library(vctrs)
library(webr)
library(leaflet)
library(ggmap)
library(rworldmap)
library(countrycode)
library(scales)
```

```{r}
gdp <- read.csv(file.choose())
gdp <- gdp %>% na.omit()
gdp$GDP.per.capita <- as.numeric(gdp$GDP.per.capita)
gdp
```

```{r}

# Define custom color function based on GDP values
custom_color <- colorFactor(
  palette = c("#fef0d9", "#fdcc8a", "#fc8d59", "#e34a33", "#b30000"),
  domain = gdp$GDP.per.capita
)

# Set up the map
gdp_map <- leaflet(gdp) %>%
  addTiles() %>%
  setView(lng = mean(gdp$longitude), lat = mean(gdp$latitude), zoom = 4)

# Add circle markers with GDP data
gdp_map <- addCircleMarkers(
  gdp_map,
  lng = ~longitude,
  lat = ~latitude,
  # radius = ~sqrt(GDP.per.capita) / 100,
  fillColor = ~custom_color(GDP.per.capita),
  fillOpacity = 0.7,
  stroke = FALSE,
  label = ~paste(name, "$", format(GDP.per.capita)),
  labelOptions = labelOptions(noHide = TRUE, direction = "auto")
)

# Add legend for GDP data
gdp_map <- addLegend(
  gdp_map,
  position = "bottomright",
  colors = custom_color(gdp$GDP.per.capita),
  labels = comma(formatC(quantile(gdp$GDP.per.capita, probs = seq(0, 1, 0.25)), big.mark = ",")),
  title = "GDP ($)",
  opacity = 1
)

# Show the map
gdp_map

```


```{r}
# Get the unique country names from your dataset
unique_countries <- unique(gdp$country)

# Get the latitude and longitude coordinates for each country using rworldmap
country_coords <- sapply(unique_countries, function(x) {
  ifelse(is.na(country.to.ISO3(x)), NA, 
         (getMap()[match(country.to.ISO3(x), getMap()$ISO3), c("LAT", "LON")]))
})

# Convert the resulting matrix to a dataframe
country_coords_df <- data.frame(Lat = country_coords[1, ], Long = country_coords[2, ], row.names = colnames(country_coords))

# Add the country names as a column in the dataframe
country_coords_df$Country <- row.names(country_coords_df)

# Merge the latitude and longitude data with your original dataframe
my_data_with_coords <- merge(gdp, country_coords_df, by = "Country")

```
```{r}
gov <- read.csv(file.choose())
gov

```


```{r}
gov_spending <- gov %>%
  filter(gov, TIME == "2020")

gov_spending
```


```{r}
per <- read_excel(file.choose())
per
```


```{r}
# Define custom color function based on GDP values
custom_color <- colorFactor(
  palette = c("#fef0d9", "#fdcc8a", "#fc8d59", "#e34a33", "#b30000"),
  domain = gdp$GDP.per.capita
)

# Set up the map
gdp_map <- leaflet(gdp) %>%
  addTiles() %>%
  setView(lng = mean(gdp$longitude), lat = mean(gdp$latitude), zoom = 4)

# Add circle markers with GDP data
gdp_map <- addCircleMarkers(
  gdp_map,
  lng = ~longitude,
  lat = ~latitude,
  # radius = ~sqrt(GDP.per.capita) / 100,
  fillColor = ~custom_color(GDP.per.capita),
  fillOpacity = 0.7,
  stroke = FALSE,
  label = ~paste(name, "$", format(GDP.per.capita)),
  labelOptions = labelOptions(noHide = TRUE, direction = "auto")
)

# Add legend for GDP data
gdp_map <- addLegend(
  gdp_map,
  position = "bottomright",
  colors = custom_color(gdp$GDP.per.capita),
  labels = comma(formatC(quantile(gdp$GDP.per.capita, probs = seq(0, 1, 0.25)), big.mark = ",")),
  title = "GDP ($)",
  opacity = 1
)

# Show the map
gdp_map

```

