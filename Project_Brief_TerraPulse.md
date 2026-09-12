# Project TerraPulse: Global CleanTech Market Intelligence Engine

## SQL Capstone Project — Group 1 Brief

**Enterprise:** TerraPulse Global Ltd.
**Project Title:** Multi-Source Market Intelligence & Data Warehouse Pipeline
**Group Size:** 4 Students
**Timeline:** Saturday Night (Project Kick-Off) through Friday Class (Live Presentation)
**Daily Reports Required:** Monday, Tuesday, Wednesday, Thursday
**Final Presentation:** Friday, Live to Class

---

## Table of Contents

1. [Executive Context &amp; Your Role](#1-executive-context--your-role)
2. [The Multi-Source Data Landscape](#2-the-multi-source-data-landscape)
3. [Required Deliverables](#3-required-deliverables)
4. [Reporting Structure &amp; Daily Cadence](#4-reporting-structure--daily-cadence)
5. [Relational Schema Design (ERD)](#5-relational-schema-design-erd)
6. [Phase 1: Database Architecture (DDL)](#phase-1-database-architecture-ddl)
7. [Phase 2: Ingestion &amp; Staging](#phase-2-ingestion--staging)
8. [Phase 3: ETL Cleaning Pipeline](#phase-3-etl-cleaning-pipeline)
9. [Phase 4: Business Intelligence Queries](#phase-4-business-intelligence-queries)
10. [Phase 5: Transactions &amp; Data Integrity](#phase-5-transactions--data-integrity)
11. [Phase 6: Views &amp; Reporting Layer](#phase-6-views--reporting-layer)
12. [Presentation Slide Structure](#presentation-slide-structure)
13. [Publication Requirements](#publication-requirements)

---

## 1. Executive Context & Your Role

You have been retained as a **Data Engineering & Analytics Consulting Team** by **TerraPulse Global Ltd.**, a fast-growing international clean technology and renewable energy corporation operating across North America, Europe, the Middle East, Asia, and Africa.

TerraPulse manufactures and distributes:

- ☀️ Solar photovoltaic systems and off-grid energy storage
- ⚡ Electric vehicle (EV) charging infrastructure and e-mobility devices
- 🌐 Smart Grid IoT monitoring and energy management units
- 🌿 Eco-friendly home climate and water conservation technology
- 🏭 Industrial energy efficiency hardware and heat recovery systems

### The Problem

TerraPulse's commercial data currently lives across **5 completely disconnected raw data sources**, each collected from different regional systems and partner APIs. None of them share a consistent format, language, or data quality standard.

The Chief Commercial Officer has called an emergency data task force. Your team has exactly **one week** to:

1. Design a centralised relational data warehouse from scratch
2. Ingest and clean all 5 raw data feeds
3. Perform strategic intelligence analysis
4. Present findings and business recommendations to the executive team on Friday

---

## 2. The Multi-Source Data Landscape

All raw datasets are located in:
📁 `capstone_project_datasets/group1_terrapulse/`

| # | Filename | Format | Rows | What It Contains |
| :------- | :----------------------------------------- | :------------- | :------ | :-------------------------------------------------------------------------------------------- |
| Source 1 | `raw_source1_marketplace_orders.csv` | **CSV** | 500,000 | Global sales transactions in mixed currencies, dirty order statuses, 4 different date formats |
| Source 2 | `raw_source2_logistics_fulfillment.tsv` | **TSV** | 500,000 | Carrier tracking logs with whitespace-padded names, tab-delimited, mixed ship dates |
| Source 3 | `raw_source3_customer_demographics.json` | **JSON** | 15,000 | Customer profiles with inconsistent casing, multiple phone formats, missing fields |
| Source 4 | `raw_source4_supplier_catalog.csv` | **CSV** | 200 | Product catalog with costs, retail MSRPs, stock levels across 5 tech sectors |
| Source 5 | `raw_source5_fx_rates.json` | **JSON** | 8 | Foreign exchange rates for currency normalization (USD, EUR, GBP, NGN, CAD, JPY, AED, ZAR) |

### Known Data Quality Issues (Do NOT expect a clean dataset)

| Data Problem                       | Where Found                                                  | Examples in Raw Data                                                                        |
| :--------------------------------- | :----------------------------------------------------------- | :------------------------------------------------------------------------------------------ |
| **Inconsistent casing**      | Customers (names), Orders (status), Logistics (carrier)      | `"CHIDI"`, `"chidi"`, `"ChIdI"` / `"DELIVERED"`, `"delivered"`, `" Delivered "` |
| **Mixed date formats**       | Orders, Logistics                                            | `"2024-01-15"`, `"01/15/2024"`, `"15-Jan-2024"`, `"15/01/2024"`                     |
| **Multi-currency pricing**   | Orders                                                       | Same product priced in USD, EUR, GBP, NGN, CAD, JPY, AED, ZAR                               |
| **Whitespace contamination** | Carrier names, country names                                 | `"  DHL Express  "`, `"  FedEx International  "`                                        |
| **NULL / Missing values**    | Phones (~8%), Emails (~2%), Loyalty Scores (~6%), Ship Dates | Empty strings and nulls across all sources                                                  |
| **Dormant customers**        | 800 customers registered but with ZERO orders ever placed    | Present in Source 3; absent from Source 1                                                   |
| **Dead stock products**      | Some products never appear in any order                      | Must be identified using gap analysis                                                       |

---

## 3. Required Deliverables

### A. Primary SQL Pipeline Script

**File:** `[FirstName]_[LastName]_terrapulse.sql` *(one per individual)*
A complete, runnable SQL script containing all DDL, ETL, analytics queries, transactions, and views from Phase 1 through Phase 6. Every query must run without errors on MySQL 8.0+.

### B. Schema Design Diagram (ERD)

**File:** `group1_terrapulse_erd.png` or PDF
A complete Entity-Relationship Diagram showing all production tables, their columns, Primary Keys, Foreign Keys, data types, and cardinality relationships. Must be drawn using **dbdiagram.io**, **MySQL Workbench Reverse Engineer**, **draw.io**, or **Lucidchart** — not hand-drawn.

### C. Individual Technical Report

**File:** `[FirstName]_[LastName]_individual_report.pdf`Each student submits their own report (2–4 pages) covering:

- Their specific assigned tasks and contribution
- At least 3 business insights discovered
- What they found most challenging and how they resolved it
- At least 2 screenshots of query results in MySQL Workbench

> ⚠️ **Important:** Do NOT publish your Medium article or push to GitHub until the instructor reviews and approves your individual report. Approval will be communicated before Friday.

### D. Group Daily Progress Reports

**File:** `group1_daily_report_[day].pdf` (Monday, Tuesday, Wednesday, Thursday)
Submitted to the instructor each day by **9:00 PM**. See Section 4 for the daily template.

### E. Friday Presentation Slides

**File:** `group1_terrapulse_presentation.pptx` or Google Slides link
A 15-minute executive slide deck presented live in class on Friday. See Section 12 for slide structure.

### F. Medium Article (Upon Instructor Approval Only)

A collaborative, publication-quality Medium article (min. 1,500 words) including:

- Screenshots of key query results
- The final ERD diagram embedded
- Business insights in plain, non-technical language
- Professional project header image

### G. GitHub Repository (Upon Instructor Approval Only)

A public GitHub repository containing:

```
terrapulse-sql-project/
├── README.md                    (Project overview and setup instructions)
├── schema/
│   └── terrapulse_ddl.sql       (Full DDL: CREATE DATABASE to CREATE VIEW)
├── etl/
│   └── cleaning_pipeline.sql    (All ETL transformation queries)
├── analytics/
│   └── business_queries.sql     (All Phase 4 intelligence queries)
├── diagrams/
│   └── terrapulse_erd.png       (ERD diagram)
└── screenshots/
    └── (at least 6 screenshots of results)
```

---

## 4. Reporting Structure & Daily Cadence

### Daily Group Report Template (Mon–Thu, Due by 9 PM)

```
=================================================
 GROUP 1 — TERRAPULSE DAILY PROGRESS REPORT
 Day: [Monday / Tuesday / Wednesday / Thursday]
 Date: [Date]
=================================================

TEAM MEMBERS & ROLES:
- [Name 1] — [Role: e.g. Lead Data Engineer]
- [Name 2] — [Role: e.g. ETL Specialist]
- [Name 3] — [Role: e.g. Analytics Analyst]
- [Name 4] — [Role: e.g. Documentation & Slide Lead]

TODAY'S COMPLETED TASKS:
1. [Specific task completed — what query/table/feature was built]
2. [...]
3. [...]

QUERIES / WORK WRITTEN TODAY (paste 1–2 key examples):
---
[Query or code snippet goes here]
---

KEY FINDINGS & INSIGHTS DISCOVERED TODAY:
- [What did the data reveal? Any surprises?]
- [Any data quality issue discovered and how was it handled?]

BLOCKERS / CHALLENGES:
- [Any errors or blockers? What was tried?]
- [Questions for the instructor?]

TOMORROW'S PLAN:
- [What will the team focus on tomorrow?]
=================================================
```

### Individual Technical Report (Due Thursday Night)

Each team member independently submits a 2–4 page PDF. It must describe *their specific personal contribution* — not a copy of the group report. Every individual report must include:

- A brief personal summary paragraph
- Which specific phases or tasks you personally worked on
- At least 3 business insights you personally discovered
- At least 2 screenshots of your own query results

---

## 5. Relational Schema Design (ERD)

Below is the target production schema. Your ERD diagram must reflect this exact structure.

```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║              TERRAPULSE_DW — PRODUCTION SCHEMA (3NF)                               ║
╠══════════════════════════════════════════════════════════════════════════════════════╣
║                                                                                    ║
║  ┌─────────────────────────┐      ┌──────────────────────────────────────────────┐ ║
║  │    dim_currencies       │      │                fct_orders                    │ ║
║  ├─────────────────────────┤      ├──────────────────────────────────────────────┤ ║
║  │ PK currency_code CHAR(3)│◄─────│ PK  order_id           INT                  │ ║
║  │    currency_name VARCHAR │      │ FK  customer_id        INT ────────────┐    │ ║
║  │    rate_to_usd   DECIMAL │      │ FK  product_id         INT ──────────┐ │    │ ║
║  └─────────────────────────┘      │ FK  currency_code      CHAR(3)       │ │    │ ║
║                                   │     order_date          DATE          │ │    │ ║
║  ┌─────────────────────────┐      │     order_status        VARCHAR       │ │    │ ║
║  │    dim_products         │      │     quantity            INT           │ │    │ ║
║  ├─────────────────────────┤      │     unit_price_native   DECIMAL       │ │    │ ║
║  │ PK product_id    INT    │◄─────│     unit_price_usd      DECIMAL       │ │    │ ║
║  │    sku_code      VARCHAR │      │     gross_amount_usd    DECIMAL       │ │    │ ║
║  │    product_name  VARCHAR │      │     discount_pct        DECIMAL       │ │    │ ║
║  │ FK category_id   INT    │──┐   │     discount_amount_usd DECIMAL       │ │    │ ║
║  │    unit_cost_usd DECIMAL │  │   │     shipping_fee_usd    DECIMAL       │ │    │ ║
║  │    retail_price  DECIMAL │  │   │     net_revenue_usd     DECIMAL       │ │    │ ║
║  │    warehouse_stock INT  │  │   └──────────────────┬───────────────────┘ │    │ ║
║  └─────────────────────────┘  │                      │ (1-to-1)            │    │ ║
║                               │   ┌──────────────────▼──────────────────┐  │    │ ║
║  ┌─────────────────────────┐  │   │           fct_logistics              │  │    │ ║
║  │    dim_categories       │  │   ├─────────────────────────────────────┤  │    │ ║
║  ├─────────────────────────┤  │   │ PK/FK order_id       INT            │  │    │ ║
║  │ PK category_id   INT   │◄─┘   │       carrier_name   VARCHAR        │  │    │ ║
║  │    category_name VARCHAR │      │       tracking_number VARCHAR       │  │    │ ║
║  └─────────────────────────┘      │       ship_date       DATE          │  │    │ ║
║                                   │       shipping_lead_days INT        │  │    │ ║
║  ┌─────────────────────────┐      │       warehouse_origin VARCHAR      │  │    │ ║
║  │    dim_customers        │      └─────────────────────────────────────┘  │    │ ║
║  ├─────────────────────────┤                                                │    │ ║
║  │ PK customer_id   INT   │◄───────────────────────────────────────────────┘    │ ║
║  │    first_name    VARCHAR │◄────────────────────────────────────────────────────┘ ║
║  │    last_name     VARCHAR │                                                       ║
║  │    full_name     VARCHAR │                                                       ║
║  │    email         VARCHAR │                                                       ║
║  │    phone_clean   VARCHAR │                                                       ║
║  │    country       VARCHAR │                                                       ║
║  │    city          VARCHAR │                                                       ║
║  │    loyalty_score INT    │                                                       ║
║  │    registration_date DATE│                                                       ║
║  └─────────────────────────┘                                                       ║
╚══════════════════════════════════════════════════════════════════════════════════════╝

Cardinality:
  dim_categories ──< dim_products   (One category → many products)
  dim_customers  ──< fct_orders     (One customer → many orders)
  dim_products   ──< fct_orders     (One product → many orders)
  dim_currencies ──< fct_orders     (One currency → many orders)
  fct_orders     ──| fct_logistics  (One order → one logistics record)
```

---

## Phase 1: Database Architecture (DDL)

**Objective:** Design and create the full relational infrastructure for the `terrapulse_dw` data warehouse.

**1.1** Drop any existing `terrapulse_dw` database, create it fresh with `utf8mb4` character encoding, and select it as active.

**1.2** Create a **two-tier architecture**:

- **Staging Tables (`stg_*`):** All columns are permissive `VARCHAR` so raw data can be loaded without type conversion errors.
- **Production Tables (`dim_*`, `fct_*`):** Fully typed with Primary Keys, Foreign Key constraints, `NOT NULL` rules, `DEFAULT` values, and `DECIMAL(15, 2)` for all monetary fields.

**1.3** Production schema tables required:

- `dim_categories` (category_id, category_name)
- `dim_currencies` (currency_code, currency_name, rate_to_usd)
- `dim_customers` (customer_id, first_name, last_name, full_name, email, phone_clean, country, city, loyalty_score, registration_date)
- `dim_products` (product_id, sku_code, product_name, category_id FK, unit_cost_usd, retail_price_usd, warehouse_stock)
- `fct_orders` (order_id, customer_id FK, product_id FK, currency_code FK, order_date, order_status, quantity, unit_price_native, unit_price_usd, gross_amount_usd, discount_pct, discount_amount_usd, shipping_fee_usd, net_revenue_usd)
- `fct_logistics` (order_id FK PK, carrier_name, tracking_number, ship_date, shipping_lead_days, warehouse_origin)

---

## Phase 2: Ingestion & Staging

**Objective:** Load all 5 raw source files into the staging layer and verify counts.

**2.1** Import each raw file into its corresponding staging table using the MySQL Workbench Table Data Import Wizard for CSV/TSV files. For JSON files, either use Python to convert to CSV first, or use MySQL's `JSON_TABLE()` function.

**2.2** Verify ingestion counts using a `UNION ALL` summary:

```sql
-- Expected result: 5 rows, one per source
SELECT 'stg_fx_rates'   AS source_table, COUNT(*) AS row_count FROM stg_fx_rates
UNION ALL
SELECT 'stg_products',                   COUNT(*) FROM stg_products
UNION ALL
SELECT 'stg_customers',                  COUNT(*) FROM stg_customers
UNION ALL
SELECT 'stg_orders',                     COUNT(*) FROM stg_orders
UNION ALL
SELECT 'stg_logistics',                  COUNT(*) FROM stg_logistics;
```

**2.3** Write a **Data Quality Audit** across the staging tables to document the number of dirty records in each category before cleaning begins.

---

## Phase 3: ETL Cleaning Pipeline

**Objective:** Transform and load clean, standardized data from staging into production tables.

**3.1 — Currencies, Categories & Products:**
Populate dimension tables, applying `TRIM()` and correct data typing. Populate `dim_categories` first (unique category names), then link products to categories via FK.

**3.2 — Customer Standardization:**Apply when inserting into `dim_customers`:

- Title Case all name fields: `CONCAT(UPPER(LEFT(TRIM(col), 1)), LOWER(SUBSTRING(TRIM(col), 2)))`
- Build `full_name` safely using `CONCAT_WS(' ', first_name, last_name)` — handles NULL last name cleanly
- Replace missing loyalty scores with `500` using `COALESCE(NULLIF(TRIM(raw_loyalty_score), ''), '500')`
- Normalize all 4 date formats with `CASE WHEN` + `STR_TO_DATE()`:
  - `YYYY-MM-DD` → `STR_TO_DATE(col, '%Y-%m-%d')`
  - `MM/DD/YYYY` → `STR_TO_DATE(col, '%m/%d/%Y')`
  - `DD-Mon-YYYY` → `STR_TO_DATE(col, '%d-%b-%Y')`
  - `DD/MM/YYYY` → `STR_TO_DATE(col, '%d/%m/%Y')`

**3.3 — Order Status & Multi-Currency Conversion:**Apply when inserting into `fct_orders`:

- Standardize all order status variants to clean Title Case values using `TRIM()` + `UPPER(LEFT(...))` + `LOWER(SUBSTRING(...))`
- Join `stg_orders` → `stg_fx_rates` on `currency_code` to compute `unit_price_usd = unit_price_native × rate_to_usd`
- Compute all derived monetary columns with `ROUND(..., 2)`

**3.4 — Logistics Cleaning:**Apply when inserting into `fct_logistics`:

- `TRIM()` carrier names; replace blanks/NULLs with `'Unassigned'` using `CASE WHEN`
- Title Case carrier names
- Compute `shipping_lead_days` using `DATEDIFF(ship_date, order_date)`
- Join on `order_id` to get the clean order date from `fct_orders`

---

## Phase 4: Business Intelligence Queries

Execute the following strategic analyses. Each result should produce a complete, correctly ordered table ready for executive consumption.

**Q4.1 — Revenue & Profitability by Product Category:**
Total units sold, gross revenue, total discounts lost, net revenue, total cost, gross profit, and profit margin % per category. Filter: Delivered + Shipped orders only.

**Q4.2 — Geographic Revenue Distribution:**
Order count, net revenue, and % share of global revenue by customer country. Rank countries descending.

**Q4.3 — Currency Exposure Analysis:**
Orders by currency, native revenue total, USD equivalent, and global % share. Identify the highest currency risk.

**Q4.4 — Carrier SLA Performance Audit:**
Per carrier: total shipments, average lead time, maximum lead time, and a 3-tier SLA classification using `CASE WHEN`.

**Q4.5 — Customer Value Segmentation:**
Lifetime spend, order count, average order value, and a 4-tier customer segment label per customer.

**Q4.6 — Dormant Customer Anti-Join:**
All customers who have never placed an order. Show name, country, registration date, and days since registration.

**Q4.7 — Dead Stock & Capital Audit:**
All products never ordered. Show product name, category, retail price, warehouse stock, and total capital tied up (`stock × unit_cost`).

**Q4.8 — Monthly Revenue Trend (2023 vs 2024):**
Month-by-month net revenue comparison between both years using `YEAR()` and `MONTHNAME()`.

---

## Phase 5: Transactions & Data Integrity

**Scenario:** A new international green tariff policy requires a price adjustment. A junior analyst makes an accidental mass update midway.

**5.1** `START TRANSACTION;`
**5.2** Apply a **+15% cost increase** to all `'Renewable Energy & Solar'` products.
**5.3** `SAVEPOINT after_solar_update;`
**5.4** *(Deliberate error)* A junior analyst runs: `UPDATE dim_products SET unit_cost_usd = 50.00;` ← destroys all prices.
**5.5** Run a `SELECT` to demonstrate the corrupted state.
**5.6** `ROLLBACK TO SAVEPOINT after_solar_update;`
**5.7** Apply a **+8% cost increase** to all `'EV Mobility & Charging'` products correctly.
**5.8** `COMMIT;` and run a final `SELECT` to confirm both correct changes are saved.

---

## Phase 6: Views & Reporting Layer

**6.1** `vw_monthly_revenue_dashboard` — Revenue, units, and profit by year, month, and category.
**6.2** `vw_customer_360` — Lifetime order count, total spend, average order value, last order date, and loyalty tier per customer.
**6.3** `vw_dead_stock_alert` — All never-ordered products with tied-up capital value.

---

## Presentation Slide Structure

*(15 minutes total — approximately 2 minutes per slide)*

| Slide | Title                                        | Content                                                                        |
| :---: | :------------------------------------------- | :----------------------------------------------------------------------------- |
|   1   | **Project Overview**                   | Company name, problem statement, team names and roles                          |
|   2   | **Data Architecture**                  | Flow diagram: 5 raw sources → staging → ETL → production warehouse → views |
|   3   | **Relational Schema (ERD)**            | Your ERD diagram with key relationships narrated                               |
|   4   | **Revenue & Profitability**            | Category-level revenue bar chart + profit margin table                         |
|   5   | **Geographic & Currency Intelligence** | Country revenue map/table + currency exposure risk                             |
|   6   | **Customer Segments & Churn Signals**  | 4-tier customer breakdown + dormant customer count                             |
|   7   | **Logistics SLA Audit**                | Carrier ranking + lead time performance tier table                             |
|   8   | **Strategic Recommendations**          | Minimum 3 data-backed business recommendations                                 |

---

## Publication Requirements

### Medium Article (After Instructor Approval Only)

- Minimum 1,500 words
- Must include: ERD screenshot, at least 10 query result screenshots, narrative explanation
- Written for a business/professional audience
- Use a compelling title (e.g., *"How We Unified 1 Million Rows of Global CleanTech Data in MySQL — A Team's Journey"*)

### GitHub Repository (I will review this after your presentation. But, it has to be live by then)

- Must be public
- Well-written `README.md` with project context, technology stack, and setup guide
- Meaningful commit history showing incremental progress (not a single final dump)
- Organized in folders as specified in Section 3

---

*TerraPulse Global Ltd. | Veracity+ SQL Program | Instructor: Petre Pann*
