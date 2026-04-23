

-- =========================================
-- 📊 FULL KPI DASHBOARD ANALYSIS
-- E-commerce SQL Project
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


							-- FINAL KPI DASHBOARD 

--Q: Full KPI Summary (Revenue, Orders, Avg Value)
-- Purpose: High-level business performance overview

	WITH base AS (
	SELECT 
	c.customer_unique_id ,
	o.order_id, 
	o.order_purchase_timestamp,
	o.order_delivered_customer_date
	FROM customers c 
	JOIN orders o  ON c.customer_id = o.customer_id 
	),
	revenue AS (
	SELECT order_id , 
	SUM(price + freight_value) AS Revenue 
	FROM order_items
	GROUP BY order_id
	),
	delivery AS (
	SELECT order_id ,
	AVG( EXTRACT ( DAY FROM order_delivered_customer_date - order_purchase_timestamp  )) AS delivery_days 
	FROM orders 
	WHERE order_purchase_timestamp IS NOT NULL 
	GROUP BY order_id 
	),
	reviews AS (
	SELECT order_id , 
	AVG(review_score) AS avg_reviews 
	FROM order_reviews 
	GROUP BY order_id 
	),
	repeat_customers AS (
	SELECT customer_unique_id 
	FROM base 
	GROUP BY customer_unique_id
	HAVING COUNT(order_id) > 1 
)
SELECT 
	SUM(r.revenue) AS total_revenue,
	AVG(r.revenue) AS avg_revenue,

	COUNT(DISTINCT b.order_id ) AS total_orders ,

	COUNT(b.customer_unique_id) AS total_customers,

	COUNT( Distinct rc.customer_unique_id) AS repeat_customers ,

	ROUND(COUNT(DISTINCT rc.customer_unique_id ) * 100.0 / COUNT( DISTINCT b.customer_unique_id ),2 ) AS repeat_rate_percent ,

	AVG(d.delivery_days) AS avg_delivery_days , 

	AVG(rv.avg_reviews) AS avg_review_score

FROM base b 
LEFT JOIN revenue r 
ON b.order_id = r.order_id 
LEFT JOIN delivery d 
ON b.order_id = d.order_id 
LEFT JOIN reviews rv
ON b.order_id = rv.order_id 
LEFT JOIN repeat_customers rc 
ON b.customer_unique_id = rc.customer_unique_id ; 