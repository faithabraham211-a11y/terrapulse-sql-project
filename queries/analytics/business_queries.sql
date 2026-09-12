-- Q4.1: Revenue & Profitability by Product Category
SELECT
    dc.category_name,
    SUM(fo.quantity) AS total_units_sold,
    ROUND(SUM(fo.gross_amount_usd), 2) AS gross_revenue,
    ROUND(SUM(fo.discount_amount_usd), 2) AS total_discounts_lost,
    ROUND(SUM(fo.net_revenue_usd), 2) AS net_revenue,
    ROUND(SUM(fo.quantity * dp.unit_cost_usd), 2) AS total_cost,
    ROUND(SUM(fo.net_revenue_usd) - SUM(fo.quantity * dp.unit_cost_usd), 2) AS gross_profit,
    ROUND(
        (SUM(fo.net_revenue_usd) - SUM(fo.quantity * dp.unit_cost_usd)) / SUM(fo.net_revenue_usd) * 100, 2
    ) AS profit_margin_pct
FROM fct_orders fo
JOIN dim_products dp ON dp.product_id = fo.product_id
JOIN dim_categories dc ON dc.category_id = dp.category_id
WHERE fo.order_status IN ('Delivered', 'Shipped')
GROUP BY dc.category_name
ORDER BY net_revenue DESC;

-- Q4.2: Geographic Revenue Distribution
SELECT
    dcu.country,
    COUNT(*) AS order_count,
    ROUND(SUM(fo.net_revenue_usd), 2) AS net_revenue,
    ROUND(SUM(fo.net_revenue_usd) / (SELECT SUM(net_revenue_usd) FROM fct_orders) * 100, 2) AS pct_global_revenue
FROM fct_orders fo
JOIN dim_customers dcu ON dcu.customer_id = fo.customer_id
GROUP BY dcu.country
ORDER BY net_revenue DESC;

-- Q4.3: Currency Exposure Analysis
SELECT
    fo.currency_code,
    COUNT(*) AS order_count,
    ROUND(SUM(fo.unit_price_native * fo.quantity), 2) AS native_revenue_total,
    ROUND(SUM(fo.gross_amount_usd), 2) AS usd_equivalent,
    ROUND(SUM(fo.gross_amount_usd) / (SELECT SUM(gross_amount_usd) FROM fct_orders) * 100, 2) AS pct_global_share
FROM fct_orders fo
GROUP BY fo.currency_code
ORDER BY usd_equivalent DESC;

-- Q4.4: Carrier SLA Performance Audit (carrier names deduplicated)
SELECT
    CASE
        WHEN carrier_name LIKE '%ARAMEX%' THEN 'Aramex'
        WHEN carrier_name LIKE '%KUEHNE%' THEN 'Kuehne+Nagel'
        WHEN carrier_name LIKE '%FEDEX%' THEN 'FedEx International'
        WHEN carrier_name LIKE '%DHL%' THEN 'DHL Express'
        WHEN carrier_name LIKE '%UPS%' THEN 'UPS Worldwide'
        WHEN carrier_name LIKE '%MAERSK%' THEN 'Maersk Freight'
        WHEN carrier_name = 'Unassigned' THEN 'Unassigned'
        ELSE carrier_name
    END AS carrier_name,
    COUNT(*) AS total_shipments,
    ROUND(AVG(shipping_lead_days), 2) AS avg_lead_time_days,
    MAX(shipping_lead_days) AS max_lead_time_days,
    CASE
        WHEN AVG(shipping_lead_days) <= 5 THEN 'Tier 1 - Excellent'
        WHEN AVG(shipping_lead_days) <= 6.5 THEN 'Tier 2 - Acceptable'
        ELSE 'Tier 3 - Needs Review'
    END AS sla_tier
FROM fct_logistics
WHERE shipping_lead_days IS NOT NULL
GROUP BY carrier_name
ORDER BY avg_lead_time_days ASC;

-- Q4.5: Customer Value Segmentation (quartile-based)
SELECT
    dc.customer_id,
    dc.full_name,
    dc.country,
    COUNT(fo.order_id) AS order_count,
    ROUND(SUM(fo.net_revenue_usd), 2) AS lifetime_spend,
    ROUND(AVG(fo.net_revenue_usd), 2) AS avg_order_value,
    CASE
        WHEN SUM(fo.net_revenue_usd) >= 175630 THEN 'Platinum'
        WHEN SUM(fo.net_revenue_usd) >= 134161 THEN 'Gold'
        WHEN SUM(fo.net_revenue_usd) >= 102881 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_segment
FROM dim_customers dc
JOIN fct_orders fo ON fo.customer_id = dc.customer_id
GROUP BY dc.customer_id, dc.full_name, dc.country
ORDER BY lifetime_spend DESC;

-- Q4.6: Dormant Customer Anti-Join
SELECT
    dc.customer_id,
    dc.full_name,
    dc.country,
    dc.registration_date,
    DATEDIFF(CURDATE(), dc.registration_date) AS days_since_registration
FROM dim_customers dc
LEFT JOIN fct_orders fo ON fo.customer_id = dc.customer_id
WHERE fo.order_id IS NULL
ORDER BY days_since_registration DESC;

-- Q4.7: Dead Stock & Capital Audit
SELECT
    dp.product_name,
    dc.category_name,
    dp.retail_price_usd,
    dp.warehouse_stock,
    ROUND(dp.warehouse_stock * dp.unit_cost_usd, 2) AS capital_tied_up
FROM dim_products dp
JOIN dim_categories dc ON dc.category_id = dp.category_id
LEFT JOIN fct_orders fo ON fo.product_id = dp.product_id
WHERE fo.order_id IS NULL
ORDER BY capital_tied_up DESC;

-- Q4.8: Monthly Revenue Trend (2023 vs 2024)
SELECT
    MONTHNAME(order_date) AS month_name,
    MONTH(order_date) AS month_num,
    ROUND(SUM(CASE WHEN YEAR(order_date) = 2023 THEN net_revenue_usd ELSE 0 END), 2) AS revenue_2023,
    ROUND(SUM(CASE WHEN YEAR(order_date) = 2024 THEN net_revenue_usd ELSE 0 END), 2) AS revenue_2024
FROM fct_orders
WHERE YEAR(order_date) IN (2023, 2024)
GROUP BY month_name, month_num
ORDER BY month_num;
