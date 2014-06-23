
require(googleVis)
require(shiny)





shinyServer(function(input, output) {
  
  Year <- reactive({input$Year})
  Disease <- reactive({input$Disease})
  Zip <- reactive({input$Zip})
  
  output$city_county <- renderPrint({
    zip_rate_dat <- subset(cleaned_dat,  (disease == Disease()) & (zip_code == Zip()))
    my_city <- zip_rate_dat$city[1]
    my_county <- zip_rate_dat$county[1]
    print(paste("City:",my_city))
    print(paste("County:",my_county))  
  })
  
  output$bar_plot <- renderPlot({   
    zip_rate_dat <- subset(cleaned_dat,  (disease == Disease()) & (zip_code == Zip()))
    zip_rates <- zip_rate_dat$obs_rate
    my_county <- zip_rate_dat$county[1]
    county_rate_dat <- subset(cleaned_dat,  (disease == Disease()) & (county == my_county))
    attach(county_rate_dat)
    county_rates <- tapply(obs_rate, year,mean)
    detach(county_rate_dat)
    state_dat <- subset(cleaned_dat,  (disease == Disease()) )    
    state_rates <- tapply(state_dat$obs_rate,state_dat$year,mean)
      
    counts <- rbind(zip_rates, county_rates, state_rates)
    
    barplot(counts, main="Zip Code, County, State Average Rates By Year",
            xlab="Year", col=rainbow(3),
           beside=TRUE)
    legend("topright", c("Zip","County","State"), fill = rainbow(3))
  })
  
  output$box_plot <- renderPlot({   
    ad <- subset(cleaned_dat,  (disease == Disease()) & (obs_rate < 20000))
    boxplot(ad$obs_rate~ad$year,
            horizontal = TRUE,
         xlab = "Observed rate",
         main = "State-wide Observed rate by Year")  
    })

  
  output$gvis <- renderGvis({
    my_dat <- subset(cleaned_dat, (year == Year()) & (disease == Disease()))
    gvisGeoChart(my_dat, locationvar='longlat', colorvar='obs_rate', sizevar = 'population',
                 hovervar = 'zip_code',
                       options=list(region='US-NY', resolution = "metros",
                                    width = 1000, height=550,
                                    enableRegionInteractivity = T,
                                    displayMode='markers',
                                    markerOpacity = 0.85,
                                    colorAxis="{values:[0,400,800,1200],
                                   colors:[\'green', \'orange\', \'pink',\'red']}")
    ) 

  })
})
