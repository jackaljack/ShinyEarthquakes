
# Required packages -------------------------------------------------------
library(shiny)
library(RJSONIO)
library(googleVis)
suppressPackageStartupMessages(library(googleVis))


# Download data -----------------------------------------------------------
# USGS feed: data from Magnitude 4.5+ earthquakes of the past 30 days (data updated every 15 minutes)
url <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_month.geojson" # ~1.7 MB
# download GeoJSON file
document <- fromJSON(content=url)


# Parse GeoJSON and create a dataframe ------------------------------------
# extract the USGS feed metadata
metadata <- document$metadata

# extract the list of the earthquakes' properties (this list has as many elements as the earthquakes)
eq.properties <- lapply(document$features,function(xl) xl$properties) 

# extract the list of the earthquakes' geometry (this list has as many elements as the earthquakes)
eq.geometry <- lapply(document$features,function(xl) xl$geometry) 

# create an empty dataframe
N <- metadata$count
df <- data.frame(Place  = character(N),
                 Magnitude  = numeric(N),
                 Time = numeric(N),
                 TimeChar = numeric(N), # head command doesn't work with objects of class Date
                 TimeZone = numeric(N),
                 Latitude  = numeric(N),
                 Longitude = numeric(N),
                 Depth     = numeric(N))

# populate the dataframe
# earthquake properties
df$Place <- sapply(eq.properties,function(xl) xl$place)
df$Magnitude <- sapply(eq.properties,function(xl) xl$mag)
df$Time <- sapply(eq.properties,function(xl) xl$time)
df$TimeZone <- sapply(eq.properties,function(xl) xl$tz)
# earthquake coordinates
df$Latitude <- sapply(eq.geometry,function(xl) xl$coordinates[2])
df$Longitude <- sapply(eq.geometry,function(xl) xl$coordinates[1])
df$Depth <- sapply(eq.geometry,function(xl) xl$coordinates[3])


# Data processing (change classes, group variables, etc) ------------------
# convert date from numeric to POSIXct, and from POSIXct to Date
df$Time <- as.Date(as.POSIXct(df$Time/1000, origin="1970-01-01"))
df$TimeChar <- as.character(df$Time)
# convert TimeZone (if there are any null elements, they cause problems)
tm.zone <- replace(df$TimeZone, sapply(df$TimeZone, function(x) is.null(x)), NA)
# time zone varies within [-720, +720] (it's the positive/negative offset from UTC, in minutes)
df$TimeZone <- as.numeric(tm.zone)
# gvisGeoChart requires locationvar variable to be expressed in this way: 'latitude:longitude'
df$Coordinates <- paste(df$Latitude, df$Longitude, sep=":")


# Define server logic -----------------------------------------------------
shinyServer(function(input, output) { 
    
  reactiveDf <- reactive({ 
    # Return a subset of df() 
      subset(df, (  Magnitude > input$rangeMag[1] & Magnitude < input$rangeMag[2]
                  & Depth > input$rangeDep[1] & Depth < input$rangeDep[2]
                  & Longitude > reactiveCoord()[3] & Longitude < reactiveCoord()[4]
                  & Latitude > reactiveCoord()[1] & Latitude < reactiveCoord()[2]  )
             )
      })

# get reactive coordinates from the slider
reactiveCoord <- reactive({
    switch(input$region, 
           "world"= c(-90, 90, -180, 180),
           "150"= c(30, 70, -30, 60),
           "002"= c(-40, 40, -30, 60),
           "009"= c(-50, 20, 90, 180),
           "142"= c(0, 70, 30, 150),
           "019"= c(-60, 70, -165, -30))
  })
  
# get reactive region zone from the slider
reactiveRegion <- reactive({
  switch(input$region, 
         "world"= "the Entire World",
         "150"= "Europe",
         "002"= "Africa",
         "009"= "Oceania",
         "142"= "Asia",
         "019"= "the Americas")
})

formulaText <- reactive({
  paste("Earthquakes in ", reactiveRegion())
})

# Return formulaText for printing as a caption
output$caption1 <- renderText({
  formulaText()
})

  # googleVis GeoChart ------------------------------------------------------
  output$gVisview <- renderGvis({
    gvisGeoChart(data=reactiveDf(),
                 locationvar="Coordinates", colorvar="Magnitude", sizevar="Depth", hovervar="Place",
                 options=list(region=input$region, 
                              displayMode="Markers", 
                              colorAxis="{colors:['yellow', 'orange', 'red']}",
                              backgroundColor="lightblue"),
                 chartid="EarthquakesUSGS")
  })
  

  # Plots -------------------------------------------------------------------

  numberText <- reactive({
    paste("Total Number of Earthquakes in the Selected Region: ", dim(reactiveDf())[1] )
  })
  # Return numberText for printing
  output$caption2 <- renderText({
    numberText()
  })

  # include an histogram for Magnitude
  output$histMagView <- renderPlot({
    hist(reactiveDf()$Magnitude, main = "Histogram of Earthquake Magnitude",
         xlab="Magnitude (Richter)", col = "#33669988", border = "#000066")
  })

  # include an histogram for Depth
  output$histDepView <- renderPlot({
    hist(reactiveDf()$Depth, main = "Histogram of Earthquake Depth",
         xlab="Depth (Km)", col = "#33669988", border = "#000066")
  })
  
  # include a head of the data
  output$headView <- renderTable({
    head(x=subset(reactiveDf(), select=c(Place, Latitude, Longitude, Magnitude, Depth, TimeChar)))
  })

  # include a summary of the data
  output$summaryView <- renderPrint({
    summary(object=subset(reactiveDf(), select=c(Magnitude, Depth, Time)))
  })

  # include the list of all the earthquakes in the chosen region
  output$listView <- renderTable({
    subset(reactiveDf(), select=c(Place, Latitude, Longitude, Magnitude, Depth, TimeChar))
  })
  
})