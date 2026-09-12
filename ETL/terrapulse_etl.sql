INSERT INTO dim_categories (category_name)
SELECT DISTINCT TRIM(category)
FROM stg_products
WHERE category IS NOT NULL AND category != '';


INSERT INTO dim_products (product_id, sku_code, product_name, category_id, unit_cost_usd, retail_price_usd, warehouse_stock)
SELECT
    sp.product_id,
    TRIM(sp.sku_code),
    TRIM(sp.product_name),
    dc.category_id,
    CAST(sp.unit_cost_usd AS DECIMAL(15,2)),
    CAST(sp.retail_price_usd AS DECIMAL(15,2)),
    CAST(sp.warehouse_stock AS UNSIGNED)
FROM stg_products sp
JOIN dim_categories dc ON dc.category_name = TRIM(sp.category);


INSERT INTO dim_currencies (currency_code, currency_name, rate_to_usd)
SELECT
    TRIM(currency_code),
    TRIM(currency_name),
    CAST(rate_to_usd AS DECIMAL(12,6))
FROM stg_fx_rates;



INSERT INTO dim_customers (customer_id, first_name, last_name, full_name, email, phone_clean, country, city, loyalty_score, registration_date)
SELECT
    sc.customer_id,
    CONCAT(UPPER(LEFT(TRIM(sc.raw_first_name),1)), LOWER(SUBSTRING(TRIM(sc.raw_first_name),2))) AS first_name,
    CONCAT(UPPER(LEFT(TRIM(sc.raw_last_name),1)), LOWER(SUBSTRING(TRIM(sc.raw_last_name),2))) AS last_name,
    CONCAT_WS(' ',
        CONCAT(UPPER(LEFT(TRIM(sc.raw_first_name),1)), LOWER(SUBSTRING(TRIM(sc.raw_first_name),2))),
        CONCAT(UPPER(LEFT(TRIM(sc.raw_last_name),1)), LOWER(SUBSTRING(TRIM(sc.raw_last_name),2)))
    ) AS full_name,
    COALESCE(NULLIF(TRIM(sc.contact_email), ''), CONCAT('unknown_', sc.customer_id, '@unknown.com')),
    NULLIF(TRIM(sc.raw_phone), ''),
    TRIM(sc.raw_country),
    TRIM(sc.raw_city),
    CAST(COALESCE(NULLIF(TRIM(sc.raw_loyalty_score), ''), '500') AS UNSIGNED),
    CASE
        WHEN sc.raw_registration_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(sc.raw_registration_date, '%Y-%m-%d')
        WHEN sc.raw_registration_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
             AND CAST(SUBSTRING(sc.raw_registration_date,1,2) AS UNSIGNED) > 12
            THEN STR_TO_DATE(sc.raw_registration_date, '%d/%m/%Y')
        WHEN sc.raw_registration_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(sc.raw_registration_date, '%m/%d/%Y')
        WHEN sc.raw_registration_date REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$'
            THEN STR_TO_DATE(sc.raw_registration_date, '%d-%b-%Y')
        ELSE NULL
    END AS registration_date
FROM stg_customers sc;



INSERT INTO fct_orders (order_id, customer_id, product_id, currency_code, order_date, order_status, quantity, unit_price_native, unit_price_usd, gross_amount_usd, discount_pct, discount_amount_usd, shipping_fee_usd, net_revenue_usd)
SELECT
    so.order_id,
    so.customer_id,
    so.product_id,
    so.currency_code,
    CASE
        WHEN so.raw_order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(so.raw_order_date, '%Y-%m-%d')
        WHEN so.raw_order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
             AND CAST(SUBSTRING(so.raw_order_date,1,2) AS UNSIGNED) > 12
            THEN STR_TO_DATE(so.raw_order_date, '%d/%m/%Y')
        WHEN so.raw_order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(so.raw_order_date, '%m/%d/%Y')
        WHEN so.raw_order_date REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$'
            THEN STR_TO_DATE(so.raw_order_date, '%d-%b-%Y')
        ELSE NULL
    END,
    CONCAT(UPPER(LEFT(TRIM(so.raw_status),1)), LOWER(SUBSTRING(TRIM(so.raw_status),2))),
    so.quantity,
    CAST(so.unit_price_native AS DECIMAL(15,2)),
    ROUND(CAST(so.unit_price_native AS DECIMAL(15,2)) * fx.rate_to_usd, 2),
    ROUND(CAST(so.unit_price_native AS DECIMAL(15,2)) * fx.rate_to_usd * so.quantity, 2),
    CAST(so.discount_pct AS DECIMAL(5,2)),
    ROUND(CAST(so.unit_price_native AS DECIMAL(15,2)) * fx.rate_to_usd * so.quantity * (CAST(so.discount_pct AS DECIMAL(5,2))/100), 2),
    CAST(so.shipping_fee_usd AS DECIMAL(15,2)),
    ROUND(
        (CAST(so.unit_price_native AS DECIMAL(15,2)) * fx.rate_to_usd * so.quantity)
        - (CAST(so.unit_price_native AS DECIMAL(15,2)) * fx.rate_to_usd * so.quantity * (CAST(so.discount_pct AS DECIMAL(5,2))/100))
        + CAST(so.shipping_fee_usd AS DECIMAL(15,2)), 2)
FROM stg_orders so
JOIN dim_currencies fx ON fx.currency_code = so.currency_code;



INSERT INTO fct_logistics (order_id, carrier_name, tracking_number, ship_date, shipping_lead_days, warehouse_origin)
SELECT
    sl.order_id,
    CASE WHEN TRIM(sl.raw_carrier_name) = '' THEN 'Unassigned' ELSE TRIM(sl.raw_carrier_name) END,
    TRIM(sl.tracking_number),
    CASE
        WHEN sl.raw_ship_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(sl.raw_ship_date, '%Y-%m-%d')
        WHEN sl.raw_ship_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
             AND CAST(SUBSTRING(sl.raw_ship_date,1,2) AS UNSIGNED) > 12
            THEN STR_TO_DATE(sl.raw_ship_date, '%d/%m/%Y')
        WHEN sl.raw_ship_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(sl.raw_ship_date, '%m/%d/%Y')
        WHEN sl.raw_ship_date REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$'
            THEN STR_TO_DATE(sl.raw_ship_date, '%d-%b-%Y')
        ELSE NULL
    END AS ship_date,
    DATEDIFF(
        CASE
            WHEN sl.raw_ship_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN STR_TO_DATE(sl.raw_ship_date, '%Y-%m-%d')
            WHEN sl.raw_ship_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                 AND CAST(SUBSTRING(sl.raw_ship_date,1,2) AS UNSIGNED) > 12
                THEN STR_TO_DATE(sl.raw_ship_date, '%d/%m/%Y')
            WHEN sl.raw_ship_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
                THEN STR_TO_DATE(sl.raw_ship_date, '%m/%d/%Y')
            WHEN sl.raw_ship_date REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$'
                THEN STR_TO_DATE(sl.raw_ship_date, '%d-%b-%Y')
            ELSE NULL
        END,
        fo.order_date
    ) AS shipping_lead_days,
    TRIM(sl.raw_warehouse_origin)
FROM stg_logistics sl
JOIN fct_orders fo ON fo.order_id = sl.order_id;
