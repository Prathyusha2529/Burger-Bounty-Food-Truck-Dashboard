library(readxl)

# Read the data from Excel file
burger_data <- readxl::read_excel("~/Downloads/BurgerBounty.xlsx", sheet = "Visits")
prices_data <- readxl::read_excel("~/Downloads/BurgerBounty.xlsx", sheet = "Prices")
sales_data <- readxl::read_excel("~/Downloads/BurgerBounty.xlsx", sheet = "Sales")

# Merge data frames
combined_data <- merge(burger_data, prices_data, by = "Date", all.x = TRUE)
combined_data <- merge(combined_data, sales_data, by = "Date", all.x = TRUE)

attach(combined_data)


# Create a linear regression model
model1 <- lm(`Bounty Hunter.y`~`Bounty Hunter.x`+Town+Time+Precipitation+Temperature+Event+Weekend)
model2 <- lm(`Classic Cheeseburger.y`~`Classic Cheeseburger.x`+Town+Time+Precipitation+Temperature+Event+Weekend)
model3 <- lm(`Spicy Mutiny.y`~`Spicy Mutiny.x`+Town+Time+Precipitation+Temperature+Event+Weekend)
model4 <- lm(`Nature Bounty.y`~`Nature Bounty.x`+Town+Time+Precipitation+Temperature+Event+Weekend)
model5 <- lm(BEC.y~BEC.x+Town+Time+Precipitation+Temperature+Event+Weekend)
model6 <- lm(`Double Veggie.y`~`Double Veggie.x`+Town+Time+Precipitation+Temperature+Event+Weekend)

# Display regression summary
print(summary(model1))
print(summary(model2))
print(summary(model3))
print(summary(model4))
print(summary(model5))
print(summary(model6))

# Predict sales for a given set of variables for the first model (Bounty Hunter)
new_data <- data.frame(
  `Bounty Hunter.x` = 9,
  Town = "Downtown Hartford",
  Time = 2,
  Precipitation = 0.2,
  Temperature = 70,
  Event = "Yes",
  Weekend = "No"
)
colnames(new_data) = c(colnames(combined_data)[9], "Town", "Time", "Precipitation", "Temperature", "Event", "Weekend")

predicted_sales1 <- predict(model1,new_data)

# Calculate predicted revenue
price_per_burger1 <- new_data$`Bounty Hunter.x`
predicted_revenue1 <- predicted_sales1 * price_per_burger1

# Display predicted results for the first model
cat("Predicted Sales (Bounty Hunter):", predicted_sales1, "\n")
cat("Predicted Revenue (Bounty Hunter):", predicted_revenue1 , "\n")


library(shiny)
library(shinydashboard)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Location Recommendations"),
  dashboardSidebar(
    width = 400, 
    tabsetPanel(
      tabPanel("Location", 
               sliderInput("hours", "Hours to be spent at the location:", value = 2, min=1, max=24),
               sliderInput("precipitation", "Average Precipitation:", value = 0.2, min=.1, max = 1),
               sliderInput("temperature", "Average Temperature:", value = 70, min=10, max=100),
               selectInput("weekend", "Visit on Weekend Day?", choices = c("Yes", "No"), selected = "No")
      ),
      tabPanel("Events",
               selectInput("downtown", "Is there an event in Downtown Hartford?",  choices = c("Yes", "No"), selected = "No"),
               selectInput("eastHartford", "Is there an event in East Hartford?",  choices = c("Yes", "No"), selected = "No"),
               selectInput("glastonbury", "Is there an event in Glastonbury?",  choices = c("Yes", "No"), selected = "No"),
               selectInput("manchester", "Is there an event in Manchester?",  choices = c("Yes", "No"), selected = "No"),
               selectInput("newBritain", "Is there an event in New Britain?",  choices = c("Yes", "No"), selected = "No"),
               selectInput("westHartford", "Is there an event in West Hartford?",  choices = c("Yes", "No"), selected = "No"),
               selectInput("wethersfield", "Is there an event in Wethersfield?",  choices = c("Yes", "No"), selected = "No")
      ),
      tabPanel("Prices",
               sliderInput("price_bounty_hunter", "Planned Price for Bounty Hunter:", value = 6, min = 1, max = 20,step=1),
               sliderInput("price_classic_cheeseburger", "Planned Price for Classic Cheeseburger:", value = 7, min = 1, max = 20,step=1),
               sliderInput("price_spicy_mutiny", "Planned Price for Spicy Mutiny:", value = 5.5, min = 1, max = 20,step=1),
               sliderInput("price_nature_bounty", "Planned Price for Nature Bounty:", value = 8, min = 1, max = 20,step=1),
               sliderInput("price_bec", "Planned Price for BEC:", value = 5, min = 1, max = 20,step=1),
               sliderInput("price_double_veggie", "Planned Price for Double Veggie:", value = 6, min = 1, max = 20,step=1)
      )
    ),
    actionButton("recommendations_button", "Recommendations")
  ),
  dashboardBody(
    # Output table
    tableOutput("recommendations_table")
  )
)


server <- function(input, output) {
  observeEvent(input$recommendations_button, {
    towns <- c("Downtown Hartford", "West Hartford", "East Hartford", "Glastonbury", "Manchester", "New Britain", "Wethersfield")
    
    # Create an empty data frame to store results
    final_table <- data.frame(
      Town = character(),
      Bounty_Hunter = numeric(),
      Classic_Cheeseburger = numeric(),
      Spicy_Mutiny = numeric(),
      Nature_Bounty = numeric(),
      BEC = numeric(),
      Double_Veggie = numeric(),
      Predicted_Revenues = numeric(),
      stringsAsFactors = FALSE
    )
    
    for (town in towns) {
      data <- data.frame(
        Bounty.Hunter.x = input$price_bounty_hunter,
        Classic.Cheeseburger.x = input$price_classic_cheeseburger,
        Spicy.Mutiny.x = input$price_spicy_mutiny,
        Nature.Bounty.x = input$price_nature_bounty,
        BEC.x = input$price_bec,
        Double.Veggie.x = input$price_double_veggie,
        Town = town,
        Time = input$hours,
        Precipitation = input$precipitation,
        Temperature = input$temperature,
        Event = if (town == "Downtown Hartford") input$downtown
        else if (town == "East Hartford") input$eastHartford
        else if (town == "Glastonbury") input$glastonbury
        else if (town == "Manchester") input$manchester
        else if (town == "New Britain") input$newBritain
        else if (town == "West Hartford") input$westHartford
        else input$wethersfield,
        Weekend = input$weekend
      )
      
      colnames(data) <- colnames(combined_data)[c(9:14, 3:8)]
      
      # Predictions for the current town
      bounty <- round(predict(model1, data), 2)
      classic_cheese <- round(predict(model2, data), 2)
      spicy_mutiny <- round(predict(model3, data), 2)
      nature_bounty <- round(predict(model4, data), 2)
      bec <- round(predict(model5, data), 2)
      double_veggie <- round(predict(model6, data), 2)
      
      # Calculate revenue for the current town
      revenue <- round(bounty * input$price_bounty_hunter +
                         classic_cheese * input$price_classic_cheeseburger +
                         spicy_mutiny * input$price_spicy_mutiny +
                         nature_bounty * input$price_nature_bounty +
                         bec * input$price_bec +
                         double_veggie * input$price_double_veggie, 2)
      
      # Create a row for the current town
      town_row <- c(town, bounty, classic_cheese, spicy_mutiny, nature_bounty, bec, double_veggie, revenue)
      
      # Append the row to the final_table
      final_table <- rbind(final_table, town_row)
    }
    
    # Set column names
    colnames(final_table) <- c("Town", "Bounty Hunter", "Classic Cheeseburger", "Spicy Mutiny", "Nature Bounty", "BEC", "Double Veggie", "Predicted Revenues")
    
    # Render the table
    output$recommendations_table <- renderTable({final_table})
  })
}


shinyApp(ui, server)
