shinyUI(pageWithSidebar(
  
  headerPanel("Shiny Earthquakes"),
  
  sidebarPanel(
    selectInput("region", "Region", c("Entire World"="world", "Europe"="150", "Asia"="142",
                                         "Americas"="019", "Africa"="002", "Oceania"="009")),
    # Specify range of magnitude
    sliderInput("rangeMag", "Magnitude (Richter scale)", min = 4, max = 10, step=0.1, value = c(4.5,8)),
    # Specify range of depth
    sliderInput("rangeDep", "Depth (Km)", min = 1, max = 800, step=50, value = c(1,400)),
    submitButton("Update View"),
    # Instructions
    hr(),
    helpText(strong("How to use this App:")),
    helpText("1.Select the Region"),
    helpText("2.Choose min-max Magnitude with the Range Slider"),
    helpText("3.Choose min-max Depth with the Range Slider"),
    helpText("4. Update View"),
    # Credit
    hr(),
    helpText( "Data from", a("USGS website", href="http://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php", target="_blank") ),
    helpText("Data refers to Magnitude 4.5+ earthquakes occurred in the past 30 days and is updated every 15 minutes."),
    helpText(em("Note:You will need an internet connection to download the USGS feed (it's about 1.7 MB)."))
  ),
  
  mainPanel(    
    
    h3(textOutput("caption1")),
    h3(textOutput("caption2")),

    h4("GoogleVis GeoChart"),
    htmlOutput("gVisview"),
    
    h4("Head"),
    tableOutput("headView"),
    
    h4("Summary"),
    verbatimTextOutput("summaryView"),
    
    h4("Histogram of Magnitude"),
    plotOutput("histMagView"),
    
    h4("Histogram of Depth"),
    plotOutput("histDepView"),
    
    h4("List of all Earthquakes in the Region"),
    tableOutput("listView")

  )
  
))