
-- =========================================
-- 🧠 ADVANCED SQL ANALYTICS
-- E-commerce SQL Project
-- Focus: Window functions, business KPIs, advanced insights
-- =========================================

								--	CHECKING TABLES 
							
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM order_payments LIMIT 5;
SELECT * FROM order_reviews LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM geolocation LIMIT 5;
SELECT * FROM product_category LIMIT 5;


								-- STRATEGIC ANALAYTICS 

--Q1. RUNNING TOTAL REVENUE ( COMULATIVE GROWTH )
--- Purpose: Track cumulative revenue over time

	SELECT DATE(o.order_purchase_timestamp) AS order_date ,
	SUM(op.payment_value) AS daily_revenue , 
	SUM(SUM(op.payment_value)) 
	OVER( ORDER BY  DATE(o.order_purchase_timestamp) ) AS running_revenue 
	FROM orders o 
	JOIN order_payments op
	ON o.order_id = op.order_id 
	GROUP BY  DATE(o.order_purchase_timestamp) 
	ORDER BY order_date ; 

--Q2. 	FIRST ORDER PER  CUSTOMER 
--- Purpose: Identify each customer’s first purchase

	WITH ranked_customers AS (
	SELECT customer_id, order_id , order_purchase_timestamp ,
	ROW_NUMBER() OVER ( PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS rn
	FROM orders
	)
	SELECT * FROM ranked_customers 
	WHere rn = 1 ; 

--Q3. GAP BETWEEN ORDERS 
--- Purpose: Measure time difference between purchases

SELECT customer_id , order_id , order_purchase_timestamp ,
LAG(order_purchase_timestamp) OVER ( PARTITION BY customer_id ORDER BY order_purchase_timestamp) AS prev_orders,
DATE(order_purchase_timestamp ) - 
DATE(LAG(order_purchase_timestamp) OVER ( PARTITION BY customer_id ORDER BY order_purchase_timestamp) ) AS days_gab
FROM orders

--Q4. TOP PRODUCTS PER CATEGORY 
-- Purpose: Identify best product in each category

	SELECT DISTINCT p.product_id , p.product_category_name , SUM(op.payment_value) AS revenue 
	FROM products p 
	JOIN order_items oi
	ON p.product_Id = oi.product_id 
	JOIN order_payments op 
	ON oi.order_Id =  op.order_Id 
	GROUP BY p.product_id, p.product_category_name 
	ORDER BY revenue DESC 
	limit 10  ;
	