# 🍕 RushMore Pizzeria Enterprise Database System

## 📋 Project Overview
This project replaces a fragile JSON file system with a robust, scalable PostgreSQL database for RushMore Pizzeria's multi-location business.

## 🏗️ Architecture
- **Database**: PostgreSQL 15 on Google Cloud Platform (Cloud SQL)
- **Schema**: 8 tables in 3rd Normal Form (3NF)
- **Population**: Python script using Faker library (24,000+ rows)

## 📊 Schema Diagram
[Add your ERD diagram here - you'll need to upload it to GitHub first]

## ☁️ Cloud Deployment
- **Provider**: Google Cloud Platform
- **Service**: Cloud SQL for PostgreSQL
- **Instance**: `rushmore-pizzeria-db`
- **Region**: `europe-west2`
- **Public IP**: `34.105.198.171`

![Cloud SQL Dashboard](docs/screenshots/cloud_dashboard.png)

## 📈 Data Population Results
| Table | Row Count |
|-------|-----------|
| Stores | 5 |
| Menu Items | 42 |
| Ingredients | 43 |
| Customers | 1,769 |
| Orders | 6,244 |
| Order Items | 18,596 |
| Inventory | 182 |
| Recipes | 94 |
| **TOTAL** | **~26,975** |

![pgAdmin Tables](docs/screenshots/pgadmin_tables.png)

## 🔍 Analytics Queries

### 1. Total Sales Revenue per Store
```sql
SELECT s.city, s.address, SUM(o.total_amount) as total_revenue
FROM stores s
JOIN "order" o ON s.store_id = o.store_id
GROUP BY s.city, s.address
ORDER BY total_revenue DESC;
2. Top 10 Customers by Spending
sql
SELECT c.full_name, c.email, SUM(o.total_amount) as total_spent
FROM customer c
JOIN "order" o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.email
ORDER BY total_spent DESC
LIMIT 10;
3. Most Popular Menu Items
sql
SELECT mi.item_name, mi.item_category, SUM(oi.quantity) as total_quantity
FROM menu_items mi
JOIN order_items oi ON mi.item_id = oi.item_id
GROUP BY mi.item_name, mi.item_category
ORDER BY total_quantity DESC
LIMIT 10;
4. Average Order Value
sql
SELECT AVG(total_amount) as avg_order_value
FROM "order";
5. Busiest Hours of the Day
sql
SELECT EXTRACT(HOUR FROM order_time) as hour_of_day, 
       COUNT(*) as order_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM "order"), 2) as percentage
FROM "order"
GROUP BY hour_of_day
ORDER BY order_count DESC;
🛠️ Technologies Used
Cloud: Google Cloud SQL for PostgreSQL

Database: PostgreSQL 15

Language: Python 3

Libraries: psycopg2-binary, Faker, python-dotenv

Tools: pgAdmin, draw.io, VS Code

Version Control: Git/GitHub

🚀 Setup Instructions
Clone this repository

Install dependencies: pip install psycopg2-binary Faker python-dotenv

Create .env file with your database credentials

Run schema: psql -d rushmore_db -f sql/schema.sql

Run population: python3 scripts/populate.py

📁 Project Structure
text
rushmore-pizzeria-db/
├── docs/
│   ├── erd.png
│   └── screenshots/
│       ├── cloud_dashboard.png
│       └── pgadmin_tables.png
├── sql/
│   ├── schema.sql
│   └── analytics_queries.sql
├── scripts/
│   └── populate.py
├── .gitignore
└── README.md
👨‍💻 Author
Harry Guusu - Data Engineering Capstone Project

📅 Date
February 2026


