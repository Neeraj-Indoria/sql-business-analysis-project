
-- =========================================
-- 🟡 PRODUCT & CATEGORY ANALYTICS
-- E-commerce SQL Project
-- Focus: Product performance, category trends, demand analysis
-- =========================================
			
			
			
			-- CHECKING TABLES 

SELECT * FROM customers LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;									
SELECT * FROM order_payments LIMIT 5;
SELECT * FROM order_reviews LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM geolocation LIMIT 5;
SELECT * FROM product_category LIMIT 5;




						-- 	PRODUCT & CATEGORY ANALYSIS 

--Q1. TOP BEST SELLING PRODUCT 
--Purpose: Identify top products by revenue

	SELECT oi.product_id , SUM(op.payment_value) AS revenue 
	FROM order_items oi 
	JOIN order_payments op 
	ON oi.order_id = op.order_id 
	GROUP by oi.product_id 
	ORDER BY revenue DESC
	limit 10 ; 

--Q2. TOP PRDUCTS CATEGORY BY REVENUE 
--- Purpose: Analyze revenue contribution of each category

	SELECT p.product_category_name , SUM(op.payment_value) AS revenue 
	FROM products p 
	JOIN order_items oi 
	ON p.product_id = oi.product_id 
	JOIN order_payments op 
	ON oi.order_id = op.order_id 
	GROUP BY p.product_category_name 
	ORDER BY revenue DESC 
	LIMIT 10 ; 
	
--Q3. CATEGORY RANKING 
--- Purpose: Rank categories based on revenue performance

	WITH category_revenue AS (
	SELECT p.product_category_name , SUM(op.payment_value) AS revenue 
	FROM products p 
	JOIN order_items oi 
	ON p.product_id = oi.product_id 
	JOIN order_payments op 
	ON oi.order_id = op.order_id 
	GROUP BY p.product_category_name 
	ORDER BY revenue DESC 
	LIMIT 10 
	)
	SELECT *,
	RANK() OVER( ORDER BY revenue DESC ) AS rank_category 
	FROM category_revenue 
	ORDER BY rank_category  ; 


--Q4. SEASONALS TRENDS 
--- Purpose: Understand category performance over time

	SELECT EXTRACT( MONTH FROM o.order_purchase_timestamp ) AS month, 
	oi.product_id , SUM(payment_value) AS revenue 
	FROM orders o 
	JOIN order_items oi 
	ON o.order_id = oi.order_id 
	JOIN order_payments op 
	ON o.order_id = op.order_id 
	GROUP BY EXTRACT( MONTH FROM o.order_purchase_timestamp ), oi.product_id
	ORDER by month ; 

--Q5. CANCELATON RATE 
-- Purpose: Identify products bought together in orders

	SELECT COUNT(*) AS total_orders , 
	COUNT( CASE 
	WHEN order_status = 'canceled' then 1 end ) AS order_canceled ,
	ROUND(
	COUNT( CASE WHEN order_status = 'canceled' THEN 1 end ) * 100.0 / count(*),2 
	) AS cancelation_rate 
	FROM orders ; 


	