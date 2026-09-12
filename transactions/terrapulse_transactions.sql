START TRANSACTION;

-- 5.1: Restore original costs from staging (baseline before demo)
UPDATE dim_products dp
JOIN stg_products sp ON sp.product_id = dp.product_id
SET dp.unit_cost_usd = CAST(sp.unit_cost_usd AS DECIMAL(15,2));

-- 5.2: Apply correct +15% cost increase to Renewable Energy & Solar
UPDATE dim_products dp
JOIN dim_categories dc ON dc.category_id = dp.category_id
SET dp.unit_cost_usd = dp.unit_cost_usd * 1.15
WHERE dc.category_name = 'Renewable Energy & Solar';

-- 5.3: Savepoint after the correct, intended update
SAVEPOINT after_solar_update;

-- 5.4: Deliberate corruption - simulates a mistaken mass update
UPDATE dim_products SET unit_cost_usd = 50.00;

-- 5.5: Proof of damage - every product flattened to 50.00
SELECT product_id, product_name, unit_cost_usd FROM dim_products LIMIT 10;

-- 5.6: Rollback to savepoint, undoing only the corruption
ROLLBACK TO SAVEPOINT after_solar_update;

-- 5.7: Apply correct +8% cost increase to EV Mobility & Charging
UPDATE dim_products dp
JOIN dim_categories dc ON dc.category_id = dp.category_id
SET dp.unit_cost_usd = dp.unit_cost_usd * 1.08
WHERE dc.category_name = 'EV Mobility & Charging';

-- 5.8: Commit both correct updates
COMMIT;

-- 5.9: Verification - confirm exact expected multipliers against original staging values
SELECT
    dc.category_name,
    COUNT(*) AS mismatches
FROM dim_products dp
JOIN dim_categories dc ON dc.category_id = dp.category_id
JOIN stg_products sp ON sp.product_id = dp.product_id
WHERE
    (dc.category_name = 'Renewable Energy & Solar' AND ABS(dp.unit_cost_usd - CAST(sp.unit_cost_usd AS DECIMAL(15,2)) * 1.15) > 0.02)
    OR (dc.category_name = 'EV Mobility & Charging' AND ABS(dp.unit_cost_usd - CAST(sp.unit_cost_usd AS DECIMAL(15,2)) * 1.08) > 0.02)
GROUP BY dc.category_name;
-- Expected result: 0 rows (no mismatches)
