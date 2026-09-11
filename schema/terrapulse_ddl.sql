CREATE TABLE dim_categories (
	category_id 		INT 		AUTO_INCREMENT 		PRIMARY KEY, 
    category_name 		VARCHAR(100) 		UNIQUE 		NOT NULL
);

CREATE TABLE dim_currencies (
	currency_code 		CHAR(3) 	UNIQUE 				NOT NULL,
    currency_name 		VARCHAR(3) 						NOT NULL, 
    rate_to_usd 		DECIMAL(12, 6) 					NOT NULL
);

CREATE TABLE dim_customers  (
	customer_id INT AUTO_INCREMENT PRIMARY KEY, 
    first_name VARCHAR(30) NOT NULL, 
    last_name VARCHAR(30) NULL,
    full_name VARCHAR(30) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_clean CHAR (14) NOT NULL UNIQUE, 
    country VARCHAR(50) NOT NULL, 
    city VARCHAR(50) NOT NULL, 
    loyalty_score INT NOT NULL DEFAULT 500, 
    registration_date DATE NOT NULL 
);

CREATE TABLE dim_products (
	product_id 			INT				PRIMARY KEY, 
    sku_code 			VARCHAR(30) 	NOT NULL,
    product_name 		VARCHAR(100)	NOT NULL, 
    category_id 		INT				NOT NULL,
    unit_cost_usd 		DECIMAL(15,2) 	NOT NULL, 
    retail_price_usd 	DECIMAL(15,2) 	NOT NULL,
    warehouse_stock 	INT 			NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES dim_categories(category_id)
);


CREATE TABLE fct_orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT 				NOT NULL, 
    product_id 	INT					NOT NULL,
    currency_code CHAR(3)			NOT NULL, 
    order_date		DATE 			NOT NULL, 
    order_status	VARCHAR(30)		NOT NULL,
    quantity		INT 			NOT NULL, 
    unit_price_native VARCHAR(50)	NOT NULL, 
    unit_price_usd 	DECIMAL(15,2)	NOT NULL,
    gross_amount_usd DECIMAL(15,2)	NOT NULL, 
    discount_pct	DECIMAL(5,2)	NOT NULL 	DEFAULT 0.00, 
    discount_amount_usd	DECIMAL(15,2)	NOT NULL, 
    shipping_fee_usd	DECIMAL(15,2) NOT NULL, 
    net_revenue_usd DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_products(product_id),
    FOREIGN KEY(currency_code) REFERENCES dim_currencies(currency_code)
);

CREATE TABLE fct_logistics (
	order_id INT	PRIMARY KEY, 
    carrier_name VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(50) NOT NULL, 
    ship_date DATE NOT NULL, 
    shipping_lead_days INT NOT NULL, 
    warehouse_origin VARCHAR(50) NOT NULL,
	FOREIGN KEY (order_id) REFERENCES fct_orders(order_id)
);
