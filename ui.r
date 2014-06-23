
require(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Medicaid Inpatient Disease Rate Distribution for Pediatric Hospital Discharges by Zip Code 2011-2012"),
  sidebarPanel(
    sliderInput("Year", "Year to be displayed:", 
                min=2011, max=2012, value=2012,  step=1,
                format="###0",animate=TRUE),
    selectInput("Disease", "Disease:",
                choices = listed_disease),
    selectInput("Zip", "Zip Code:",
                choices = listed_zip),
    verbatimTextOutput("city_county"),
    plotOutput("bar_plot",height = "400px"),
    plotOutput(outputId = "box_plot", height = "400px")
    ),
  mainPanel(
    htmlOutput("gvis")
  )
)
)