ShinyEarthquakes
====================

ShinyEarthquakes is a simple Web Application built with the  Shiny package for R.

This application download a GeoJSON feed from the [USGS](http://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php) website. The GeoJSON feed is updated every 15 minutes and it refers to the Magnitude 4.5+ earthquakes occurred in the past 30 days.

This Web Application downloads the feed, parses it and responds to the user's inputs showing only the earthquakes having the selected conditions.

You can also run this application locally. Here are the R packages you will need:

```{r}
# Required packages
library(shiny)
library(RJSONIO)
suppressPackageStartupMessages(library(googleVis))
```
In order to run the application you have to write this command in the R Console:

```S
runApp()
```

How to use ShinyEarthquakes on ShinyApps:

1. Select the Region
2. Choose min-max Magnitude with the Range Slider
3. Choose min-max Depth with the Range Slider
4. Update View


Here is the link for the Slidify presentation: [ShinyEarthquakes](http://jackaljack.github.io/ShinyEarthquakes)

Note: you will need an internet connection to download the USGS feed (it's about 1.7 MB).
