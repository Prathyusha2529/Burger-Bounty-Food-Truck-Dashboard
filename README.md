# Burger-Bounty-Food-Truck-Dashboard

**Description**
The Burger Bounty Food Truck Dashboard is a data-driven application designed to optimize location strategy and maximize revenue for a food truck operation based in Hartford, Connecticut. By leveraging localized data, the project provides actionable insights into pricing strategies, menu item sales predictions, and optimal truck placements across Hartford and neighboring towns.

**Key Features**
**Hartford-Focused Data Analysis**
Analyzes data specific to Hartford, CT, and nearby towns (e.g., West Hartford, East Hartford, Glastonbury, Manchester, New Britain, Wethersfield).
Considers local variables such as events, weather conditions, and weekend activity patterns.
Sales Prediction Models

**Predicts sales for popular menu items, including:**
Bounty Hunter
Classic Cheeseburger
Spicy Mutiny
Nature Bounty
BEC
Double Veggie

**Incorporates:** 

**Pricing strategies**
Weather factors (precipitation, temperature)

**Local events**
Weekend vs. weekday dynamics

**Revenue Optimization**
Calculates expected revenue by integrating sales predictions and pricing strategies.
Recommends optimal locations and price points to maximize profitability.

**Interactive Dashboard**
- Built with Shiny, the user-friendly interface allows:
- Adjusting pricing for menu items.
- Inputting weather and event data.
- Predicting sales and revenue for various scenarios.
- Viewing a ranked list of towns based on revenue potential.
- Local Events & Weather Integration
- Tailors recommendations based on event data in Hartford and surrounding towns.
- Adjusts predictions dynamically using weather forecasts.

**How to Use**

**Upload Data**
Ensure data for visits, prices, and sales is available in Excel format.

**Run the Application**
Launch the app to interact with the dashboard.

**Input Parameters**
Set menu prices, weather conditions, and event presence through the UI.

**Review Recommendations**
Explore detailed predictions for sales and revenue across multiple locations.
Technical Stack

**Programming Language:** R
**Libraries:**
readxl – Import data from Excel files.
lm – Build linear regression models.
shiny & shinydashboard – Develop interactive UI and visualize data.

**Data Sources:**
Localized sales, pricing, and visit data for Hartford, CT.
