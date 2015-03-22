
library(shinydashboard)
library(shinyapps)
library(shiny)
library(shinythemes)

shinyUI(dashboardPage(
  dashboardHeader(title = ""),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Info", tabName = "Info", icon = icon("fa fa-info-circle")), #for some reason this tab is lost when publishing but the info text below is printed
      menuItem("View", tabName = "View", icon = icon("fa fa-eye")),
      menuItem("Descriptives", tabName = "Descriptives", icon = icon("fa fa-bar-chart")),
      menuItem("Analyze", tabName = "Analyze", icon = icon("fa fa-calculator")),
      menuItem("Download", tabName = "Download", icon = icon("fa fa-download"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName="Info",
              mainPanel("Choose to view, get descriptive data, analyze or download the data by clicking on the tabs to your left.
                        A data set on performance management of Norwegian governmental agencies in 2012 is used as an example. 
                        Further guidelines on how to use the application are given under each main tab.")
      ),        
      tabItem(tabName="View",
              fluidRow(
                sidebarPanel(
                  helpText("Select the variables you want to view below. In the appearing data frame 
                           choose the number of entries, make global search or search within each column at the bottom."),
                  checkboxGroupInput("show_vars", "Variables:",
                                     names(Data))
                ), 
              mainPanel(
                dataTableOutput("Dataview"))
              )
      ),
      tabItem(tabName="Descriptives",
              fluidRow(
                tabBox(
                  title="",
                id="Descriptives",
                tabsetPanel(
                tabPanel("Plot", verbatimTextOutput("caption"),
                         plotOutput("histplot"),
                         verbatimTextOutput("caption1"),
                         plotOutput("binplot")
                         ),
                tabPanel("Table", "Summary statistics of the dependent variables",
                         tableOutput("desc.table")
                         ), 
                id = "conditionedPanels"
                )
              ),
              sidebarPanel(
                conditionalPanel(condition="input.conditionedPanels == 'Plot'",
                helpText("Select numerical or binary variables below, 
                         and receive a histogram (top) or barplot (bottom) accordingly"),
                tabPanel("Numerical",
                  selectInput("variable", "Numerical Variables:",
                              names(Data[, c(3:7,11,13:14)]), selected="Goals"),
                  sliderInput("bins",
                              "Number of bins:",
                              min = 1,
                              max = 20,
                              value = 10)
                ),
                tabPanel("Binary",
                         selectInput("binvar", "Binary Variables:",
                                     names(Data[, c(8:10,12)]), selected="")
                )
                ),
                conditionalPanel(condition="input.conditionedPanels == 'Table'",
                                 helpText("Create a table with summary statistics of the 
                                          variables selected from the list below."),
                                 checkboxGroupInput("desctable", "Variables:",
                                                    names(Data[, c(3:15)]), selected = c("Goals", "Input"))
                                 )
      ))
      ),
     tabItem(tabName="Analyze",
             fluidRow(
               tabBox(
                 title="",
                 id="Analysis",
                 tabPanel("Count model", "Results from negative binomial regression",
                          tableOutput("nbmodel.table")
                 ),
                 tabPanel("Linear model", "Results from linear regression",
                          tableOutput("lmmodel.table")
                 )
             ),
             sidebarPanel(
               helpText("Set up a regression model by selecting a dependent and a set of independent variables from the list below.
                        Use the tabs above the table to switch between estimation methods."),
               tabPanel("Dependent variable",
                 selectInput("dependent", "Dependent variable:",
                              names(Data[, 3:7]), selected="Goals")
               ),
               tabPanel("Independent variables",
                        checkboxGroupInput("independent", "Independent variables:",
                                           names(Data[, 8:15]), selected="Num_Tasks")
               )))
               ), 

        tabItem(tabName="Download",
            fluidRow(
              downloadButton('downloadData', 'Click here to download the data in csv-format')
            )
    )
    )
  )
)
)
