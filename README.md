# terrapulse-sql-project

## Project Overview
A MySQL-based data warehouse unifying five disconnected source systems (currencies, products, customers, orders, and logistics) for TerraPulse Global Ltd, a cleantech manufacturer. This project cleans, transforms, and analyzes 1.03M+ records to answer key business intelligence questions around revenue, customer segmentation, and logistics performance.

Originally a 4-person capstone (Group 1), completed solo by Faith after the team could not continue — covering database design, ETL pipeline, business intelligence queries, transaction integrity, and reporting views.

## Tech Stack
- MySQL 8.0
- MySQL Workbench

## Setup
1. Run schema/terrapulse_ddl.sql to create the database and all tables
2. Load the 5 raw source files into their staging tables
3. Run etl/cleaning_pipeline.sql to clean and populate the production tables
4. Run views/terrapulse_views.sql to create the reporting views
5. Run queries in analytics/business_queries.sql for business intelligence results

