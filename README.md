RushMore Pizzeria Enterprise Database System
Project Overview
This project replaces a fragile JSON file system with a robust, scalable PostgreSQL database for RushMore Pizzeria's multi-location business. The database serves as a single source of truth for 
all operational data including stores, customers, menu items, orders, and inventory.

Architecture
Database: PostgreSQL 15 on Google Cloud Platform (Cloud SQL)

Schema: 8 tables in 3rd Normal Form (3NF)

Population: Python script using Faker library generating 24,000+ rows of realistic test data

Cloud Deployment
Provider: Google Cloud Platform

Service: Cloud SQL for PostgreSQL

Instance: rushmore-pizzeria-db

Region: europe-west2 (London)

Public IP: 34.105.198.171

Data Population Results
Stores: 5
Menu Items: 42
Ingredients: 43
Customers: 1,769
Orders: 6,244
Order Items: 18,596
Inventory: 182
Recipes: 94
Total Rows: Approximately 26,975

Analytics Queries
The following SQL queries were used to answer key business questions:

1. Total Sales Revenue per Store
SELECT s.city, s.address, SUM(o.total_amount) as total_revenue
FROM stores s
JOIN "order" o ON s.store_id = o.store_id
GROUP BY s.city, s.address
ORDER BY total_revenue DESC;

2. Top 10 Customers by Spending
SELECT c.full_name, c.email, SUM(o.total_amount) as total_spent
FROM customer c
JOIN "order" o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.email
ORDER BY total_spent DESC
LIMIT 10;

3. Most Popular Menu Items
SELECT mi.item_name, mi.item_category, SUM(oi.quantity) as total_quantity_sold
FROM menu_items mi
JOIN order_items oi ON mi.item_id = oi.item_id
GROUP BY mi.item_name, mi.item_category
ORDER BY total_quantity_sold DESC
LIMIT 20;

4. Average Order Value
SELECT AVG(total_amount) as avg_order_value
FROM "order";

5. Busiest Hours of the Day
SELECT EXTRACT(HOUR FROM order_time) as hour_of_day, COUNT(*) as order_count
FROM "order"
GROUP BY hour_of_day
ORDER BY order_count DESC;

Looker Studio Analytics Dashboard
Looker Studio was connected directly to the Cloud SQL PostgreSQL database to create an interactive business analytics dashboard.

Dashboard Preview
https://docs/Rushmore_dashboard.png

Dashboard PDF
A PDF version of the dashboard is available for download:
RushMore Dashboard PDF

Key Insights
Total Orders: 6,244

Screenshots Documentation
All deployment and pgAdmin screenshots are available in:
Screenshots Word Document

Setup Instructions
Clone this repository

Install dependencies: pip install psycopg2-binary Faker python-dotenv

Create a .env file with your database credentials

Run the schema: psql -d rushmore_db -f sql/rushmore_schema.sql

Run the population script: python3 scripts/populate.py

Technologies Used
Cloud: Google Cloud SQL for PostgreSQL

Database: PostgreSQL 15

Language: Python 3

Libraries: psycopg2-binary, Faker, python-dotenv

Tools: pgAdmin, draw.io, VS Code, Looker Studio

Version Control: Git/GitHub

Author
Harry Guusu - Data Engineering Capstone Project

Date
February 2026
