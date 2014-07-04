---
title       : Shiny Earthquakes
subtitle    : a interactive map of earthquakes in Shiny
author      : Giacomo Debidda
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow
widgets     : [bootstrap, quiz, shiny, interactive, mathjax]
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
ext_widgets : {rCharts: [libraries/nvd3]}
--- &radio

## Do you know how many earthquakes occur each year?

1. 10
2. 100
3. 1000
4. _1,000,000+_

*** .hint

*Remember:* ALL earthquakes, not just the big ones!

*** .explanation

The USGS estimates that several million earthquakes occur in the world each year. Many go undetected because they hit remote areas or have very small magnitudes. The NEIC now locates about 50 earthquakes each day, or about 20,000 a year. (*Credit: U.S. Geological Survey, Department of the Interior/USGS*)

--- 

## Where and When?

As you can hear from Michael Blanpied (U.S. Geological Survey) in this [podcast:](http://gallery.usgs.gov/audio/corecast/ep45/20080521_45_EarthquakePredictions.mp3)

> *"There is currently no organization government or scientist
> capable of succesfully predicting the time and occurrence of an earthquake."*  
>  
> Michael Blanpied

But we can still see where, when, and how many earthquakes **occurred**.  
First of all, we need some **good and recent data**...

*See also:* [USGS CoreCast.](http://www.usgs.gov/corecast/)

*Credit:* U.S. Geological Survey  
Department of the Interior/USGS  
U.S. Geological Survey/audio file by Jessica Robertson

---

## Get the Data


```r
# Required packages
library(shiny)
library(RJSONIO)
suppressPackageStartupMessages(library(googleVis))
```


```r
# Download USGS GeoJSON feed: data from Magnitude 4.5+ earthquakes occurred
# in the past 30 days (data on the USGS website is updated every 15 minutes)
url <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson"
```

``` 
# download GeoJSON file (~1.7 MB, code not evaluated here)
document <- fromJSON(content=url)
# Parse GeoJSON
metadata <- document$metadata
eq.properties <- lapply(document$features,function(xl) xl$properties) 
eq.geometry <- lapply(document$features,function(xl) xl$geometry)
```

--- 

## Here is ShinyEarthquakes!

![Screenshot of the App](https://raw.githubusercontent.com/jackaljack/ShinyEarthquakes/gh-pages/Screen.PNG)

What are you waiting for? [**Try me on ShinyApps!**](https://jackaljack.shinyapps.io/ShinyEarthquakes/)

*Code on* [*GitHub.*](https://github.com/jackaljack/ShinyEarthquakes)
