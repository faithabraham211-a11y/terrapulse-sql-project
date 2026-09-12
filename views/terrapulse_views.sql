-- 6.1: Monthly revenue and profit dashboard, by category
CREATE VIEW vw_monthly_revenue_dashboard AS
SELECT
    YEAR(fo.order_date) AS order_year,
    MONTH(fo.order_date) AS order_month,
    MONTHNAME(fo.order_date) AS month_name,
    dc.category_name,
    SUM(fo.quantity) AS total_units,
    ROUND(SUM(fo.net_revenue_usd), 2) AS net_revenue,
    ROUND(SUM(fo.net_revenue_usd) - SUM(fo.quantity * dp.unit_cost_usd), 2) AS gross_profit
FROM fct_orders fo
JOIN dim_products dp ON dp.product_id = fo.product_id
JOIN dim_categories dc ON dc.category_id = dp.category_id
GROUP BY order_year, order_month, month_name, dc.category_name;

-- 6.2: 360-degree customer view (includes dormant customers via LEFT JOIN)
CREATE VIEW vw_customer_360 AS
SELECT
    dc.customer_id,
    dc.full_name,
    dc.country,
    dc.loyalty_score,
    COUNT(fo.order_id) AS lifetime_order_count,
    ROUND(SUM(fo.net_revenue_usd), 2) AS total_spend,
    ROUND(AVG(fo.net_revenue_usd), 2) AS avg_order_value,
    MAX(fo.order_date) AS last_order_date,
    CASE
        WHEN dc.loyalty_score >= 750 THEN 'Platinum'
        WHEN dc.loyalty_score >= 500 THEN 'Gold'
        WHEN dc.loyalty_score >= 250 THEN 'Silver'
        ELSE 'Bronze'
    END AS loyalty_tier
FROM dim_customers dc
LEFT JOIN fct_orders fo ON fo.customer_id = dc.customer_id
GROUP BY dc.customer_id, dc.full_name, dc.country, dc.loyalty_score;

-- 6.3: Dead stock alert - products with zero orders ever
CREATE VIEW vw_dead_stock_alert AS
SELECT
    dp.product_id,
    dp.product_name,
    dc.category_name,
    dp.retail_price_usd,
    dp.warehouse_stock,
    ROUND(dp.warehouse_stock * dp.unit_cost_usd, 2) AS capital_tied_up
FROM dim_products dp
JOIN dim_categories dc ON dc.category_id = dp.category_id
LEFT JOIN fct_orders fo ON fo.product_id = dp.product_id
WHERE fo.order_id IS NULL;

-- Verification queries (confirm each view returns expected results)
SELECT * FROM vw_monthly_revenue_dashboard ORDER BY order_year, order_month LIMIT 10;
SELECT * FROM vw_customer_360 ORDER BY total_spend DESC LIMIT 10;
SELECT * FROM vw_dead_stock_alert;
-- Note: vw_dead_stock_alert returns 0 rows - all 200 products
-- in the catalog have sold at least once. This is a genuine
-- finding (a well-curated catalog), not an error.
